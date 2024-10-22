.386
.model flat, stdcall
option casemap:none

include C:\masm32\include\windows.inc
include C:\masm32\include\user32.inc
include C:\masm32\include\kernel32.inc
includelib C:\masm32\lib\user32.lib
includelib C:\masm32\lib\kernel32.lib

.data
    correct_password db "secret123", 0    ; ���������� ������
    message db "ϲ�: ������� ���'� ������", 0Ah, "���� ����������: 04.02.2005", 0Ah, "������� ������: 125635", 0Ah, "�������� �������: ���", 0
    caption db "���������� ���", 0
    input_caption db "������ ������:", 0
    incorrect_password db "������������ ������!", 0

.data?
    input_buffer db 256 dup(?)  ; ����� ��� �������� ������

.code
start:
    ; ������� ����� ��� �������� ������
    invoke DialogBoxParam, NULL, addr input_caption, NULL, addr input_buffer, MB_OKCANCEL
    
    ; �������� �������� ������ � ����������
    invoke lstrcmpA, addr input_buffer, addr correct_password
    cmp eax, 0  ; ���� ����� ����������, lstrcmpA ������� 0
    jne incorrect

    ; ���� ������ ����������, ������� ���������� ���
    invoke MessageBoxA, NULL, addr message, addr caption, MB_OK
    jmp exit_program

incorrect:
    ; ���� ������ ������������, ������� ����������� ��� �������
    invoke MessageBoxA, NULL, addr incorrect_password, addr caption, MB_OK

exit_program:
    invoke ExitProcess, 0
end start

