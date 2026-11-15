@echo off

REM                                     -- docs --
REM     script use:
REM         arg1: script name
REM         arg2: dest, created if not already real
REM         arg3: file name, exclude extention as both .c and .h files will be made
REM         arg4: include file title, for the include guard 

REM -- create .c file --

cd src

mkdir "%1"

cd %1

type nul > "%2".c

REM -- create .h file --

cd %~dp0
cd include

mkdir "%1"

cd "%1"

(
    echo #ifndef %3
    echo #define %3
    echo.
    echo #endif
) > "%2".h