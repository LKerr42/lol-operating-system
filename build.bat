@echo off

set MSYSTEM=UCRT64
set CHERE_INVOKING=1
setlocal EnableExtensions EnableDelayedExpansion

REM -- bootloader --

echo Building bootloader...

nasm -f elf64 src/boot/boot.asm -o build/obj/bootloader.o

if errorlevel 1 (
    echo Bootloader build failed!
    exit /b 1
)

REM -- kernel --

set "TARGET_DIR=%~dp0src\kernel"
set "BUILD_DIR=%~dp0build"
set "OBJECT_DIR=%BUILD_DIR%\obj"

set "CFLAGS=-ffreestanding -mno-red-zone -fno-stack-protector -fno-pie -fno-pic -mcmodel=small -fno-asynchronous-unwind-tables -fno-unwind-tables -std=gnu11"

REM -- Compile all kernel source files -- 

echo Compiling kernel...

set "OBJECTS="

for /r "%TARGET_DIR%" %%F in (*.c) do (
    REM get relative path
    set "REL=%%F"
    set "REL=!REL:%TARGET_DIR%\=!"

    REM change string extention to .o
    set "OBJ_REL=!REL:.c=.o!"

    REM create output dir
    set "OBJ_FILE=%OBJECT_DIR%\!OBJ_REL!"

    for %%D in ("!OBJ_FILE!") do (
        if not exist "%%~dpD" mkdir "%%~dpD"
    )

    echo Compiling: %%F

    x86_64-elf-gcc !CFLAGS! ^
        -I "%~dp0include" ^
        -c "%%F" ^
        -o "!OBJ_FILE!"

    if errorlevel 1 (
        echo Compilation failed: %%F
        exit /b 1
    )

    REM Add compiled object to linker input list
    set "OBJECTS=!OBJECTS! "!OBJ_FILE!""
)

echo Linking kernel and bootloader...

x86_64-elf-gcc ^
    -nostdlib ^
    -static ^
    -no-pie ^
    -Wl,-T,"%~dp0linker.ld" ^
    -Wl,-Map,"%BUILD_DIR%\os.map" ^
    -Wl,--build-id=none ^
    -o "%BUILD_DIR%\os.elf" ^
    "%BUILD_DIR%\obj\bootloader.o" ^
    !OBJECTS! ^
    -lgcc

if errorlevel 1 (
    echo Linking failed!
    exit /b 1
)

x86_64-elf-objcopy ^
    -O binary ^
    "%BUILD_DIR%\os.elf" ^
    "%BUILD_DIR%\disc.bin"

if errorlevel 1 (
    echo Binary generation failed!
    exit /b 1
)

echo Build successful!

REM -- disc image --

echo Building disc image...

cd build

type nul > os.img
dd if=/dev/zero of=os.img bs=1M count=16

@REM  copy /b bootloader.bin + kernel.bin disc.bin

dd if=disc.bin of=os.img conv=notrunc

qemu-system-x86_64 -drive format=raw,file=os.img