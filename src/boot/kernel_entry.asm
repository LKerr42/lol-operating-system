[bits 64]
section .text.entry

global kernel_entry   
extern kernel_main

extern __bss_start
extern __bss_end

kernel_entry:
    call clear_screen_with_blue

    ; clear BSS
    mov rdi, __bss_start
    mov rcx, __bss_end
    sub rcx, rdi
    xor eax, eax
    rep stosb

    ; reset stack
    mov rsp, 0x90000
    and rsp, -16

    cld
    cli

    ; give boot info and jump to kernel
    
    mov rdi, BOOT_INFO_ADDR

    mov rax, kernel_main
    jmp rax

    jmp $

dw 0x6F6C