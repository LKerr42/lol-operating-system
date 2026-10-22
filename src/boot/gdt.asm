gdt_start:
    gdt_null:
        dq 0
    gdt_code:
        dw 0xFFFF
        dw 0
        db 0
        db 0b10011010
        ; p,p,t, type flags
        db 0b11001111
        ; other + limit
        db 0
    gdt_data:
        dw 0xFFFF
        dw 0
        db 0
        db 0b10010010
         ; p,p,t, type flags
        db 0b11001111
         ; other + limit
        db 0
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start