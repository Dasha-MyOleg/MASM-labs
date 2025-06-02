@echo off
ml /c /coff Ivanova-DLL.asm
link /out:IvanovaDLL.dll /def:Ivanova-DLL.def /dll Ivanova-DLL.obj /noentry
ml /c /coff Ivanova-Main.asm
link /subsystem:windows Ivanova-Main.obj
pause
