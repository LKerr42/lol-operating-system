[bits 64]
section .text.entry

global kernel_entry   
extern kernel_main

extern kernel_stack_top

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

    ; establish kernel stack
    lea rsp, [rel kernel_stack_top]
    and rsp, -16

    ; clear direction flag and interup flag
    cld
    cli

    ; give boot info and jump to kernel
    mov rdi, BOOT_INFO_ADDR

    mov rax, kernel_main
    jmp rax

    jmp $

dw 0x6F6C