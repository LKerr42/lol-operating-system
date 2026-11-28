#ifndef NUMBER_H
#define NUMBER_H

#include <lib/string.h>

size_t int_to_string(
    char *buffer,
    long long int value,
    unsigned int base,
    int uppercase
);

size_t float_to_string(
    char *buffer,
    float value,
    int precision
);

#endif