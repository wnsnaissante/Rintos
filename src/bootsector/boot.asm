[bits 16]
[org 0x7C00]

%define LOADER_SEG     0x1000
%define LOADER_OFF     0x0000
%define LOADER_SECTORS 16

start:
    mov [boot_drive], dl
    
    mov ax, 0x0000
    mov es, ax
    mov ds, ax

    call clear_screen
    mov si, boot_msg
    call print_string

    call enable_a20_gate_w_bios
    call check_a20
    cmp al, 1
    je a20_success

    call enable_a20_gate_w_syscon_port
    call check_a20
    cmp al, 1
    je a20_success

    jmp a20_fail

clear_screen:
    mov ah, 0x00
    mov al, 0x03
    int 0x10
    ret

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

hang:
    jmp hang

enable_a20_gate_w_bios:
    mov ax, 0x2401
    int 0x15
    ret

enable_a20_gate_w_syscon_port:
    in al, 0x92
    or al, 2
    out 0x92, al
    ret

check_a20:
    push si
    push di
    push ds

    mov ax, 0x0000
    mov es, ax
    mov di, 0x0500

    mov ax, 0xFFFF
    mov ds, ax
    mov si, 0x0510

    mov bl, [es:di]
    mov bh, [ds:si]

    mov byte [es:di], 0xAA
    mov byte [ds:si], 0x55

    mov al, [es:di]
    cmp al, 0xAA

    mov byte [es:di], bl
    mov byte [ds:si], bh

    pop ds
    pop di
    pop si

    jne .a20_off

.a20_on:
    mov al, 1
    ret

.a20_off:
    mov al, 0
    ret

a20_fail:
    mov si, failed_a20_msg
    call print_string
    jmp hang

a20_success:
    mov si, successed_a20_msg
    call print_string

    mov si, loading_msg
    call print_string

    call load_stage2

    mov ax, LOADER_SEG ; 2nd stage loader segment
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0xFFFE

    jmp LOADER_SEG:LOADER_OFF

load_stage2:
    push ax
    push bx
    push cx
    push dx
    push es

    mov ax, LOADER_SEG
    mov es, ax
    xor bx, bx

    mov ah, 0x00
    mov dl, [boot_drive]
    int 0x13

    mov si, 3
.read_try:
    mov ah, 0x02
    mov al, LOADER_SECTORS
    xor ch, ch
    mov cl, 2
    xor dh, dh
    mov dl, [boot_drive]

    int 0x13
    jnc .ok

    mov ah, 0x00
    mov dl, [boot_drive]
    int 0x13
    dec si
    jnz .read_try

    mov si, disk_error_msg
    call print_string
    jmp hang

.ok:
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    ret

; Data
boot_msg db "Stage 1: A20 check...", 13, 10, 0
failed_a20_msg db "A20 FAILED.", 13, 10, 0
successed_a20_msg db "A20 OK.", 13, 10, 0
loading_msg db "Loading...", 13, 10, 0
disk_error_msg db "Disk error. Cannot load 2nd stage.", 13, 10, 0
boot_drive db 0

times 510-($-$$) db 0
dw 0xAA55