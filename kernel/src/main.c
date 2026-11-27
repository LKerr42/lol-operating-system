#include <lib/stdio.h>

#include <drivers/video/vga.h>

#include <arch/x86_64/boot_data.h>
#include <arch/x86_64/gdt.h>
#include <arch/x86_64/idt/idt.h>

void kernel_main(boot_info_t *boot_info) {
    vga_print("Hello, C!\n", BG_BLUE | TXT_WHITE);
    vga_print("How are you?\n", BG_BLUE | TXT_WHITE);

    init_GDT();
    init_IDT();

    char buffer[64];
    snprintf(buffer, sizeof(buffer), "me %i%%: %s%c\n", 100, "goated", '!');

    vga_print(buffer, BG_BLUE | TXT_WHITE);

    vga_printf("me:\n - goated: %u%% \n - not goated: %i%% \n - final verdict: %s%c", 100, -100, "goated", '!');

    for (;;) {
        __asm__ volatile ("hlt");
    }
}