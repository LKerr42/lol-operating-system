@echo off
echo Building...

REM del build/os.img
type nul > build/os.img
dd if=/dev/zero of=build/os.img bs=1M count=16

REM temp windows build code just to get NASM running
REM nasm -f win64 boot.asm -o boot.obj
REM gcc boot.obj -o boot.exe

nasm -f bin src/boot/boot.asm -o build/boot.bin

dd if=build/boot.bin of=build/os.img conv=notrunc

qemu-system-x86_64 -drive format=raw,file=build/os.img