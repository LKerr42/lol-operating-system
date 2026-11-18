[bits 64]

global kernel_stack_bottom
global kernel_stack_top

KERNEL_STACK_SIZE       equ 16 * 1024

section .bss.stack nobits align=16

kernel_stack_bottom:
    resb KERNEL_STACK_SIZE

kernel_stack_top: