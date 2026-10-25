[bits 64]

long_mode_main:
    mov ax, DATA_SEG_64
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    mov edi, 0xB8000
    mov rcx, 500
    mov rax, 0x1F201F201F201F20    
    rep stosq

    mov rax, 0x1F6C1F6C1F651F48
    mov [edi], rax

    mov rax, 0x1F6F1F571F201F6F
    mov [edi + 8], rax

    mov rax, 0x1F211F641F6C1F72
    mov [edi + 16], rax

    mov edi, 0xB8000

    call reset_cursor

    jmp $

reset_cursor:
    mov dx, 0x3D4
    mov al, 0x0E
    out dx, al

    mov dx, 0x3D5
    xor al, al
    out dx, al

    mov dx, 0x3D4
    mov al, 0x0F
    out dx, al

    mov dx, 0x3D5
    xor al, al
    out dx, al

    ret