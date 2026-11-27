#include <arch/x86_64/idt/exceptions.h>
#include <drivers/video/vga.h>

void cpu_exception_handler(
    const char *msg, 
    uint8_t vector,
    uint8_t err_code,
    uint64_t rip,
    uint64_t cs,
    uint64_t rflags
) {
    vga_set_std_format(BG_BLUE | TXT_LT_RED);

    vga_printf("================ CPU EXCEPTION ================\n");

    vga_printf("Execption: %s\n", msg);
    vga_printf("Vector: %u\n", vector);
    vga_printf("Error Code: %u\n", err_code);
    vga_printf("RIP: 0x%X\n", rip);
    vga_printf("CS: 0x%X\n", cs);
    vga_printf("RFLAGS: 0b%b\n", rflags);

    vga_printf("================ SYSTEM HALTED ================\n");

    for (;;) {
        __asm__ volatile ("hlt");
    }
}