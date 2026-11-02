[bits 64]

kernel_entry:
    mov rdi, BOOT_INFO_ADDR

    ; jmp KERNEL_LOAD_ADDR

    jmp $

times 2046-($-$$) db 0   

dw 0x6F6C