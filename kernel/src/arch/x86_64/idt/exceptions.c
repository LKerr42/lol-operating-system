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
    vga_print("================ CPU EXCEPTION ================\n", BG_BLUE | TXT_WHITE);

    vga_print(msg , BG_BLUE | TXT_WHITE);
    vga_newline();

    vga_print("================ SYSTEM HALTED ================\n", BG_BLUE | TXT_WHITE);

    for (;;) {
        __asm__ volatile ("hlt");
    }
    //TODO: impliment basic string lib functions and come back to this
}