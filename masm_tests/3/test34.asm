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
    szInputPassword db 50 dup(?)
    szError db "Incorrect password!", 0
    szWelcome db "Access granted. Welcome!", 0

.code
start:
    invoke DialogBoxParam, hInstance, IDD_PASSWORD, NULL, addr DlgProc, 0
    invoke ExitProcess, 0

DlgProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
    .if uMsg == WM_INITDIALOG
        ret 0
    .elseif uMsg == WM_COMMAND
        .if wParam == IDOK
            invoke GetDlgItemText, hWnd, IDC_PASSWORD_EDIT, addr szInputPassword, sizeof szInputPassword
            invoke lstrcmp, addr szInputPassword, addr szCorrectPassword
            .if eax == 0
                invoke MessageBox, hWnd, addr szWelcome, addr szAppName, MB_OK
                invoke EndDialog, hWnd, 0
            .else
                invoke MessageBox, hWnd, addr szError, addr szAppName, MB_OK
            .endif
            ret 0
        .elseif wParam == IDCANCEL
            invoke EndDialog, hWnd, 0
            ret 0
        .endif
    .endif
    invoke DefDlgProc, hWnd, uMsg, wParam, lParam
    ret 0
DlgProc endp
end start