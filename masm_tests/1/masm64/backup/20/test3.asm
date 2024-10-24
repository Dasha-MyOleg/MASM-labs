extern GetStdHandle : proc
extern WriteConsoleA : proc
extern ExitProcess : proc

.data
    message db 'Hello, World!', 0  ; ����� ��� ������
    message_len equ $ - offset message  ; ������� ������

.code
main PROC
    sub rsp, 28h                  ; ������� ���� �� ����� (����������� ��� 64-��)

    ; �������� ���������� ������������ ������ (������)
    mov ecx, -11                  ; STD_OUTPUT_HANDLE = -11
    call GetStdHandle              ; �������� ���������� ������

    ; ������ WriteConsoleA ��� ��������� �����������
    mov rcx, rax                  ; ���������� ������ � rcx
    lea rdx, message               ; ������ �����������
    mov r8d, message_len          ; ������� �����������
    xor r9d, r9d                  ; NULL ��� ��������� lpNumberOfCharsWritten
    call WriteConsoleA             ; ������� �����

    ; ���������� ��������
    xor ecx, ecx                   ; ��� ���������� = 0
    call ExitProcess               ; ������ ExitProcess ��� ����������

    add rsp, 28h                  ; ³������� ����
    ret
main ENDP

end main