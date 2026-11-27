#include <lib/stdio.h>
#include <lib/stdio/format.h>

int snprintf(char* dest, size_t size, const char *format, ...) {
    va_list args;

    va_start(args, format);
    int result = vsnprintf(dest, size, format, args);
    va_end(args);

    return result;
}

int vsnprintf(char* dest, size_t size, const char *format, va_list ap) 
{    
    //int current_size = 0;
    //char format_buffer[64];

    format_output_t out = {
        .dest = dest,
        .size = size,
        .total = 0,
        .written = 0
    };

    // init destination with termination chars
    memset(dest, '\0', size);

    while (*format) {
        if (*format == '%') {
            // skip formating char
            format++;

            char buffer[32];

            switch (*format) {
                case '%':
                    output_char(&out, '%');
                    break;
                case 'i':
                    int_to_string(
                        buffer,
                        va_arg(ap, int),
                        10,
                        0
                    );

                    output_string(&out, buffer);
                    break;
                case 'u':
                    int_to_string(
                        buffer,
                        va_arg(ap, unsigned int),
                        10,
                        0
                    );

                    output_string(&out, buffer);
                    break;
                case 'x':
                    int_to_string(
                        buffer,
                        va_arg(ap, unsigned int),
                        16,
                        0
                    );

                    output_string(&out, buffer);
                    break;
                case 'X':
                    int_to_string(
                        buffer,
                        va_arg(ap, unsigned int),
                        16,
                        1
                    );

                    output_string(&out, buffer);
                    break;
                case 'f':
                    //TODO: add a float to string func
                    break;
                case 'c':
                    output_char(&out, va_arg(ap, int));
                    break;
                case 's':
                    output_string(&out, va_arg(ap, char*));
                    break;
                default:
                    break;
            }
                
            // Handle malformed trailing '%'.
            if (*format == '\0') {
                break;
            }
        } else {
            output_char(&out, *format);
        }

        format++;
    }

    return out.total;
}