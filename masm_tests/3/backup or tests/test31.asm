.386
.model flat, stdcall
option casemap:none

include C:\masm32\include\windows.inc
include C:\masm32\include\user32.inc
include C:\masm32\include\kernel32.inc
includelib C:\masm32\lib\user32.lib
includelib C:\masm32\lib\kernel32.lib

.data
    correct_password db "secret123", 0    ; Правильний пароль
    message db "ПІБ: Іванова Дар'я Івнівна", 0Ah, "Дата народження: 04.02.2005", 0Ah, "Залікова книжка: 125635", 0Ah, "Улюблена тварина: щур", 0
    caption db "Персональні дані", 0
    input_caption db "Введіть пароль:", 0
    incorrect_password db "Неправильний пароль!", 0

.data?
    input_buffer db 256 dup(?)  ; Буфер для введення пароля

.code
start:
    ; Вивести діалог для введення пароля
    invoke DialogBoxParam, NULL, addr input_caption, NULL, addr input_buffer, MB_OKCANCEL
    
    ; Порівняти введений пароль з правильним
    invoke lstrcmpA, addr input_buffer, addr correct_password
    cmp eax, 0  ; Якщо паролі співпадають, lstrcmpA повертає 0
    jne incorrect

    ; Якщо пароль правильний, вивести персональні дані
    invoke MessageBoxA, NULL, addr message, addr caption, MB_OK
    jmp exit_program

incorrect:
    ; Якщо пароль неправильний, вивести повідомлення про помилку
    invoke MessageBoxA, NULL, addr incorrect_password, addr caption, MB_OK

exit_program:
    invoke ExitProcess, 0
end start

