#include <drivers/video/vga.h>

#include <arch/x86_64/boot_data.h>
#include <arch/x86_64/gdt.h>
#include <arch/x86_64/idt/idt.h>

void kernel_main(boot_info_t *boot_info) {
    char message_one[] = "Hello, C!\n";
    char message_two[] = "How are you?\n";

    vga_print(&message_one[0], BG_BLUE | TXT_WHITE);
    vga_print(&message_two[0], BG_BLUE | TXT_WHITE);

    init_GDT();
    init_IDT();

    for (;;) {
        __asm__ volatile ("hlt");
    }
}