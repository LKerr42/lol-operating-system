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
    buffer_output_t out = {
        .dest = dest,
        .size = size,
        .total = 0,
        .written = 0
    };

    output_format_t buffer_output = {
        .putchar = buffer_putch,
        .context = &out
    };

    // init destination with termination chars
    memset(dest, '\0', size);

    vformat(&buffer_output, size, format, ap);

    return out.total;
}