[bits 64]

KERNEL_TEMP_ADDR    equ 0x7C00 + (512 * 4)     ; boot start + bootloader size (sector size * 4 sectors)
KERNEL_LOAD_ADDR    equ 0x100000
KERNEL_SIZE         equ 512 * 1     ; sector size * 1

kernel_entry:
    ; move kernel from temp location to final dest
    mov rsi, KERNEL_TEMP_ADDR   ; source
    mov rdi, KERNEL_LOAD_ADDR   ; dest
    mov rcx, KERNEL_SIZE        ; Number of bytes to copy
    cld                         ; auto-increment RSI and RDI
    rep movsb                   ; move data by bytes

    ; give boot info address to kernel
    mov rdi, BOOT_INFO_ADDR

    ; jmp KERNEL_LOAD_ADDR

    jmp $

times 2046-($-$$) db 0   

dw 0x6F6C