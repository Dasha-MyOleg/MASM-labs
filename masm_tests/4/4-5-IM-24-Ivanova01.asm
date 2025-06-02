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

.data?
    PasswordBuffer db 15 dup (?)         ; �������� ������������ ������

.data
    ; ������������ ������ "54321" �� ������ XOR
    InitialEncryptedPass db 5Ah, 78h, 09h, 2Fh, 4Ah
    StudentName db "������� ���'� �������", 0
    BirthDate db "���� ����������: 04.02.2005", 0
    RecordBook db "������� ������: 5147", 0
    ErrorMsg db "������ ������", 0
    SuccessMsg db "������ �����", 0
    PromptMsg db "������ ������:", 0
    DialogTitle db "���������� ��� ��������", 0
    XorKey db 6Fh, 4Ch, 3Ah, 1Dh, 7Bh  ; ���� ��� XOR
    HexMessage db "������������ ������: %02X %02X %02X %02X %02X", 0
    BufferForHex db 50 dup (?)          ; ����� ��� ������������ ��������������� �������

dialogHandler PROTO :DWORD, :DWORD, :DWORD, :DWORD

; ������ ��� ���������� ��������� ������
EncryptPassword macro passwordPtr
    local xorLoop

    mov edi, passwordPtr          ;; �������� �� ����� ������
    mov ecx, 5                    ;; ������� ������ � ������
    lea esi, XorKey

    xorLoop:
        mov bl, byte ptr [edi]          ;; ������������ ������� ������
        xor bl, byte ptr [esi]          ;; XOR � ��������� ������ �����
        mov byte ptr [edi], bl          ;; ���������� ������������� �������
        inc edi
        inc esi
        loop xorLoop
endm

; ������ ��� ������� ���������� ���������
CompareEncryptedPassword macro inputPtr, originalHashPtr
    local notEqual
    mov esi, inputPtr
    mov edi, originalHashPtr
    mov ecx, 5                           ;; ʳ������ ������� ������ ��� ���������

    repe cmpsb                           ;; ��������� ����� ���� �� �����
    jne notEqual                         ;; ���� � ������ � �� ���������
    jmp PasswordCorrect                  ;; ���� ����� ���������, ���������� �� ������

notEqual:
    jmp PasswordIncorrect                ;; ���� ����� �� ���������
endm

ShowMessage macro text, title
    invoke MessageBoxA, NULL, text, title, MB_OK
endm

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

    ;; ��������� ������������� ������ � ���������������� ������
    ;;invoke wsprintf, addr BufferForHex, addr HexMessage, \
    ;;    byte ptr PasswordBuffer[0], byte ptr PasswordBuffer[1], \
    ;;    byte ptr PasswordBuffer[2], byte ptr PasswordBuffer[3], \
    ;;    byte ptr PasswordBuffer[4]
    ;;invoke MessageBoxA, NULL, addr BufferForHex, addr DialogTitle, MB_OK

    ;; ĳ���������� ����������� ���� ����������
    ;;ShowMessage offset PasswordBuffer, offset DialogTitle

    ; ��������� ������������� ������ � ���������� ���������
    CompareEncryptedPassword offset PasswordBuffer, offset InitialEncryptedPass 

PasswordCorrect:
    ;;ShowMessage offset SuccessMsg, offset DialogTitle ; ����������� ��� ����
    ShowMessage offset StudentName, offset DialogTitle
    ShowMessage offset BirthDate, offset DialogTitle
    ShowMessage offset RecordBook, offset DialogTitle
    invoke ExitProcess, 0

PasswordIncorrect:
    ShowMessage offset ErrorMsg, offset DialogTitle ;; ����������� ��� ������� ������
    invoke ExitProcess, 0                           ;; ���������� ��������, ���� ������ �������
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
        invoke checkOnEquality, hWnd ; �������� hWnd �� ���������
    .elseif wParam == IDCANCEL
        invoke ExitProcess, 0
    .endif
    return 0

dialogHandler endp

end main
