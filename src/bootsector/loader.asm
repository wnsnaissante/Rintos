[bits 16]
[org 0x0000]

start:
    cli
    cld
    push cs
    pop ds
    push cs
    pop es
    mov ax, ds
    mov ss, ax
    mov sp, 0xFFFE
    sti
    mov ah, 0x00
    mov al, 0x03
    int 0x10
    mov si, msg2
    call print_string
    jmp switch_pm

; GDT
; [0] Null
; [1] Code: base=0, limit=4GB-1, access=0x9A, gran=0xCF
; [2] Data: base=0, limit=4GB-1, access=0x92, gran=0xCF
gdt_start:
    dq 0
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 0x9A
    db 0xCF
    db 0x00
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 0x92
    db 0xCF
    db 0x00
gdt_end:

gdtr:
    dw gdt_end - gdt_start - 1
    dd 0

switch_pm:
    xor ebx, ebx
    mov bx, cs
    shl ebx, 4
    CODE_DESC equ gdt_start + 8
    DATA_DESC equ gdt_start + 16
    mov eax, ebx
    mov [CODE_DESC + 2], ax
    shr eax, 16
    mov [CODE_DESC + 4], al
    mov [CODE_DESC + 7], ah
    xor eax, eax
    mov [DATA_DESC + 2], ax
    mov [DATA_DESC + 4], al
    mov [DATA_DESC + 7], ah
    mov eax, gdt_start
    add eax, ebx
    mov [gdtr + 2], eax
    cli
    lgdt [gdtr]
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp dword CODE_SEL:pm_entry

CODE_SEL equ 0x08
DATA_SEL equ 0x10

print_string:
    mov ah, 0x0E
.print_char:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .print_char
.done:
    ret

msg2 db "Stage 2 loaded and running!", 0

; ----- Protected-mode 32-bit code -----
[bits 32]
pm_entry:
    mov ax, DATA_SEL
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x009FC00

    mov dword [0xB8000], 0x074D0750

.hang:
    jmp .hang