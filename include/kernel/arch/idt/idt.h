#ifndef IDT_H
#define IDT_H

#include <stdint.h>

typedef enum IDT_ATTRIBUTES {
    INTERUPT_GATE = 0b10001110,
    CALL_GATE = 0b10001100,
    TRAP_GATE = 0b10001111,
    USER_INTERRUPT_GATE = 0b11101110
};

typedef struct {
    uint16_t offset_0;
    uint16_t selector;
    uint8_t ist;
    uint8_t type_attributes;
    uint16_t offset_1;
    uint32_t offset_2;
    uint32_t reserved;
} __attribute__((packed)) idt_entry_t;

typedef struct {
    uint16_t limit;
    uint64_t base;
} __attribute__((packed)) idtr_t;

extern void _isr0(void);
extern void _isr6(void);
extern void _isr8(void);
extern void _isr13(void);
extern void _isr14(void);
extern void _isr19(void);

void init_IDT();
void set_idt_gate(
    void* isr,
    uint8_t vector,
    uint8_t flags,
    uint8_t ist
);

#endif