option casemap:none
include windows.inc         ; ϳ�������� ��������� Windows
includelib kernel32.lib      ; ϳ�������� ��������
includelib user32.lib

.data                       ; ������ �����
    caption db "Hello", 0
    message db "Hello, world!", 0

.code                       ; ������ ����
WinMain PROC
    invoke MessageBox, 0, addr message, addr caption, 0
    invoke ExitProcess, 0
WinMain ENDP

end WinMain