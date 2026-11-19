#include <kernel/arch/gdt.h>

extern void _load_GDT(uint16_t limit, uint64_t base);

/* Keep the GDT in persistent memory. */
static gdt_t kernel_gdt;

static gdt_entry_t encode_GDT_entry(uint32_t limit, uint16_t base, uint8_t access, uint8_t flags) {
    gdt_entry_t entry;

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

void setup_GDT() {
    kernel_gdt = (gdt_t){
        .null           = encode_GDT_entry(0, 0, 0, 0),
        .kernel_code    = encode_GDT_entry(0xFFFFF, 0, 0x9A, 0xA),
        .kernel_data    = encode_GDT_entry(0xFFFFF, 0, 0x92, 0xC),
        .user_null      = encode_GDT_entry(0, 0, 0, 0),
        .user_code      = encode_GDT_entry(0xFFFFF, 0, 0xF2, 0xC),
        .user_data      = encode_GDT_entry(0xFFFFF, 0, 0xFA, 0xA),
        //.tss_1        = encode_GDT_entry(),
        //.tss_2        = encode_GDT_entry(),
    };

    _load_GDT((uint16_t)(sizeof(kernel_gdt) - 1), (uint64_t)&kernel_gdt);
}