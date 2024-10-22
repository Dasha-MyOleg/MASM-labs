extrn MessageBoxW: PROC
extrn ExitProcess: PROC
extrn GetStdHandle: PROC
extrn WriteFile: PROC

.data
    message db 'H', 0, 'e', 0, 'l', 0, 'l', 0, 'o', 0, ',', 0, ' ', 0, 'W', 0, 'o', 0, 'r', 0, 'l', 0, 'd', 0, '!', 0, 0, 0  ; Текст повідомлення у Unicode
    caption db 'G', 0, 'r', 0, 'e', 0, 'e', 0, 't', 0, 'i', 0, 'n', 0, 'g', 0, 0, 0                                     ; Заголовок вікна у Unicode
    consoleMessage db 'P', 0, 'r', 0, 'o', 0, 'g', 0, 'r', 0, 'a', 0, 'm', 0, ' ', 0, 's', 0, 't', 0, 'a', 0, 'r', 0, 't', 0, 'e', 0, 'd', 0, '...', 0, 0, 0  ; Діагностичне повідомлення
    STD_OUTPUT_HANDLE equ -11               ; Хендл стандартного виходу
    bytesWritten dq 0                        ; Змінна для запису байтів
    messageLength dq ($ - consoleMessage)    ; Довжина діагностичного повідомлення

.code
main PROC
    sub rsp, 28h                            ; Вирівнюємо стек на 16 байтів

    ; Виводимо діагностичне повідомлення в консоль
    mov rcx, STD_OUTPUT_HANDLE              ; Аргумент 1: Стандартний хендл для виводу
    call GetStdHandle                       ; Отримуємо хендл стандартного виходу
    mov rdx, offset consoleMessage          ; Аргумент 2: Адреса повідомлення
    mov r8, messageLength                   ; Аргумент 3: Довжина повідомлення
    mov r9, offset bytesWritten             ; Аргумент 4: Адреса для запису байтів
    call WriteFile                          ; Викликаємо WriteFile

    ; Викликаємо MessageBoxW
    mov rcx, 0                              ; Аргумент 1: NULL для хендла вікна
    mov rdx, offset message                 ; Аргумент 2: адреса повідомлення
    mov r8, offset caption                  ; Аргумент 3: адреса заголовка
    mov r9d, 0                              ; Аргумент 4: MB_OK
    call MessageBoxW                        ; Виклик MessageBoxW

    xor rcx, rcx                            ; Аргумент для ExitProcess (0)
    call ExitProcess                        ; Виклик ExitProcess

    add rsp, 28h                            ; Відновлюємо стек
    ret                                     ; Повернення з процедури
main ENDP

END
