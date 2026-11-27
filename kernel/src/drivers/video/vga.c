#include <drivers/video/vga.h>

#include <lib/stdio/format.h>

static int cursor = 0;
static volatile char *vga = (char *)0xB8000;
static int standard_format = BG_BLUE | TXT_WHITE;

static void vga_output_putchar(char c, void *context) {
    vga_putch(c);
}

static output_format_t vga_output = {
    .putchar = vga_output_putchar,
    .context = NULL
};

size_t vga_printf(const char *format, ...) {
    va_list args;

    va_start(args, format);

    size_t chars_written = 
        vformat(
            &vga_output,
            (size_t)4000,
            format,
            args
        );
    
    va_end(args);

    return chars_written;
}

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

void vga_print(const char* msg, int frmt) {
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

void vga_putch(char ch) {
    if (ch == '\n') {
        cursor += 160 - (cursor % 160);
    } else {
        vga[cursor] = ch;
        vga[cursor+1] = standard_format;
    }

    cursor += 2;

    update_cursor();
}

void vga_set_std_format(int new_format) {
    standard_format = new_format;
}

void vga_newline() {
    cursor += 160 - (cursor % 160);
}