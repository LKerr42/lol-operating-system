#include <lib/stdio.h>

#include <drivers/video/vga.h>

#include <arch/x86_64/boot_data.h>
#include <arch/x86_64/gdt.h>
#include <arch/x86_64/idt/idt.h>

void kernel_main(boot_info_t *boot_info) {
    vga_printf("Hello, C!\n");
    vga_printf("How are you?\n");

    init_GDT();
    init_IDT();

    for (;;) {
        __asm__ volatile ("hlt");
    }
}