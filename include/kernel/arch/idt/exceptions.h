#ifndef EXCEPTIONS_H
#define EXCEPTIONS_H

#include <stdint.h>

// void divide_error_handler();
// void invalid_opcode_handler();
// void double_fault_handler();
// void gpf_handler();
// void page_fault_handler();
// void simd_float_exc_handler();

void cpu_exception_handler(
    const char *msg, 
    uint8_t vector,
    uint8_t err_code,
    uint64_t rip,
    uint64_t cs,
    uint64_t rflags
);

#endif