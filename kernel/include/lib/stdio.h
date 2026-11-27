#ifndef STDIO_H
#define STDIO_H

#include <stdarg.h>

#include <lib/string.h>

int snprintf(char* dest, size_t size, const char *format, ...);
int vsnprintf(char* dest, size_t size, const char *format, va_list ap);

#endif