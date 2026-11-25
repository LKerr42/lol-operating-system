[bits 64]

global _load_IDT

_load_IDT:
    lidt [rdi]
    ret