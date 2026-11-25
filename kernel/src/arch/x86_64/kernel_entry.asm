[bits 64]
section .text.entry

extern BOOT_INFO_ADDR

global kernel_entry   
extern kernel_main

extern kernel_stack_top

extern __bss_start
extern __bss_end

extern cpu_enable_sse

kernel_entry:
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

    ; setup SSE
    call cpu_enable_sse

    ; give boot info and jump to kernel
    mov rdi, BOOT_INFO_ADDR

    mov rax, kernel_main
    jmp rax

    jmp $