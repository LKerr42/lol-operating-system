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