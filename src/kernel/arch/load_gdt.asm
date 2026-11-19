[bits 64]
[DEFAULT ABS]

global _load_GDT

SECTION .bss.GDT

gdt_descriptor:
    DW 0 ; For limit storage
    DQ 0 ; For base storage

SECTION .text

_load_GDT:
   mov [gdt_descriptor], di
   mov [gdt_descriptor + 2], rsi
   lgdt [gdt_descriptor]

    ; Reload CS using a far return.
    push qword 0x08
    lea rax, [rel .reload_cs]
    push rax
    retfq

    .reload_cs:
        ; Reload data segment selectors.
        mov ax, 0x10    
        
        mov ds, ax
        mov es, ax
        mov fs, ax 
        mov gs, ax   
        mov ss, ax
        ret