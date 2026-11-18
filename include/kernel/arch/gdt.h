#ifndef GDT_H
#define GDT_H

typedef struct {
    unsigned short int limit_0;
    unsigned short int base_0;      //bits 0-15 of base address
    unsigned char base_1;           //bits 16-23 of base address
    unsigned char access_byte;
    unsigned char limit_1_flags;    // upper 4 bits are flags, lower 4 are upper 4 bits of limit value
    unsigned char base_2;           //bits 24-31 of base address
}__attribute__((packed)) gdt_entry_t;

typedef struct {
    gdt_entry_t null;
    gdt_entry_t kernel_code;
    gdt_entry_t kernel_data;
    gdt_entry_t user_null;
    gdt_entry_t user_code;
    gdt_entry_t user_data;
    gdt_entry_t tss_1;
    gdt_entry_t tss_2;
} gdt_t;

#endif