.486
.model flat, c
option casemap:none

include windows.inc
include user32.inc
include kernel32.inc
includelib user32.lib
includelib kernel32.lib

.data
    message db "ϲ�: ������ ���� ��������", 0Ah, "���� ����������: 01.01.2000", 0Ah, "������� ������: 123456", 0
    caption db "���������� ���", 0

.code
main PROC
    invoke MessageBoxW, NULL, addr message, addr caption, MB_OK
    invoke ExitProcess, 0
main ENDP

end main