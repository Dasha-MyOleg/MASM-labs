extrn MessageBoxA: PROC  
extrn ExitProcess: PROC
extrn GetStdHandle: PROC
extrn WriteFile: PROC

; �������� ��������
INCLUDELIB \masm64\lib\kernel32.lib
INCLUDELIB \masm64\lib\user32.lib

; ������ ��� ��������� ����������� � �������
ConsoleOutput MACRO msg, msgLen
    mov rcx, STD_OUTPUT_HANDLE            ; ����������� ����� ������
    call GetStdHandle                     ; �������� �����
    mov rdx, msg                          ; ������ �����������
    mov r8, msgLen                        ; ������� �����������
    mov r9, offset bytesWritten           ; ������ ����� ��� ���������� ������� ��������� �����
    call WriteFile                        ; ��������� ������� WriteFile
ENDM

; ������ ��� ��������� ����������� ����� MessageBox
ShowMessageBox MACRO hwnd, msg, title, type
    mov rcx, hwnd                         ; ����� ���� (NULL ��� ����)
    mov rdx, msg                          ; �����������
    mov r8, title                         ; ���������
    mov r9d, type                         ; ��� ����������� (MB_OK ����)
    call MessageBoxA                      ; ��������� MessageBoxA
ENDM

.data
    message db 'Full Name: Ivanova Daria Ivanivna', 13, 10,  
            'Date of Birth: 04.02.2005', 13, 10,               
            'Student ID: 125635', 13, 10,                     
            'Favorite Animal: Rat', 0                         
    caption db 'Personal Data', 0                           
    consoleMessage db 'Program started...', 0            
    STD_OUTPUT_HANDLE equ -11
    bytesWritten dq 0
    messageLength dq ($ - consoleMessage)

.code
WinMain PROC
    sub rsp, 28h

    ConsoleOutput offset consoleMessage, messageLength

    ; ��������� ���� ����������� � MessageBoxA
    ShowMessageBox 0, offset message, offset caption, 0

    ; ���������� ��������
    xor rcx, rcx                            ; �������� ��� ExitProcess (0)
    call ExitProcess                        ; ��������� ExitProcess

    add rsp, 28h                            ; ³��������� ����
    ret
WinMain ENDP

END

