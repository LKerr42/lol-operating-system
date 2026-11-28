#include <lib/stdio/number.h>

static const char uppercase_digits[] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
static const char lowercase_digits[] = "0123456789abcdefghijklmnopqrstuvwxyz";


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

    strrev(buffer, size-1); //reverse, ignore null

    return size;
}

size_t float_to_string(
    char *buffer,
    float value,
    int precision
) {
    size_t i = 0;

    if (value < 0.0f) {
        buffer[i++] = '-';
        value = -value;
    }

    unsigned int int_part = (unsigned int)value;
    float frac_part = value - (float)int_part;

    i += uitostr(
            (char*)(buffer+i),
            int_part,
            10,
            0
        );

    strrev(buffer, i-1); //reverse
    
    if (precision > 0) {
        buffer[i] = '.';
        i++;

        for (int p = 0; p < precision; p++) {
            frac_part *= 10.0f;
            int digit = (int)frac_part;

            buffer[i] = lowercase_digits[digit];
            i++;
            frac_part -= digit;
        }
    }

    // null terminate
    buffer[i] = '\0';

    return i;
}