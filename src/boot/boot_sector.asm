start:
    cli

    ; establish known segment registers
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax  

    ; simple temp stack
    mov sp, 0x7C00

    sti

    ; load destination segment
    xor ax, ax
    mov es, ax
    mov bx, 0x7E00

    ; set parameters 
    ; (in order: read sector function, sectors, cylinder, start sector, head)
    mov ah, 0x02
    mov al, 16
    mov ch, 0
    mov cl, 2
    mov dh, 0

    ; call interup, handle a disc error
    int 0x13
    jc disc_error

    jmp 0x7E00

disc_error:
    mov ah, 0x0E
    mov al, 'E'
    int 0x10

    .hang:
        hlt
        jmp .hang

times 510-($-$$) db 0   

dw 0xAA55