[bits 16]
[org 0x0000]

start:
    cli
    cld
    
    ; Align data segments
    push cs
    pop ds
    push cs
    pop es
    
    ; Initialize stack
    mov ax, ds
    mov ss, ax
    mov sp, 0xFFFE
    sti
    
    ; Set text mode for clean output
    mov ah, 0x00
    mov al, 0x03
    int 0x10

    mov si, msg2
    call print_string

    jmp $

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
