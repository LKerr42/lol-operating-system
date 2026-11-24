#include <kernel/arch/idt/idt.h>
#include <kernel/arch/idt/trap_frame.h>
#include <kernel/arch/idt/exceptions.h>

extern void _load_IDT(idtr_t *idt_desc);

static idt_entry_t idt[256];

static idtr_t idtr;

static char *execption_msg;

void set_idt_gate(
    void* isr,
    uint8_t vector,
    uint8_t flags,
    uint8_t ist
) {
    idt_entry_t* entry = &idt[vector];
    uint64_t addr = (uint64_t)isr;

    entry->offset_0 = (uint16_t) (addr & 0xFFFF);
    entry->offset_1 = (uint16_t) ((addr >> 16) & 0xFFFF);
    entry->offset_2 = (uint32_t) ((addr >> 32) & 0xFFFFFFFF);

    entry->selector = 0x08;

    entry->ist = ist;

    entry->type_attributes = flags;

    entry->reserved = 0;
}

void init_idt() {
    //setup table
    set_idt_gate(_isr0, 0, INTERUPT_GATE, 0);
    set_idt_gate(_isr6, 6, INTERUPT_GATE, 0);
    set_idt_gate(_isr8, 8, INTERUPT_GATE, 1);
    set_idt_gate(_isr13, 13, INTERUPT_GATE, 0);
    set_idt_gate(_isr14, 14, INTERUPT_GATE, 0);
    set_idt_gate(_isr19, 19, INTERUPT_GATE, 0);

    //set descriptor
    idtr = (idtr_t){
        .limit = sizeof(idt) - 1,
        .base = (uint64_t)&idt
    };

    _load_IDT(&idtr);
}

void isr_handler(trap_frame_t* trap_frame) { 
    //hardware interupts, needs PIC to work
    if (trap_frame->interrupt_num >= 32 && trap_frame->interrupt_num <= 47) {

    } else if (trap_frame->interrupt_num < 32) { //cpu execptions
        
        switch (trap_frame->interrupt_num) {
            case 0: 
                execption_msg = "Divide Error (#DE)";
                break;

            case 6: 
                execption_msg = "Invalid Opcode (#UD)";
                break;

            case 8: 
                execption_msg = "Double Fault (#DF)";
                break;
            
            case 13:
                execption_msg = "General Protection Fault (#GP)";
                break;

            case 14:
                execption_msg = "Page Fault (#PF)";
                break;

            case 19:
                execption_msg = "SIMD Floating-Point Exception (#XM)";
                break;

            default:
                execption_msg = "Unknown/General Fault (#??)";
                break;
        }

        cpu_exception_handler(
            execption_msg, 
            trap_frame->interrupt_num,
            trap_frame->error_code,
            trap_frame->rip,
            trap_frame->cs,
            trap_frame->r_flags
        );
    } else { // system calls

    }
}