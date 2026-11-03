void kernel_main(void) {
    volatile char *vga = (char *)0xB8000;

    vga[0] = 'l';
    vga[1] = 0x1F;

    vga[2] = 'o';
    vga[3] = 0x1F;

    // char message[] = "Hello from my C kernel!";

    // int msgIndx = 0;

    // for (int i = 0; message[msgIndx] != '\0'; i += 2)
    // {
    //     vga[i] = (char)message[i];
    //     vga[i+1] = 0x1F;

    //     msgIndx++;
    // }

    for (;;) {
        // __asm__ volatile ("hlt");
    }
}