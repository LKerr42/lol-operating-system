@echo off
echo Building...

nasm -f bin src/boot/boot.asm -o build/boot.bin
nasm -f bin src/boot/second_stage.asm -o build/second_stage.bin

cd build

type nul > os.img
dd if=/dev/zero of=os.img bs=1M count=16

copy /b boot.bin + second_stage.bin bootloader.bin

dd if=bootloader.bin of=os.img conv=notrunc

qemu-system-x86_64 -drive format=raw,file=os.img