@echo off

set MSYSTEM=UCRT64
set CHERE_INVOKING=1

REM -- bootloader --

echo Building bootloader...

nasm -f bin src/boot/boot.asm -o build/bootloader.bin

REM -- kernel --

echo Compiling kernel...

REM Compile, link, and convert kernel

x86_64-elf-gcc ^
    -ffreestanding ^
    -mno-red-zone ^
    -fno-stack-protector ^
    -std=gnu11 ^
    -c src/kernel/main.c ^
    -o build/kernel.o

cd build

echo Linking kernel and bootloader...

x86_64-elf-ld ^
    -T linker.ld ^
    -o kernel.elf ^
    kernel.o

echo Creating 

x86_64-elf-objcopy ^
    -O binary ^
    kernel.elf ^
    kernel.bin

if errorlevel 1 (
    echo Build failed!
    exit /b 1
)

echo Build successful!

REM -- disc image --

echo building disc image...

type nul > os.img
dd if=/dev/zero of=os.img bs=1M count=16

copy /b bootloader.bin + kernel.bin disc.bin

dd if=disc.bin of=os.img conv=notrunc

qemu-system-x86_64 -drive format=raw,file=os.img