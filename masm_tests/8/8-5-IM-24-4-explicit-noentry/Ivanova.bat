@echo off
ml /c /coff Ivanova-DLL.asm
link /dll /out:IvanovaDLL.dll /export:PerformCalculation /noentry Ivanova-DLL.obj
ml /c /coff Ivanova-Main.asm
link /subsystem:windows Ivanova-Main.obj
pause