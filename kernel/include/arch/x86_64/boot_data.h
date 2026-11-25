#ifndef BOOT_DATA_H
#define BOOT_DATA_H

#include <stdint.h>

typedef struct {
    uint8_t boot_drive;
    uint8_t padding[7];

    uint64_t memory_map_address;
    uint64_t memory_map_count;

    uint64_t kernel_address;
    uint64_t kernel_size;
} boot_info_t;

#endif