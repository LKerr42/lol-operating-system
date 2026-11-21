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
    uint32_t reserved0;

    uint64_t rsp0;
    uint64_t rsp1;
    uint64_t rsp2;

    uint64_t reserved1;

    uint64_t ist1;
    uint64_t ist2;
    uint64_t ist3;
    uint64_t ist4;
    uint64_t ist5;
    uint64_t ist6;
    uint64_t ist7;

    uint64_t reserved2;

    uint16_t reserved3;
    uint16_t iomap_base;
} __attribute__((packed)) tss_t;

typedef struct { 
    uint16_t limit_0;           //limit (15:00)
    uint16_t base_0;            //base (15:00)
    uint8_t base_1;             //base (23:16)
    uint8_t type_flags_0;       //type (0-4) and flags 1 (5-7)
    uint8_t limit_1_flags_1;    //limit (19:16) at (0-4) and flags 2 (5-7)
    uint8_t base_2;             // base (31:24)

    uint32_t base_3;
    uint32_t reserved;
} __attribute__((packed)) tss_descriptor_t;

typedef struct {
    gdt_entry_t null;
    gdt_entry_t kernel_code;
    gdt_entry_t kernel_data;
    gdt_entry_t user_null;
    gdt_entry_t user_code;
    gdt_entry_t user_data;

    tss_descriptor_t tss;
}__attribute__((packed)) gdt_t;

void setup_GDT();

#endif