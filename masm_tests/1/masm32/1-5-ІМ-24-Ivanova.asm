.386
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

.data
    message db "ϲ�: ������� ���'� �������", 0Ah, "���� ����������: 04.02.2005", 0Ah, "������� ������: 125635", 0Ah, "�������� �������: ���", 0
    caption db "����������� ����", 0

.code
start:
    invoke MessageBoxA, NULL, addr message, addr caption, MB_OK
    invoke ExitProcess, 0
end start

