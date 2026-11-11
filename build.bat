@echo off

set MSYSTEM=UCRT64
set CHERE_INVOKING=1

REM -- bootloader --

echo Building bootloader...

nasm -f elf64 src/boot/boot.asm -o build/bootloader.o

REM -- kernel --

echo Compiling kernel...

REM Compile, link, and convert kernel

x86_64-elf-gcc ^
    -ffreestanding ^
    -mno-red-zone ^
    -fno-stack-protector ^
    -fno-pie ^
    -fno-pic ^
    -mcmodel=small ^
    -fno-asynchronous-unwind-tables ^
    -fno-unwind-tables ^
    -std=gnu11 ^
    -c src/kernel/main.c ^
    -o build/kernel.o

cd build

echo Linking kernel and bootloader...

@REM  x86_64-elf-ld ^
@REM      -T linker.ld ^
@REM      -o kernel.elf ^
@REM      kernel.o

x86_64-elf-gcc ^
    -nostdlib ^
    -static ^
    -no-pie ^
    -Wl,-T,linker.ld ^
    -Wl,-Map,os.map ^
    -Wl,--build-id=none ^
    -o os.elf ^
    bootloader.o ^
    kernel.o ^
    -lgcc

x86_64-elf-objcopy ^
    -O binary ^
    os.elf ^
    disc.bin

if errorlevel 1 (
    echo Build failed!
    pause
    exit /b 1
)

echo Build successful!

REM -- disc image --

echo Building disc image...

type nul > os.img
dd if=/dev/zero of=os.img bs=1M count=16

@REM  copy /b bootloader.bin + kernel.bin disc.bin

dd if=disc.bin of=os.img conv=notrunc

qemu-system-x86_64 -drive format=raw,file=os.img