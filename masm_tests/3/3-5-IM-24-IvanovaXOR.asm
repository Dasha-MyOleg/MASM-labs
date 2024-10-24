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
    PasswordBuffer db 15 dup (?)

.data
    CorrectPass db "54321", 0
    StudentDetails db "������� ���'� ��������", 13, 10, "���� ����������: 04.02.2005", 13, 10, "������� ������: 5147", 0
    ErrorMsg db "������ ������", 0
    PromptMsg db "������ ������:", 0
    DialogTitle db "����������� ���� ��������", 0
    TitleInput db "�������� ������", 0

dialogHandler PROTO :DWORD, :DWORD, :DWORD, :DWORD

.code
main:
    Dialog "����������� ���� ��������", "Times New Roman", 15, \
        WS_OVERLAPPED or WS_SYSMENU or DS_CENTER, \
        4, 10, 10, 150, 70, 1024  
    DlgStatic "������ ������:", SS_CENTER, 30,  2, 80,  15, 100  
    DlgEdit   WS_BORDER, 10,  18, 130, 10, 5089  
    DlgButton "����������", WS_TABSTOP, 10,  40, 40,  10, IDOK  
    DlgButton "�����", WS_TABSTOP, 100, 40, 40,  10, IDCANCEL

    CallModalDialog 0, 0, dialogHandler, NULL

encryptXOR proc
    ; ������� CorrectPass �� ��������� XOR
    mov esi, offset CorrectPass
    mov ecx, 5  ; ������� ������
    xorLoopCorrectPass:
        mov al, byte ptr [esi]
        xor al, 5Ah  ; ����������� XOR � ������ 0x5A
        mov byte ptr [esi], al
        inc esi
        loop xorLoopCorrectPass

    ; ������� �������� ������������ ������ PasswordBuffer
    mov edi, offset PasswordBuffer
    mov ecx, 5  ; ������� ������
    xorLoopPassword:
        mov al, byte ptr [edi]
        xor al, 5Ah  ; ����������� XOR � ������ 0x5A
        mov byte ptr [edi], al
        inc edi
        loop xorLoopPassword

    return 0
encryptXOR endp

checkOnEquality proc
    nop  
    invoke encryptXOR  ; ������� ����� ����� ����������
    mov esi, offset CorrectPass
    mov edi, offset PasswordBuffer

    cmpLoop:
        mov al, byte ptr [edi]
        mov bl, byte ptr [esi]  

        .if al != bl
            invoke MessageBoxA, NULL, addr ErrorMsg, addr DialogTitle, MB_OK
            invoke ExitProcess, 0 
        .endif

        .if al == 0      
            invoke MessageBoxA, NULL, addr StudentDetails, addr DialogTitle, MB_OK
            invoke ExitProcess, 0
        .endif

        inc esi
        inc edi
        jmp cmpLoop
    return 0
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
        invoke GetDlgItemText, hWnd, 5089, addr PasswordBuffer, 15
        invoke checkOnEquality
    .elseif wParam == IDCANCEL
        invoke ExitProcess, 0
    .endif
    return 0
dialogHandler endp

end main