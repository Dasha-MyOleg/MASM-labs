extrn MessageBoxA: PROC
extrn ExitProcess: PROC

.data
    message db 'Hello, World!', 0   ; Текст повідомлення
    caption db 'Greeting', 0         ; Заголовок вікна

.code64
main PROC
    sub rsp, 8                       ; Вирівнювання стеку на 16 байтів (не обов'язково)

    ; Налаштування аргументів для MessageBoxA
    mov rcx, offset message          ; Аргумент 1: адреса повідомлення
    mov rdx, offset caption          ; Аргумент 2: адреса заголовка
    xor rax, rax                     ; Аргумент 3: MB_OK

    ; Виклик MessageBoxA
    call MessageBoxA                 ; Виклик без @32

    ; Виклик ExitProcess
    xor rcx, rcx                     ; Аргумент для ExitProcess (0)
    call ExitProcess                  ; Виклик без @8

    add rsp, 8                       ; Відновлення стеку, якщо потрібно
    retn
main ENDP

END

