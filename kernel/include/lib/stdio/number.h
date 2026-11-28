#ifndef NUMBER_H
#define NUMBER_H

#include <lib/string.h>

size_t int_to_string(
    char *buffer,
    long long int value,
    unsigned int base,
    int uppercase
);

#endif