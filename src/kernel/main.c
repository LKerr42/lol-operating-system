#include <kernel/drivers/video/vga.h>

void kernel_main(void) {
    char message_one[] = "Hello, C!\n";
    char message_two[] = "How are you?\n";

    vga_print(&message_one[0], BG_BLUE | TXT_WHITE);
    vga_print(&message_two[0], BG_BLUE | TXT_WHITE);

    for (;;) {
        __asm__ volatile ("hlt");
    }
}