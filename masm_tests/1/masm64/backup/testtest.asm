extrn MessageBoxA: PROC
extrn ExitProcess: PROC
extrn GetStdHandle: PROC
extrn WriteFile: PROC

.data
    message db 'Hello, World!', 0          ; Текст повідомлення
    caption db 'Greeting', 0                 ; Заголовок вікна
    consoleMessage db 'Program started...', 0 ; Діагностичне повідомлення
    STD_OUTPUT_HANDLE equ -11                ; Хендл стандартного виходу
    bytesWritten dq 0                         ; Змінна для запису байтів
    messageLength dq $ - consoleMessage       ; Довжина діагностичного повідомлення

.code
main PROC
    sub rsp, 20h                             ; Вирівнюємо стек на 16 байтів (кратне 16)

    ; Виводимо діагностичне повідомлення в консоль
    call GetStdHandle                        ; Отримуємо хендл стандартного виходу
    mov rcx, rax                             ; Зберігаємо хендл у rcx
    mov rdx, offset consoleMessage           ; Адреса повідомлення
    mov r8, messageLength                    ; Довжина повідомлення
    mov r9, offset bytesWritten              ; Адреса для запису байтів
    call WriteFile                           ; Викликаємо WriteFile

    ; Викликаємо MessageBoxA
    mov rcx, offset message                  ; Аргумент 1: адреса повідомлення
    mov rdx, offset caption                  ; Аргумент 2: адреса заголовка
    xor rax, rax                             ; Аргумент 3: MB_OK
    call MessageBoxA                         ; Виклик MessageBoxA

    xor rcx, rcx                             ; Аргумент для ExitProcess (0)
    call ExitProcess                          ; Виклик ExitProcess

    add rsp, 20h                              ; Відновлюємо стек
    ret                                        ; Повернення з процедури
main ENDP

END