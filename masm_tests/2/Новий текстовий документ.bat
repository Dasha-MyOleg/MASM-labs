@echo off
ml /c /coff /Fl 2-5-IM-24-Ivanova.asm
link /subsystem:windows /out:2-5-IM-24-Ivanova.exe 2-5-IM-24-Ivanova.obj \masm32\lib\user32.lib \masm32\lib\kernel32.lib
echo Compilation and listing complete!
pause
