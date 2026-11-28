#include <lib/stdio/format.h>

#include <lib/stdio/number.h>

int vformat(output_format_t *out_format, size_t size, const char *format, va_list ap) {
    size_t written = 0;

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

                    written +=
                        output_string(out_format, buffer);
                    break;
                case 'u':
                    int_to_string(
                        buffer,
                        va_arg(ap, unsigned int),
                        10,
                        0
                    );

                    written +=
                        output_string(out_format, buffer);
                    break;
                case 'x':
                    int_to_string(
                        buffer,
                        va_arg(ap, unsigned int),
                        16,
                        0
                    );

                    written +=
                        output_string(out_format, buffer);
                    break;
                case 'X':
                    int_to_string(
                        buffer,
                        va_arg(ap, unsigned int),
                        16,
                        1
                    );

                    written +=
                        output_string(out_format, buffer);
                    break;
                case 'b':
                    int_to_string(
                        buffer,
                        va_arg(ap, unsigned int),
                        2,
                        0
                    );

                    written +=
                        output_string(out_format, buffer);
                    break;
                case 'f':
                    //TODO: add a float to string func
                    break;
                case 'c':
                    written +=
                        output_char(out_format, va_arg(ap, int));
                    break;
                case 's':
                    written +=
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

        if (written >= size) {
            return written;
        }

        format++;
    }

    return written;
}

int output_char(output_format_t *out_form, char c)
{
    out_form->putchar(c, out_form->context);

    return 1;
}

int output_string(output_format_t *out_form, const char *str)
{
    int written = 0;

    while (*str) {
        written += 
            output_char(out_form, *str);
        str++;
    }

    return written;
}

void buffer_putch(char c, void *context) {
    buffer_output_t *out = (buffer_output_t*)context;

    if (out->size > 0 && out->written < out->size - 1) {
        out->dest[out->written] = c;
        out->written++;
    }

    out->total++;
}