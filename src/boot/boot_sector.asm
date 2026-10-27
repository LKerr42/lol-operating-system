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

    jmp _real_mode_main

    jmp $

disc_error:
    ; mov ah, 0x0E
    ; mov al, 'E'
    ; int 0x10

    mov si, error_msg
    call print_string_bios

    jmp $

error_msg: db "Disc error! No additonal sectors loaded", 0

times 510-($-$$) db 0   

dw 0xAA55