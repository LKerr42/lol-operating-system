#include <kernel/arch/gdt.h>

extern void _load_GDT(uint16_t limit, uint64_t base);

/* Keep the GDT and TSS in persistent memory. */
static gdt_t kernel_gdt;
static tss_t kernel_tss;

extern uint8_t kernel_stack_top[];
extern uint8_t double_fault_stack_top[];

static tss_descriptor_t encode_TSS_descriptor(uint64_t base, uint32_t limit) {
    return (tss_descriptor_t) {
        .limit_0 = limit & 0xFFFF,

        .base_0 = base & 0xFFFF,
        .base_1 = (base >> 16) & 0xFF,

        .type_flags_0 = 0x89,

        .limit_1_flags_1 = (limit >> 16) & 0x0F,

        .base_2 = (base >> 24) & 0xFF,
        .base_3 = (base >> 32) & 0xFFFFFFFF,

        .reserved = 0
    };
}

static void setup_TSS() {
    kernel_tss = (tss_t){0};

    kernel_tss.rsp0 = (uint64_t)kernel_stack_top;
    kernel_tss.ist1 = (uint64_t)double_fault_stack_top;

    kernel_tss.iomap_base = sizeof(tss_t);
}

static gdt_entry_t encode_GDT_entry(uint32_t limit, uint16_t base, uint8_t access, uint8_t flags) {
    gdt_entry_t entry = (gdt_entry_t){0};

    // Encode the limit
    entry.limit_0 = limit & 0xFF;
    entry.limit_1 = (limit >> 8) & 0xFF;
    entry.limit_2_flags = (limit >> 16) & 0x0F;
    
    // Encode the base
    entry.base_0 = base & 0xFF;
    entry.base_1 = (base >> 8) & 0xFF;
    entry.base_2 = (base >> 16) & 0xFF;
    entry.base_3 = (base >> 24) & 0xFF;
    
    // Encode the access byte
    entry.access_byte = access;
    
    // Encode the flags
    entry.limit_2_flags |= (flags << 4);

    return entry;
}

void init_GDT() {
    kernel_gdt = (gdt_t){
        .null           = encode_GDT_entry(0, 0, 0, 0),
        .kernel_code    = encode_GDT_entry(0xFFFFF, 0, 0x9A, 0xA),
        .kernel_data    = encode_GDT_entry(0xFFFFF, 0, 0x92, 0xC),
        .user_null      = encode_GDT_entry(0, 0, 0, 0),
        .user_code      = encode_GDT_entry(0xFFFFF, 0, 0xF2, 0xC),
        .user_data      = encode_GDT_entry(0xFFFFF, 0, 0xFA, 0xA),
        .tss            = encode_TSS_descriptor((uint64_t)&kernel_tss, sizeof(tss_t) - 1),
    };

    setup_TSS();

    _load_GDT((uint16_t)(sizeof(kernel_gdt) - 1), (uint64_t)&kernel_gdt);
}