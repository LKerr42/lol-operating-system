[bits 64]
default rel

global cpu_enable_sse

section .text

cpu_enable_sse:
    ; confirm sse is available
    mov rax, 0x1
    cpuid
    test rdx, 1 << 25
    jz .noSSE

    ; enable SSE etc
    mov rax, cr0
    and rax, ~((1 << 2) | (1 << 3))		; clear coprocessor emulation CR0.EM
    or rax, (1 << 1) | (1 << 5)			; set coprocessor monitoring  CR0.MP
    mov cr0, rax

    mov rax, cr4
    or rax, (1 << 9) | (1 << 10)		; set CR4.OSFXSR and CR4.OSXMMEXCPT at the same time
    mov cr4, rax

    ; Init floating-point state
    fninit

    ; Initialise MXCSR to its default value.
    ldmxcsr [default_mxcsr]

    ret

    .noSSE:
        ; TODO: add kernel panic when it is setup
        ret

section .rodata align=4

default_mxcsr:
    dd 0x1F80