#include <kernel/arch/idt/exceptions.h>
#include <kernel/drivers/video/vga.h>

void cpu_exception_handler(
    const char *msg, 
    uint8_t vector,
    uint8_t err_code,
    uint64_t rip,
    uint64_t cs,
    uint64_t rflags
) {
    char open_msg[]  = "================ CPU EXCEPTION ================\n";
    char close_msg[] = "================ SYSTEM HALTED ================\n";

    vga_print(&open_msg[0] , BG_BLUE | TXT_WHITE);

    vga_print(msg , BG_BLUE | TXT_WHITE);
    vga_newline();

    vga_print(&close_msg[0] , BG_BLUE | TXT_WHITE);

    for (;;) {
        __asm__ volatile ("hlt");
    }
    //TODO: impliment basic string lib functions and come back to this
}