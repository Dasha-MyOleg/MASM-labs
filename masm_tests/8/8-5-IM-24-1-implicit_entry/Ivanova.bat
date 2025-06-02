@echo off
ml /c /coff Ivanova-DLL.asm
link /dll /out:IvanovaDLL.dll /def:Ivanova-DLL.def Ivanova-DLL.obj
ml /c /coff Ivanova-Main.asm
link /subsystem:windows Ivanova-Main.obj
pause
