[bits 64]

; global kernel_entry   
; extern kernel_main

; extern __bss_start
; extern __bss_end

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

    ; clear BSS
    ; mov rdi, __bss_start
    ; mov rcx, __bss_end
    ; sub rcx, rdi
    ; xor eax, eax
    ; rep stosb

    ; reset stack
    mov rsp, 0x90000
    and rsp, -16

    ; give boot info address to kernel
    cld
    cli

    ; give boot info and jump to kernel
    
    mov rdi, BOOT_INFO_ADDR

    mov rax, KERNEL_LOAD_ADDR
    jmp rax

    jmp $

times 2046-($-$$) db 0

dw 0x6F6C