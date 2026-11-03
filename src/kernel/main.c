void kernel_main(void) {
    volatile char *vga = (char *)0xB8000;

    char message[] = "Hello, C!";

    int msgIndx = 0;

    for (int i = 0; message[msgIndx] != '\0'; i += 2)
    {
        vga[i] = message[msgIndx];
        vga[i+1] = 0x1F;

        msgIndx++;
    }

    for (;;) {
        // __asm__ volatile ("hlt");
    }
}