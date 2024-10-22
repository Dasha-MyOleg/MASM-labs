extern GetStdHandle : proc
extern WriteConsoleA : proc
extern ExitProcess : proc

.data
    message db 'Hello, World!', 0  ; Текст для виводу
    message_len equ $ - offset message  ; Довжина тексту

.code
main PROC
    sub rsp, 28h                  ; Виділити місце на стеку (вирівнювання для 64-біт)

    ; Отримати дескриптор стандартного виводу (консолі)
    mov ecx, -11                  ; STD_OUTPUT_HANDLE = -11
    call GetStdHandle              ; Отримати дескриптор консолі

    ; Виклик WriteConsoleA для виведення повідомлення
    mov rcx, rax                  ; Дескриптор консолі в rcx
    lea rdx, message               ; Адреса повідомлення
    mov r8d, message_len          ; Довжина повідомлення
    xor r9d, r9d                  ; NULL для параметра lpNumberOfCharsWritten
    call WriteConsoleA             ; Вивести текст

    ; Завершення програми
    xor ecx, ecx                   ; Код завершення = 0
    call ExitProcess               ; Виклик ExitProcess для завершення

    add rsp, 28h                  ; Відновити стек
    ret
main ENDP

end main