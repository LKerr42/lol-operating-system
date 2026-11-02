@echo off
echo Building...

nasm -f bin src/boot/boot.asm -o build/bootloader.bin

cd build

type nul > os.img
dd if=/dev/zero of=os.img bs=1M count=16

REM copy /b boot_sector.bin + real_mode.bin + protected_mode.bin bootloader.bin

dd if=bootloader.bin of=os.img conv=notrunc

qemu-system-x86_64 -drive format=raw,file=os.img

@REM  @echo off
@REM  echo Building...

@REM  nasm -f bin src/boot/boot.asm -o build/bootloader.bin

@REM  REM Compile, link, and convert kernel

@REM  x86_64-elf-gcc ^
@REM      -ffreestanding ^
@REM      -mno-red-zone ^
@REM      -fno-stack-protector ^
@REM      -c src/kernel/kernel.c ^
@REM      -o build/kernel.o

@REM  x86_64-elf-ld ^
@REM      -T linker.ld ^
@REM      -o kernel.elf ^
@REM      kernel.o ^

@REM  x86_64-elf-objcopy ^
@REM      -O binary ^
@REM      kernel.elf ^
@REM      kernel.bin ^

@REM  cd build

@REM  type nul > os.img
@REM  dd if=/dev/zero of=os.img bs=1M count=16

@REM  copy /b bootloader.bin + kernel.bin disc.bin

@REM  dd if=disc.bin of=os.img conv=notrunc

@REM  qemu-system-x86_64 -drive format=raw,file=os.img