.386
.model flat, stdcall
option casemap:none

; Підключення зовнішніх бібліотек та інклюдів
include \masm32\include\windows.inc    ; Файл з основними Windows API функціями
include \masm32\include\user32.inc     ; Функції для роботи з графічним інтерфейсом
include \masm32\include\kernel32.inc   ; Функції для базових операцій ОС
include \masm32\include\masm32rt.inc   ; Базові функції MASM32

includelib \masm32\lib\user32.lib      ; Бібліотека для графічного інтерфейсу
includelib \masm32\lib\kernel32.lib    ; Бібліотека для системних викликів
includelib \masm32\lib\msvcrt.lib      ; Бібліотека C runtime

include Ivanova02.inc                     ; Підключення файлу з макросами

.data?
    PasswordBuffer db 15 dup (?)         ; Введений користувачем пароль

.data
    InitialEncryptedPass db 5Ah, 78h, 09h, 2Fh, 4Ah
    StudentName db "Іванова Дар'я Іванівна", 0
    BirthDate db "Дата народження: 04.02.2005", 0
    RecordBook db "Залікова книжка: 5147", 0
    ErrorMsg db "Хибний пароль", 0
    SuccessMsg db "Пароль вірний", 0
    PromptMsg db "Введіть пароль:", 0
    DialogTitle db "Персональні дані студента", 0
    XorKey db 6Fh, 4Ch, 3Ah, 1Dh, 7Bh  ; Ключ для XOR

dialogHandler PROTO :DWORD, :DWORD, :DWORD, :DWORD

.code
main:
    ; Налаштування діалогового вікна
    Dialog "Персональні дані студента", "Times New Roman", 15, \
        WS_OVERLAPPED or WS_SYSMENU or DS_CENTER, \
        4, 10, 10, 150, 70, 1024  
    DlgStatic "Введіть пароль:", SS_CENTER, 30,  2, 80,  15, 100  
    DlgEdit   WS_BORDER, 10,  18, 130, 10, 5089  
    DlgButton "Продовжити", WS_TABSTOP, 10,  40, 40,  10, IDOK  
    DlgButton "Вийти", WS_TABSTOP, 100, 40, 40,  10, IDCANCEL

    CallModalDialog 0, 0, dialogHandler, NULL

checkOnEquality proc hWnd:DWORD
    ; Отримання введеного пароля
    invoke GetDlgItemText, hWnd, 5089, addr PasswordBuffer, 15
    ; Шифрування введеного пароля
    EncryptPassword offset PasswordBuffer             

    ; Порівняння зашифрованого пароля з очікуваним значенням
    CompareEncryptedPassword offset PasswordBuffer, offset InitialEncryptedPass 

PasswordCorrect:
    ShowMessage offset StudentName, offset DialogTitle
    ShowMessage offset BirthDate, offset DialogTitle
    ShowMessage offset RecordBook, offset DialogTitle
    invoke ExitProcess, 0

PasswordIncorrect:
    ShowMessage offset ErrorMsg, offset DialogTitle
    invoke ExitProcess, 0
checkOnEquality endp

dialogHandler proc hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
    .if uMsg == WM_INITDIALOG
        jmp createDialogWindow

    .elseif uMsg == WM_CLOSE
        invoke ExitProcess, 0

    .elseif uMsg == WM_COMMAND
        jmp handleOKorCancel

    .endif

createDialogWindow:
    invoke GetWindowLong, hWnd, GWL_USERDATA
    return 0

handleOKorCancel:
    .if wParam == IDOK
        invoke checkOnEquality, hWnd
    .elseif wParam == IDCANCEL
        invoke ExitProcess, 0
    .endif
    return 0

dialogHandler endp

end main
