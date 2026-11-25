#ifndef TRAP_FRAME_H
#define TRAP_FRAME_H

#include <stdint.h>

typedef struct {
    // GPRs
    uint64_t r15;
    uint64_t r14;
    uint64_t r13;
    uint64_t r12;
    uint64_t r11;
    uint64_t r10;
    uint64_t r9;
    uint64_t r8;
    uint64_t rbp;
    uint64_t rdi;
    uint64_t rsi;
    uint64_t rdx;
    uint64_t rcx;
    uint64_t rbx;
    uint64_t rax;

    //interupt num and err code
    uint64_t interrupt_num;
    uint64_t error_code;

    //misc registers, these are automatically pushed
    uint64_t rip; //instruction pointer
    uint64_t cs; // code segment
    uint64_t r_flags; // cpu flags
    uint64_t rsp; // stack pointer
    uint64_t ss; // stack segment
} __attribute__((packed)) trap_frame_t;

#endif