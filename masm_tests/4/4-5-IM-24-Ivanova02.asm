.386
.model flat, stdcall
option casemap:none

; ϳ��������� ������� ������� �� �������
include \masm32\include\windows.inc    ; ���� � ��������� Windows API ���������
include \masm32\include\user32.inc     ; ������� ��� ������ � ��������� �����������
include \masm32\include\kernel32.inc   ; ������� ��� ������� �������� ��
include \masm32\include\masm32rt.inc   ; ����� ������� MASM32

includelib \masm32\lib\user32.lib      ; ��������� ��� ���������� ����������
includelib \masm32\lib\kernel32.lib    ; ��������� ��� ��������� �������
includelib \masm32\lib\msvcrt.lib      ; ��������� C runtime

include Ivanova02.inc                     ; ϳ��������� ����� � ���������

.data?
    PasswordBuffer db 15 dup (?)         ; �������� ������������ ������

.data
    InitialEncryptedPass db 5Ah, 78h, 09h, 2Fh, 4Ah
    StudentName db "������� ���'� �������", 0
    BirthDate db "���� ����������: 04.02.2005", 0
    RecordBook db "������� ������: 5147", 0
    ErrorMsg db "������ ������", 0
    SuccessMsg db "������ �����", 0
    PromptMsg db "������ ������:", 0
    DialogTitle db "���������� ��� ��������", 0
    XorKey db 6Fh, 4Ch, 3Ah, 1Dh, 7Bh  ; ���� ��� XOR

dialogHandler PROTO :DWORD, :DWORD, :DWORD, :DWORD

.code
main:
    ; ������������ ���������� ����
    Dialog "���������� ��� ��������", "Times New Roman", 15, \
        WS_OVERLAPPED or WS_SYSMENU or DS_CENTER, \
        4, 10, 10, 150, 70, 1024  
    DlgStatic "������ ������:", SS_CENTER, 30,  2, 80,  15, 100  
    DlgEdit   WS_BORDER, 10,  18, 130, 10, 5089  
    DlgButton "����������", WS_TABSTOP, 10,  40, 40,  10, IDOK  
    DlgButton "�����", WS_TABSTOP, 100, 40, 40,  10, IDCANCEL

    CallModalDialog 0, 0, dialogHandler, NULL

checkOnEquality proc hWnd:DWORD
    ; ��������� ��������� ������
    invoke GetDlgItemText, hWnd, 5089, addr PasswordBuffer, 15
    ; ���������� ��������� ������
    EncryptPassword offset PasswordBuffer             

    ; ��������� ������������� ������ � ���������� ���������
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
