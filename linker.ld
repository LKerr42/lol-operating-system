
OUTPUT_FORMAT(elf64-x86-64)
OUTPUT_ARCH(i386:x86-64)

ENTRY(kernel_entry)

SECTIONS
{
    /*
     * Stage 1: BIOS boot sector.
     *
     * VMA: 0x7C00
     * LMA: 0
     */
    . = 0x7C00;

    .boot_sector : AT(0)
    {
        KEEP(*(.boot.sector))
    }

    ASSERT(SIZEOF(.boot_sector) == 512, "Boot sector must be exactly 512 bytes")


    /*
     * Stage 2: Remaining bootloader.
     *
     * VMA: 0x7E00
     * LMA: 512
     */
    . = 0x7E00;

    .boot_rest : AT(512)
    {
        *(.boot.text)
        *(.boot.text.*)

        *(.boot.rodata)
        *(.boot.rodata.*)

        *(.boot.data)
        *(.boot.data.*)
    }

    __boot_end = .;

    /* Total bootloader size, including the first 512-byte sector. */
    __boot_size = __boot_end - 0x7C00;

    /* Round up to the nearest 512-byte sector. */
    __boot_sectors = (__boot_size + 511) / 512;

    /*
     * The kernel's bytes immediately follow the bootloader
     * in the disk image, aligned to a sector boundary.
     */
    __kernel_lma_start = ALIGN(
        LOADADDR(.boot_rest) + SIZEOF(.boot_rest),
        512
    );

    /*
     * Stage 3: Kernel.
     *
     * VMA: 0x100000
     * LMA: Immediately after the bootloader in the image.
     */
    . = 0x100000;

    __kernel_start = .;

    .text :
        AT(__kernel_lma_start)
    {
        KEEP(*(.text.entry))
        *(.text)
        *(.text.*)
    }

    .rodata ALIGN(4K) :
        AT(__kernel_lma_start + (ADDR(.rodata) - 0x100000))
    {
        *(.rodata)
        *(.rodata.*)
    }

    .data ALIGN(4K) :
        AT(__kernel_lma_start + (ADDR(.data) - 0x100000))
    {
        *(.data)
        *(.data.*)
    }

    /* End of the kernel's file-backed sections. */
    __kernel_file_end = .;

    .bss ALIGN(4K) (NOLOAD) :
        AT(__kernel_lma_start + (ADDR(.bss) - 0x100000))
    {
        __bss_start = .;

        *(COMMON)
        *(.bss)
        *(.bss.*)

        __bss_end = .;
    }

    __kernel_end = .;

    /* Kernel file size, excluding BSS. */
    __kernel_file_size = __kernel_file_end - __kernel_start;

    /* Number of 512-byte sectors required to load the kernel. */
    __kernel_sectors = (__kernel_file_size + 511) / 512;

    /* Kernel's destination in RAM. */
    __kernel_load_addr = 0x100000;

    /* Kernel's size in bytes on disk, rounded to sector boundary. */
    __kernel_size = __kernel_sectors * 512;

    /* Temporary kernel loading address in RAM. */
    __kernel_temp_addr = 0x7C00 + (__boot_sectors * 512);

    /* Number of additional sectors for the BIOS to load (bootloader size + kernel size - 1) */
    __loadable_sectors_count = __boot_sectors + __kernel_sectors - 1;

    /*
     * Sections that aren't needed in the initial kernel image.
     */
    /DISCARD/ :
    {
        *(.comment)
        *(.note*)
        *(.eh_frame*)
    }
}