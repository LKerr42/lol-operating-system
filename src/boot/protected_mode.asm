[bits 32]

; PRINT_DEST_BASE equ 0xb8000 

jmp main

main:
    mov bx, 0xb8000

    ;print a character
    mov al, 'A'
    mov ah, 0x0f
    mov [0xb8000], ax

    mov si, welcome_message
    call print_string

    .hang:
        hlt
        jmp .hang

print_string:  
    .loop:
        ; put char into al and test if its the null terminator
        mov al, [si]
        test al, al

        jz .done

        ; send char at location stored in si to screen  
        mov ah, 0x0f
        mov [bx], ax

        ; increment si and bx
        inc si
        inc bx

        jmp .loop

    .done:
        ret

welcome_message: db "Loaded protected mode...", 0