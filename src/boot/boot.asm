BITS 16
ORG 0x7C00

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

    mov si, message
    call print_string

    jmp hang

hang:
    hlt
    jmp hang

message:
    db "Welcome to lolOS", 0x0D, 0x0A, 0

print_string:    
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

times 510-($-$$) db 0

dw 0xAA55