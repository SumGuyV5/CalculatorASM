@echo off
set name=CalculatorASM

if exist %name%.obj del %name%.obj

if exist Res\%name%.RES del Res\%name%.RES

if exist %name%.exe del %name%.exe

gorc /r "Res\%name%.rc"

jwasm /c /coff /Cp %name%.asm

if errorlevel 1 goto errasm

polink /SUBSYSTEM:WINDOWS /RELEASE /VERSION:4.0 /OUT:"%name%.exe" "%name%.obj"  "Res\%name%.res"

if errorlevel 1 goto errlink

dir
goto TheEnd

:errlink
echo _
echo Link error
goto TheEnd

:errasm
echo _
echo Assemble Error
Pause

:TheEnd