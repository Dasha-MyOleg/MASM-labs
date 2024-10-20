.386
.model flat, stdcall
option casemap:none

include C:\masm32\include\windows.inc
include C:\masm32\include\user32.inc
include C:\masm32\include\kernel32.inc
includelib C:\masm32\lib\user32.lib
includelib C:\masm32\lib\kernel32.lib

.data
    ; Заголовок повідомлення
    msgTitle db "Values of A, B, C, D, E, F", 0
    
    ; Форматований рядок для виводу значень
    msgFormat db "A: %d, -A: %d", 13, 10, "B: %d, -B: %d", 13, 10, "C: %d, -C: %d", 13, 10, \
                "D: %f, -D: %f", 13, 10, "E: %f, -E: %f", 13, 10, "F: %lf, -F: %lf", 0
    
    ; Змінні
    A dd 4
    B dd 402
    C_val dd 4022005
    negA dd -4
    negB dd -402
    negC dd -4022005
    D real4 0.001
    E real4 0.078
    F real8 781.555
    negD real4 -0.001
    negE real4 -0.078
    negF real8 -781.555

    buffer db 512 dup(0)  ; Буфер для формування повідомлення

.code
start:
    ; Формуємо повідомлення, що містить значення
    invoke wsprintf, addr buffer, addr msgFormat, A, negA, B, negB, C_val, negC, D, negD, E, negE, F, negF

    ; Виводимо повідомлення в одному вікні
    invoke MessageBoxA, 0, addr buffer, addr msgTitle, MB_OK

    ; Завершення програми
    invoke ExitProcess, 0

end start