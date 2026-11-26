@echo off

REM     script use:
REM         arg0: script name
REM         arg1: dest, created if not already real
REM         arg2: file name, exclude extention as both .c and .h files will be made
REM         arg3: include file title, for the include guard 

REM -- create .c file --

cd kernel/src

if not exist "%1" mkdir "%1"

cd %1

(
    echo #include ^<%1/%2.h^>
) > "%2".c

REM -- create .h file --

cd %~dp0kernel/include

if not exist "%1" mkdir "%1"

cd "%1"

(
    echo #ifndef %3
    echo #define %3
    echo.
    echo #endif
) > "%2".h