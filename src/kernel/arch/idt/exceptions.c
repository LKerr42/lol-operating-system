#include <kernel/arch/idt/exceptions.h>

void cpu_exception_handler(
    const char *msg, 
    uint8_t vector,
    uint8_t err_code,
    uint64_t rip,
    uint64_t cs,
    uint64_t rflags
) {
    //TODO: impliment basic string lib functions and come back to this
}