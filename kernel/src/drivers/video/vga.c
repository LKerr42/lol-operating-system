#include <drivers/video/vga.h>

static int cursor = 0;
static volatile char *vga = (char *)0xB8000;

static void update_cursor() {
    __asm__ volatile (
        // Put cursor into BX
        "movw %w0, %%bx\n\t"

        // Low byte
        "movw $0x3D4, %%dx\n\t"
        "movb $0x0F, %%al\n\t"
        "outb %%al, %%dx\n\t"

        "movw $0x3D5, %%dx\n\t"
        "movb %%bl, %%al\n\t"
        "outb %%al, %%dx\n\t"

        // High byte
        "movw $0x3D4, %%dx\n\t"
        "movb $0x0E, %%al\n\t"
        "outb %%al, %%dx\n\t"

        "movw $0x3D5, %%dx\n\t"
        "movb %%bh, %%al\n\t"
        "outb %%al, %%dx\n\t"

        :
        : "r" (cursor>>1)
        : "rax", "rbx", "rdx"
    );
}

void vga_print(char* msg, int frmt) {
    int msgIndx = 0;

    while (msg[msgIndx] != '\0')
    {
        if (msg[msgIndx] == '\n') {
            cursor += 160 - (cursor % 160);

            msgIndx++;
            continue;
        }

        vga[cursor] = msg[msgIndx];
        vga[cursor+1] = frmt;

        msgIndx++;
        cursor += 2;
    }
    update_cursor();
}

void vga_newline() {
    cursor += 160 - (cursor % 160);
}