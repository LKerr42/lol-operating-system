#ifndef FORMAT_H
#define FORMAT_H

#include <lib/string.h>

typedef struct {
    char *dest;
    size_t size;
    size_t written;
    size_t total;
} format_output_t;

size_t int_to_string(
    char *buffer,
    long long int value,
    unsigned int base,
    int uppercase
);

void output_char(format_output_t *out, char c);
void output_string(format_output_t *out, const char *str);

#endif