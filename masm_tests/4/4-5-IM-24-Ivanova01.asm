.386
.model flat, stdcall
option casemap:none

include C:\masm32\include\windows.inc
include C:\masm32\include\user32.inc
include C:\masm32\include\kernel32.inc
include \masm32\include\masm32rt.inc
includelib C:\masm32\lib\user32.lib
includelib C:\masm32\lib\kernel32.lib
includelib \masm32\lib\msvcrt.lib

.data?
    PasswordBuffer db 15 dup(?)

.data
    CorrectPass db "54321", 0
    StudentSurname db "Іванова", 0
    StudentName db "Дар'я", 0
    StudentPatronymic db "Іванівна", 0
    BirthDate db "Дата народження: 04.02.2005", 0
    RecordBook db "Залікова книжка: 5147", 0
    ErrorMsg db "Хибний пароль", 0
    PromptMsg db "Введіть пароль:", 0
    DialogTitle db "Персональні дані студента", 0
    TitleInput db "Перевірка пароля", 0

dialogHandler PROTO :DWORD, :DWORD, :DWORD, :DWORD

ShowMessage macro text
    invoke MessageBoxA, NULL, addr text, addr DialogTitle, MB_OK
endm

EncryptXOR macro password
    local loopStart
    mov esi, offset password
    mov ecx, 5
    loopStart:
        mov al, byte ptr [esi]
        xor al, 5Ah
        mov byte ptr [esi], al
        inc esi
        loop loopStart
endm

ComparePasswords macro original, entered
    local cmpLoop, exitSuccess, exitFailure
    mov esi, offset original
    mov edi, offset entered
    cmpLoop:
        mov al, byte ptr [edi]
        mov bl, byte ptr [esi]
        .if al != bl
            ShowMessage ErrorMsg
            jmp exitFailure
        .endif
        .if al == 0
            jmp exitSuccess
        .endif
        inc esi
        inc edi
        jmp cmpLoop
    exitSuccess:
        call DisplayStudentData
        jmp done
    exitFailure:
        invoke ExitProcess, 0
    done:
endm

.code
main:
    Dialog "Персональні дані студента", "Times New Roman", 15, \
        WS_OVERLAPPED or WS_SYSMENU or DS_CENTER, \
        4, 10, 10, 150, 70, 1024  
    DlgStatic "Введіть пароль:", SS_CENTER, 30,  2, 80,  15, 100  
    DlgEdit   WS_BORDER, 10,  18, 130, 10, 5089  
    DlgButton "Продовжити", WS_TABSTOP, 10,  40, 40,  10, IDOK  
    DlgButton "Вийти", WS_TABSTOP, 100, 40, 40,  10, IDCANCEL

    CallModalDialog 0, 0, dialogHandler, NULL

checkOnEquality proc
    EncryptXOR CorrectPass
    EncryptXOR PasswordBuffer
    ComparePasswords CorrectPass, PasswordBuffer
    return 0
checkOnEquality endp

DisplayStudentData proc
    ShowMessage StudentSurname
    ShowMessage StudentName
    ShowMessage StudentPatronymic
    ShowMessage BirthDate
    ShowMessage RecordBook
    ret
DisplayStudentData endp

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
        invoke GetDlgItemText, hWnd, 5089, addr PasswordBuffer, 15
        invoke checkOnEquality
    .elseif wParam == IDCANCEL
        invoke ExitProcess, 0
    .endif
    return 0
dialogHandler endp

end main
