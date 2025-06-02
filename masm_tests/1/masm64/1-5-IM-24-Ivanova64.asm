; Підключаємо необхідні бібліотеки та макроси
INCLUDE \masm64\include\win64.inc
INCLUDE \masm64\include\kernel32.inc
INCLUDE \masm64\include\user32.inc

; Підключаємо необхідні бібліотеки
INCLUDELIB \masm64\lib\kernel32.lib
INCLUDELIB \masm64\lib\user32.lib

; Макрос для відображення вікна повідомлення з кодуванням UTF-16 (MessageBoxW)
ShowMessageBox MACRO hwnd, msg, title, type
    mov rcx, hwnd                         ; Хендл вікна (NULL або інший)
    lea rdx, msg                          ; Завантажуємо ефективну адресу повідомлення в UTF-16
    lea r8, title                         ; Завантажуємо ефективну адресу заголовка в UTF-16
    mov r9d, type                         ; Тип повідомлення (MB_OK тощо)
    call MessageBoxW                      ; Використовуємо Unicode версію MessageBox
ENDM

.data
    message dw 'I', 'v', 'a', 'n', 'o', 'v', 'a', ' ', 'D', 'a', 'r', 'i', 'a', ' ', 'I', 'v', 'a', 'n', 'i', 'v', 'n', 'a', 0Ah
            dw 'D', 'a', 't', 'e', ' ', 'o', 'f', ' ', 'B', 'i', 'r', 't', 'h', ':', ' ', '0', '4', '.', '0', '2', '.', '2', '0', '0', '5', 0Ah
            dw 'S', 't', 'u', 'd', 'e', 'n', 't', ' ', 'I', 'D', ':', ' ', '1', '2', '5', '6', '3', '5', 0Ah
            dw 'F', 'a', 'v', 'o', 'r', 'i', 't', 'e', ' ', 'A', 'n', 'i', 'm', 'a', 'l', ':', ' ', 'R', 'a', 't', 0
    caption dw 'P', 'e', 'r', 's', 'o', 'n', 'a', 'l', ' ', 'D', 'a', 't', 'a', 0                     ; Заголовок, закодований в UTF-16
    MB_OK equ 0    

.code
WinMain PROC
    sub rsp, 28h                             ; Вирівнюємо стек для викликів

    ; Відображення вікна повідомлення з MessageBoxW для кодування UTF-16
    ShowMessageBox 0, offset message, offset caption, MB_OK

    ; Завершення програми
    xor rcx, rcx                            ; Аргумент для ExitProcess (0)
    call ExitProcess                        ; Викликаємо ExitProcess

    ret
WinMain ENDP

END



