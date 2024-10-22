; Простий приклад програми на MASM

.386
.model flat, stdcall
exit_process PROTO, dw

.code
main PROC
    ; Виклик ExitProcess
    mov eax, 0            ; Код повернення
    call exit_process
main ENDP

END main
