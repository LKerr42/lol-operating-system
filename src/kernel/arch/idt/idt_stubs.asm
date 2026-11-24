[bits 64]

extern isr_handler

%macro ISR_NOERR 1 
global _isr%1 
_isr%1:
    push qword 0    ; push dummy err code
    push qword %1   ; push interupt number
    jmp isr_common_stub
%endmacro

%macro ISR_ERR 1 
global _isr%1 
_isr%1:
    ; cpu already pushed err code
    push qword %1   ; push interupt number
    jmp isr_common_stub
%endmacro

; save context macro, push all gpr to the stack
%macro SAVE_CONTEXT 0
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push rbp
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15
%endmacro

; restore context macro, pop all the gpr back in reverse order
%macro RESTORE_CONTEXT 0
    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rbp
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
%endmacro

isr_common_stub:
    SAVE_CONTEXT

    ; push stack pointer as arg to the C handler
    mov rdi, rsp

    ; call C handler
    call isr_handler

    RESTORE_CONTEXT

    ; clean interupt num and err code
    add rsp, 16
    iretq   ; return

ISR_NOERR 0
ISR_NOERR 6
ISR_ERR   8
ISR_ERR   13
ISR_ERR   14
ISR_NOERR 19