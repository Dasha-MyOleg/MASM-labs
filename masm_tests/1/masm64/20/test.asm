; ������� ������� �������� �� MASM

.386
.model flat, stdcall
exit_process PROTO, dw

.code
main PROC
    ; ������ ExitProcess
    mov eax, 0            ; ��� ����������
    call exit_process
main ENDP

END main
