.386
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32rt.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\msvcrt.lib

.data?
    PasswordBuffer db 15 dup (?)     ; ����� ��� ��������� ������������ ������

.data
    ; "54321" ������������ ������ �� ��������� XOR 5Ah
    InitialEncryptedPass db 6Fh, 6Eh, 69h, 68h, 6Bh ;�������� ������ ��� "54321"
    StudentDetails db "������� ���'� �������", 13, 10, "���� ����������: 04.02.2005", 13, 10, "������� ������: 5147", 0
    ErrorMsg db "������ ������", 0
    PromptMsg db "������ ������:", 0
    DialogTitle db "���������� ��� ��������", 0
    TitleInput db "�������� ������", 0
    XorKey db 5Ah  ; ���� ��� XOR

dialogHandler PROTO :DWORD, :DWORD, :DWORD, :DWORD

.code
main:
    Dialog "���������� ��� ��������", "Times New Roman", 15, \
        WS_OVERLAPPED or WS_SYSMENU or DS_CENTER, \
        4, 10, 10, 150, 70, 1024  
    DlgStatic "������ ������:", SS_CENTER, 30,  2, 80,  15, 100  
    DlgEdit   WS_BORDER, 10,  18, 130, 10, 5089  
    DlgButton "����������", WS_TABSTOP, 10,  40, 40,  10, IDOK  
    DlgButton "�����", WS_TABSTOP, 100, 40, 40,  10, IDCANCEL

    CallModalDialog 0, 0, dialogHandler, NULL

encryptXOR proc
    ; ������� �������� ������������ ������ PasswordBuffer
    mov edi, offset PasswordBuffer
    mov ecx, 5  ; ������� ������
    xorLoopPassword:
        mov al, byte ptr [edi]
        xor al, XorKey  ; ����������� XOR � ������
        mov byte ptr [edi], al
        inc edi
        loop xorLoopPassword
    ret
encryptXOR endp

checkOnEquality proc
    ; ������� �������� ������
    invoke encryptXOR

    ; ĳ���������� ����������� ��� �������� ������������� ��������� ������
    invoke MessageBoxA, NULL, addr PasswordBuffer, addr TitleInput, MB_OK

    ; ��������� ������������� ��������� ������ � InitialEncryptedPass
    mov esi, offset InitialEncryptedPass
    mov edi, offset PasswordBuffer
    mov ecx, 5
    repe cmpsb
    jne incorrectPassword

correctPassword:
    invoke MessageBoxA, NULL, addr StudentDetails, addr DialogTitle, MB_OK
    invoke ExitProcess, 0

incorrectPassword:
    invoke MessageBoxA, NULL, addr ErrorMsg, addr DialogTitle, MB_OK
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
        invoke GetDlgItemText, hWnd, 5089, addr PasswordBuffer, 15
        invoke checkOnEquality
    .elseif wParam == IDCANCEL
        invoke ExitProcess, 0
    .endif
    return 0

dialogHandler endp

end main



