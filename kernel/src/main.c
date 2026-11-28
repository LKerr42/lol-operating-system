#include <lib/stdio.h>

#include <drivers/video/vga.h>

#include <arch/x86_64/boot_data.h>
#include <arch/x86_64/gdt.h>
#include <arch/x86_64/idt/idt.h>

static inline uintptr_t get_rsp(void) {
    uintptr_t rsp;
    __asm__ __volatile__("mov %%rsp, %0" : "=r"(rsp));
    return rsp;
}

void kernel_main(boot_info_t *boot_info) {
    vga_printf("Hello, C!\n");
    vga_printf("How are you?\n");

    init_GDT();
    init_IDT();

    vga_printf("me %i%%: %s%c\n", 100, "goated", '!');
    vga_printf("me %.5f%%: %s", 0.00001, "not goated?\n");
    vga_printf("me %f\n", 0.1f);

    uintptr_t rsp = get_rsp();

    vga_printf("RSP & 0xF: %i\n", rsp & 0xF);

    for (;;) {
        __asm__ volatile ("hlt");
    }
}