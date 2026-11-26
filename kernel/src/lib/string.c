#include <lib/string.h>

void* memset(void *ptr, int value, size_t num) {
    unsigned char *byte_ptr = (unsigned char*)ptr;
    unsigned char byte_val = (unsigned char)value;

    for (size_t i = 0; i < num; i++) {
        *byte_ptr = byte_val;
        byte_ptr++;
    }

    return ptr;
}

void* memcpy(void* dest, void* src, size_t size) {
    unsigned char *dest_cursor = (unsigned char*)dest; 
    unsigned char *src_cursor = (unsigned char*)src; 

    for (size_t i = 0; i < size; i++) {
        *dest_cursor = *src_cursor;

        src_cursor++;
        dest_cursor++;
    }

    return dest;
}

size_t strlen(const char* str) {
    size_t msgIndx = 0;

    while (str[msgIndx] != '\0') {
        msgIndx++;
    }

    return msgIndx;
}

// If the end of both strings has been reached without any mismatches then the function returns zero.
// If the first is greater at the first mismatch, or longer, it returns a positive int.
// If the second is greater at the first mismatch, or longer, it returns a negitive int.
int strcmp(const char* str1, const char* str2) 
{
    //'/0' is included in comparison, as it will always be less than an ascii char, it works to check if str1 ends early
    for (int i = 0; i < strlen(str1) + 1; i++) { 
        if (str1[i] > str2[i]) {
            return 1;
        } else if (str1[i] < str2[i]) {
            return -1;
        }
    }

    return 0;
}

char* strcpy(const char* dst, const char* src) 
{
    return (char*)memcpy(dst, src, strlen(src));
}