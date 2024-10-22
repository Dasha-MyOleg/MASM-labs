.386
.model flat, stdcall
option casemap:none

include C:\masm32\include\windows.inc
include C:\masm32\include\user32.inc
include C:\masm32\include\kernel32.inc
includelib user32.lib
includelib kernel32.lib

.data
    szAppName db "Password Protected", 0
    szPrompt db "Enter Password:", 0
    szCorrectPassword db "password123", 0
    szInputPassword db 50 dup(0) ; буфер для введення пароля
    szError db "Incorrect password!", 0
    szWelcome db "Access granted. Welcome!", 0

.code
; Визначення для LOWORD
LOWORD macro value
    mov eax, value
    and eax, 0FFFFh
endm

; Функція обробника діалогу
DialogProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
    .if uMsg == WM_INITDIALOG
        invoke SetDlgItemTextA, hWnd, 1, addr szInputPassword
        ret 0
    .elseif uMsg == WM_COMMAND
        LOWORD wParam
        .if eax == IDOK
            invoke GetDlgItemTextA, hWnd, 1, addr szInputPassword, 50
            invoke lstrcmpA, addr szInputPassword, addr szCorrectPassword
            .if eax == 0
                invoke EndDialog, hWnd, 0
                invoke MessageBoxA, NULL, addr szWelcome, addr szAppName, MB_OK
            .else
                invoke MessageBoxA, NULL, addr szError, addr szAppName, MB_OK
            .endif
            ret 0
        .elseif eax == IDCANCEL
            invoke EndDialog, hWnd, 0
            ret 0
        .endif
    .endif
    invoke DefDlgProcA, hWnd, uMsg, wParam, lParam
    ret 0
DialogProc endp

start:
    ; Створюємо діалогове вікно для введення пароля
    invoke DialogBoxParamA, NULL, addr szPrompt, NULL, addr DialogProc, 0

    invoke ExitProcess, 0
end start
