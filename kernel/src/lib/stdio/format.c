#include <lib/stdio/format.h>

static const char uppercase_digits[] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
static const char lowercase_digits[] = "0123456789abcdefghijklmnopqrstuvwxyz";

int vformat(output_format_t *out_format, size_t size, const char *format, va_list ap) {
    while (*format) {
        if (*format == '%') {
            // skip formating char
            format++;

            char buffer[32];

            switch (*format) {
                case '%':
                    output_char(out_format, '%');
                    break;
                case 'i':
                    int_to_string(
                        buffer,
                        va_arg(ap, int),
                        10,
                        0
                    );

                    output_string(out_format, buffer);
                    break;
                case 'u':
                    int_to_string(
                        buffer,
                        va_arg(ap, unsigned int),
                        10,
                        0
                    );

                    output_string(out_format, buffer);
                    break;
                case 'x':
                    int_to_string(
                        buffer,
                        va_arg(ap, unsigned int),
                        16,
                        0
                    );

                    output_string(out_format, buffer);
                    break;
                case 'X':
                    int_to_string(
                        buffer,
                        va_arg(ap, unsigned int),
                        16,
                        1
                    );

                    output_string(out_format, buffer);
                    break;
                case 'b':
                    int_to_string(
                        buffer,
                        va_arg(ap, unsigned int),
                        2,
                        0
                    );

                    output_string(out_format, buffer);
                    break;
                case 'f':
                    //TODO: add a float to string func
                    break;
                case 'c':
                    output_char(out_format, va_arg(ap, int));
                    break;
                case 's':
                    output_string(out_format, va_arg(ap, char*));
                    break;
                default:
                    break;
            }
                
            // Handle malformed trailing '%'.
            if (*format == '\0') {
                break;
            }
        } else {
            output_char(out_format, *format);
        }

        format++;
    }
}

static size_t uitostr(
    char *buffer,
    size_t value,
    unsigned int base,
    int uppercase
) {
    size_t i = 0;

    do {
        int remainder = value % base;

        buffer[i] = (uppercase) 
            ? uppercase_digits[remainder] 
            : lowercase_digits[remainder];
        
        value /= base;

        i++;
    } while (value > 0);

    return i;
}

size_t int_to_string(
    char *buffer,
    long long int value,
    unsigned int base,
    int uppercase
) {
    int is_negative = (int)(value < 0);

    size_t magnitude = (is_negative) 
        ? (size_t)(-(value + 1)) + 1
        : value;

    if (base < 2 || base > 36) {
        return -1;
    }

    // Extract digits in reverse order
    size_t size = uitostr(
        buffer,
        magnitude,
        base,
        uppercase
    );

    //add minus sign for negative value
    if (is_negative) {
        buffer[size] = '-';
        size++;
    }

    //null terminate
    buffer[size] = '\0';

    //reverse the string
    int start = 0;
    int end = size - 1; //ignore null terminator

    while (start < end) {
        char temp = buffer[start];
        buffer[start] = buffer[end];
        buffer[end] = temp;

        start++;
        end--;
    }

    return size;
}

void output_char(output_format_t *out_form, char c)
{
    out_form->putchar(c, out_form->context);
}

void output_string(output_format_t *out_form, const char *str)
{
    while (*str) {
        output_char(out_form, *str);
        str++;
    }
}

void buffer_putch(char c, void *context) {
    buffer_output_t *out = (buffer_output_t*)context;

    if (out->size > 0 && out->written < out->size - 1) {
        out->dest[out->written] = c;
        out->written++;
    }

    out->total++;
}