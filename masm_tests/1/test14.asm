.386
.model flat, stdcall
option casemap:none

include C:\masm32\include\windows.inc
include C:\masm32\include\user32.inc
include C:\masm32\include\kernel32.inc
includelib C:\masm32\lib\user32.lib
includelib C:\masm32\lib\kernel32.lib

.data
    message db "ПІБ: Іванов Іван Іванович", 0Ah, "Дата народження: 01.01.2000", 0Ah, "Залікова книжка: 123456", 0
    caption db "Персональні дані", 0

.code
start:
    invoke MessageBoxA, NULL, addr message, addr caption, MB_OK
    invoke ExitProcess, 0
end start
