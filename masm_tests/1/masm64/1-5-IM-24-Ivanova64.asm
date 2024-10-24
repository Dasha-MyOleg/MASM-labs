extrn MessageBoxA: PROC  
extrn ExitProcess: PROC
extrn GetStdHandle: PROC
extrn WriteFile: PROC

; Включаємо бібліотеки
INCLUDELIB \masm64\lib\kernel32.lib
INCLUDELIB \masm64\lib\user32.lib

; Макрос для виведення повідомлення в консоль
ConsoleOutput MACRO msg, msgLen
    mov rcx, STD_OUTPUT_HANDLE            ; Стандартний хендл консолі
    call GetStdHandle                     ; Отримуємо хендл
    mov rdx, msg                          ; Адреса повідомлення
    mov r8, msgLen                        ; Довжина повідомлення
    mov r9, offset bytesWritten           ; Адреса змінної для збереження кількості записаних байтів
    call WriteFile                        ; Викликаємо функцію WriteFile
ENDM

; Макрос для виведення повідомлення через MessageBox
ShowMessageBox MACRO hwnd, msg, title, type
    mov rcx, hwnd                         ; Хендл вікна (NULL або інше)
    mov rdx, msg                          ; Повідомлення
    mov r8, title                         ; Заголовок
    mov r9d, type                         ; Тип повідомлення (MB_OK тощо)
    call MessageBoxA                      ; Викликаємо MessageBoxA
ENDM

.data
    message db 'Full Name: Ivanova Daria Ivanivna', 13, 10,  
            'Date of Birth: 04.02.2005', 13, 10,               
            'Student ID: 125635', 13, 10,                     
            'Favorite Animal: Rat', 0                         
    caption db 'Personal Data', 0                           
    consoleMessage db 'Program started...', 0            
    STD_OUTPUT_HANDLE equ -11
    bytesWritten dq 0
    messageLength dq ($ - consoleMessage)

.code
WinMain PROC
    sub rsp, 28h

    ConsoleOutput offset consoleMessage, messageLength

    ; Виведення вікна повідомлення з MessageBoxA
    ShowMessageBox 0, offset message, offset caption, 0

    ; Завершення програми
    xor rcx, rcx                            ; Аргумент для ExitProcess (0)
    call ExitProcess                        ; Викликаємо ExitProcess

    add rsp, 28h                            ; Відновлюємо стек
    ret
WinMain ENDP

END

