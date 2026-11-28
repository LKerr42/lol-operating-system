#ifndef FORMAT_H
#define FORMAT_H

#include <lib/string.h>

#include <stdarg.h>

typedef struct {
    char *dest;
    size_t size;
    size_t written;
    size_t total;
} buffer_output_t;

typedef struct {
    void (*putchar)(char c, void *context);
    void *context;
} output_format_t;

int vformat(output_format_t *out_format, size_t size, const char *format, va_list ap);

int output_char(output_format_t *out_form, char c);
int output_string(output_format_t *out_form, const char *str);
void buffer_putch(char c, void *context);

#endif