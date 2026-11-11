[bits 16]
section .boot.sector

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

    ; store boot drive info
    mov [BOOT_INFO_ADDR], dl

    ; loading in additional sectors
    ; rest of the bootloader = 3 extra sections, kernel = 1 sector

    ; set parameters 
    mov ah, 0x02        ; read sector function
    mov al, 4           ; additonal sectors count
    mov ch, 0           ; cylinder
    mov cl, 2           ; start sector
    mov dh, 0           ; head

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

print_string_bios:  
    .loop:
        ; put char into al and test if its the null terminator
        mov al, [si]
        test al, al

        jz .done

        ; send char at location stored in si to bios screen  
        mov ah, 0x0E
        int 0x10

        ; increment si
        inc si

        jmp .loop

    .done:
        ret

error_msg: db "Disc error! No additonal sectors loaded", 0

times 510-($-$$) db 0   

dw 0xAA55