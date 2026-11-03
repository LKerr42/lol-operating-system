@echo off

set MSYSTEM=UCRT64
set CHERE_INVOKING=1

REM -- bootloader --

echo Building bootloader...

nasm -f bin src/boot/boot.asm -o build/bootloader.bin

REM -- kernel --

echo Compiling kernel...

C:\msys64\usr\bin\bash.exe --login -c "./kernel_build.bat"

if errorlevel 1 (
    echo Build failed!
    exit /b 1
)

echo Build successful!

REM -- disc image --

echo building disc image...

cd build

type nul > os.img
dd if=/dev/zero of=os.img bs=1M count=16

copy /b bootloader.bin + kernel.bin disc.bin

dd if=disc.bin of=os.img conv=notrunc

qemu-system-x86_64 -drive format=raw,file=os.img