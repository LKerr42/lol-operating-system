@echo off

REM Compile, link, and convert kernel

x86_64-elf-gcc ^
    -ffreestanding ^
    -mno-red-zone ^
    -fno-stack-protector ^
    -c src/kernel/main.c ^
    -o build/kernel.o

cd build

x86_64-elf-ld ^
    -T linker.ld ^
    -o kernel.elf ^
    kernel.o

x86_64-elf-objcopy ^
    -O binary ^
    kernel.elf ^
    kernel.bin