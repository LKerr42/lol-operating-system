@echo off
echo Building...

nasm -f bin src/boot/boot.asm -o build/bootloader.bin

cd build

type nul > os.img
dd if=/dev/zero of=os.img bs=1M count=16

REM copy /b boot_sector.bin + real_mode.bin + protected_mode.bin bootloader.bin

dd if=bootloader.bin of=os.img conv=notrunc

qemu-system-x86_64 -drive format=raw,file=os.img