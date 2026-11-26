#ifndef VGA_H
#define VGA_H

#define BG_BLACK 0x00
#define BG_BLUE 0x10
#define BG_GREEN 0x20
#define BG_CYAN 0x30
#define BG_RED 0x40
#define BG_MAGENTA 0x50
#define BG_BROWN 0x60
#define BG_LT_GREY 0x70
#define BG_DRK_GREY 0x80
#define BG_LT_BLUE 0x90
#define BG_LT_GREEN 0xA0
#define BG_LT_CYAN 0xB0
#define BG_LT_RED 0xC0
#define BG_LT_MAGENTA 0xD0
#define BG_YELLOW 0xE0
#define BG_WHITE 0xF0

#define TXT_BLACK 0x0
#define TXT_BLUE 0x1
#define TXT_GREEN 0x2
#define TXT_CYAN 0x3
#define TXT_RED 0x4
#define TXT_MAGENTA 0x5
#define TXT_BROWN 0x6
#define TXT_LT_GREY 0x7
#define TXT_DRK_GREY 0x8
#define TXT_LT_BLUE 0x9
#define TXT_LT_GREEN 0xA
#define TXT_LT_CYAN 0xB
#define TXT_LT_RED 0xC
#define TXT_LT_MAGENTA 0xD
#define TXT_YELLOW 0xE
#define TXT_WHITE 0xF

void vga_print(const char* msg, int frmt);
void vga_newline();

#endif