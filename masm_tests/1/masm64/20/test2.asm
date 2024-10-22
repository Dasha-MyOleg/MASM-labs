option casemap:none

include "C:\masm64\include\win64.inc"
include "C:\masm64\include\kernel32.inc"
include "C:\masm64\include\user32.inc"

includelib "C:\masm64\lib\kernel32.lib"
includelib "C:\masm64\lib\user32.lib"

.data
    message db "Привіт, світ!", 0
    caption db "Тестове повідомлення", 0

.code
main PROC
    sub rsp, 28h                    ; Вирівнювання стеку
    lea rcx, message                 ; RCX - перший аргумент
    lea rdx, caption                 ; RDX - другий аргумент
    mov r8d, 0                       ; R8  - третій аргумент (тип кнопки)
    mov r9d, 0                       ; R9  - четвертий аргумент
    call MessageBoxA                 ; Виклик функції
    call ExitProcess                 ; Завершення програми
main ENDP

END main