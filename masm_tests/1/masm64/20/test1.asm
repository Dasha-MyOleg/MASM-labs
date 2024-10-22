option casemap:none
include windows.inc         ; Підключаємо заголовки Windows
includelib kernel32.lib      ; Підключаємо бібліотеки
includelib user32.lib

.data                       ; Секція даних
    caption db "Hello", 0
    message db "Hello, world!", 0

.code                       ; Секція коду
WinMain PROC
    invoke MessageBox, 0, addr message, addr caption, 0
    invoke ExitProcess, 0
WinMain ENDP

end WinMain