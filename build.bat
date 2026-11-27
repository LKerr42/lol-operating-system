@echo off

set MSYSTEM=UCRT64
set CHERE_INVOKING=1
setlocal EnableExtensions EnableDelayedExpansion

set "ROOT_DIR=%~dp0"
set "SRC_DIR=%ROOT_DIR%kernel\src"
set "BUILD_DIR=%ROOT_DIR%build"
set "OBJECT_DIR=%BUILD_DIR%\obj"

if not exist "%OBJECT_DIR%" mkdir "%OBJECT_DIR%"

REM -- bootloader --

echo Building bootloader...

if not exist "%OBJECT_DIR%/boot" mkdir "%OBJECT_DIR%/boot"

type nul > build/obj/boot/bootloader.o
nasm -f elf64 bootloader/src/boot.asm -o build/obj/boot/bootloader.o

if errorlevel 1 (
    echo Bootloader build failed!
    exit /b 1
)

REM -- kernel --

set "CFLAGS=-ffreestanding -fno-builtin -mno-red-zone -fno-stack-protector -fno-pie -fno-pic -mcmodel=small -fno-asynchronous-unwind-tables -fno-unwind-tables"

set "OBJECTS="

REM -- Compile all ASM source files -- 

echo Assembling kernel ASM files...

for /r "%SRC_DIR%" %%F in (*.asm) do (
    set "REL=%%F"
    set "REL=!REL:%SRC_DIR%\=!"
    set "OBJ_REL=!REL:.asm=.o!"
    set "OBJ_FILE=%OBJECT_DIR%\asm\!OBJ_REL!"

    for %%D in ("!OBJ_FILE!") do (
        if not exist "%%~dpD" mkdir "%%~dpD"
    )

    echo Assembling: %%F

    nasm -f elf64 -g -F dwarf ^
        "%%F" ^
        -o "!OBJ_FILE!"

    if errorlevel 1 (
        echo Assembly failed: %%F
        exit /b 1
    )

    set "OBJECTS=!OBJECTS! "!OBJ_FILE!""
)

echo Compiling kernel C files...

REM -- Compile all C source files -- 

for /r "%SRC_DIR%" %%F in (*.c) do (
    REM get relative path
    set "REL=%%F"
    set "REL=!REL:%SRC_DIR%\=!"

    REM change string extention to .o
    set "OBJ_REL=!REL:.c=.o!"

    REM create output dir
    set "OBJ_FILE=%OBJECT_DIR%\c\!OBJ_REL!"

    for %%D in ("!OBJ_FILE!") do (
        if not exist "%%~dpD" mkdir "%%~dpD"
    )

    echo Compiling: %%F

    x86_64-elf-gcc !CFLAGS! ^
        -I "%~dp0kernel/include" ^
        -I "%~dp0kernel/src" ^
        -c "%%F" ^
        -o "!OBJ_FILE!"

    if errorlevel 1 (
        echo Compilation failed: %%F
        exit /b 1
    )

    REM Add compiled object to linker input list
    set "OBJECTS=!OBJECTS! "!OBJ_FILE!""
)

echo Linking object files...

x86_64-elf-gcc ^
    -nostdlib ^
    -static ^
    -no-pie ^
    -Wl,-T,"%~dp0linker.ld" ^
    -Wl,-Map,"%BUILD_DIR%\os.map" ^
    -Wl,--build-id=none ^
    -o "%BUILD_DIR%\os.elf" ^
    "%BUILD_DIR%\obj\boot\bootloader.o" ^
    !OBJECTS! ^
    -lgcc

if errorlevel 1 (
    echo Linking failed!
    exit /b 1
)

REM -- Generate flat binary --

x86_64-elf-objcopy ^
    -O binary ^
    "%BUILD_DIR%\os.elf" ^
    "%BUILD_DIR%\disc.bin"

if errorlevel 1 (
    echo Binary generation failed!
    exit /b 1
)

echo.
echo Build successful!

REM -- disc image --

echo Building disc image...

cd build

type nul > os.img
dd if=/dev/zero of=os.img bs=1M count=16

@REM  copy /b bootloader.bin + kernel.bin disc.bin

dd if=disc.bin of=os.img conv=notrunc

if errorlevel 1 (
    echo Disc image generation failed!
    exit /b 1
)

qemu-system-x86_64 -drive format=raw,file=os.img