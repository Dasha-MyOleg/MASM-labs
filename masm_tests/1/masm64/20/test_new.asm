option casemap:none
INCLUDE "C:\masm64\include\win64.inc"
INCLUDE "C:\masm64\include\kernel32.inc"
INCLUDE "C:\masm64\include\user32.inc"

includelib "C:\masm64\lib\kernel32.lib"
includelib "C:\masm64\lib\user32.lib"

.data
    message db "ПІБ: Іванова Дар'я Івнівна", 0Ah, "Дата народження: 04.02.2005", 0Ah, "Залікова книжка: 125635", 0Ah, "Улюблена тварина: щур", 0
    caption db "Персональні дані", 0

.code
main PROC
    lea rcx, caption          ; Адреса заголовка в RCX (перший параметр)
    lea rdx, message          ; Адреса повідомлення в RDX (другий параметр)
    mov r8, 0                 ; MB_OK (третій параметр)
    mov r9, 0                 ; Нульовий вказівник (четвертий параметр)
    call MessageBoxA          ; Виклик MessageBoxA

    xor rcx, rcx              ; Перший параметр для ExitProcess - код завершення 0
    call ExitProcess          ; Виклик ExitProcess
main ENDP

END main
