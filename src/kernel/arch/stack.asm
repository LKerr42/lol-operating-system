[bits 64]

global kernel_stack_bottom
global kernel_stack_top

global double_fault_stack_bottom
global double_fault_stack_top

KERNEL_STACK_SIZE           equ 16 * 1024
DOUBLE_FAULT_STACK_SIZE     equ 16 * 1024

section .bss.stack nobits align=16

kernel_stack_bottom:
    resb KERNEL_STACK_SIZE

kernel_stack_top:

double_fault_stack_bottom:
    resb DOUBLE_FAULT_STACK_SIZE

double_fault_stack_top: