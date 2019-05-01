@echo off
cls
echo.
echo        Assembling the FPULIB library.
echo.
dir /b *.asm > fpulib.rsp
JWasm /c /coff @fpulib.rsp
polib /VERBOSE /SUBSYSTEM:WINDOWS /OUT:"fpu.lib" *.obj
echo.
del *.obj

echo.
echo        FPU.LIB and FPU.INC have been copied
echo        to the LIB and INCLUDE directories.
echo.
del fpulib.rsp
pause
