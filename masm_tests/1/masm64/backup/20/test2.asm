option casemap:none

include "C:\masm64\include\win64.inc"
include "C:\masm64\include\kernel32.inc"
include "C:\masm64\include\user32.inc"

includelib "C:\masm64\lib\kernel32.lib"
includelib "C:\masm64\lib\user32.lib"

.data
    message db "�����, ���!", 0
    caption db "������� �����������", 0

.code
main PROC
    sub rsp, 28h                    ; ����������� �����
    lea rcx, message                 ; RCX - ������ ��������
    lea rdx, caption                 ; RDX - ������ ��������
    mov r8d, 0                       ; R8  - ����� �������� (��� ������)
    mov r9d, 0                       ; R9  - ��������� ��������
    call MessageBoxA                 ; ������ �������
    call ExitProcess                 ; ���������� ��������
main ENDP

END main