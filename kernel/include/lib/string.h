#ifndef STRING_H
#define STRING_H

#define size_t unsigned long long int
#define NULL (void*)0

void* memset(void *ptr, int value, size_t num);
void* memcpy(void* dest, void* src, size_t size);

size_t strlen(const char* str);
int strcmp(const char* str1, const char* str2);
char* strcpy(const char* dst, const char* src);
char* strcat(void* dst, void* src);
void* strrev(void* str, size_t size);

int is_alpha(char c);
int is_numeric(char c);

#endif
