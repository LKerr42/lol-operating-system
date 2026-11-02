void kernel_main(void) {
    volatile char *vga = (char *)0xB8000;

    vga[0] = 'l';
    vga[1] = 0x1F;

    for (;;) {
        // __asm__ volatile ("hlt");
    }
}