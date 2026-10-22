@echo off
echo Building...

nasm -f bin src/boot/boot_sector.asm -o build/boot_sector.bin
nasm -f bin src/boot/real_mode.asm -o build/real_mode.bin
nasm -f bin src/boot/protected_mode.asm -o build/protected_mode.bin

cd build

type nul > os.img
dd if=/dev/zero of=os.img bs=1M count=16

copy /b boot_sector.bin + real_mode.bin + protected_mode.bin bootloader.bin

dd if=bootloader.bin of=os.img conv=notrunc

qemu-system-x86_64 -drive format=raw,file=os.img