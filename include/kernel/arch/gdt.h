#ifndef GDT_H
#define GDT_H

#include <stdint.h>

typedef struct {
    uint8_t limit_0;        //bits 0-7 of limit
    uint8_t limit_1;        //bits 8-15 of limit
    uint8_t base_0;         //bits 0-7 of base address
    uint8_t base_1;         //bits 8-15 of base address
    uint8_t base_2;         //bits 16-23 of base address
    uint8_t access_byte;    //access byte is full 8 bits
    uint8_t limit_2_flags;  //upper 4 bits is the 4-bit flags, lower 4 are bits 16-19 of limit value
    uint8_t base_3;         //bits 24-31 of base address
}__attribute__((packed)) gdt_entry_t;

typedef struct {
    gdt_entry_t null;
    gdt_entry_t kernel_code;
    gdt_entry_t kernel_data;
    gdt_entry_t user_null;
    gdt_entry_t user_code;
    gdt_entry_t user_data;
    //gdt_entry_t tss_1;
    //gdt_entry_t tss_2;
} gdt_t;

void setup_GDT();

#endif