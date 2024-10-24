extrn MessageBoxA: PROC
extrn ExitProcess: PROC

.data
    message db 'Hello, World!', 0   ; ����� �����������
    caption db 'Greeting', 0         ; ��������� ����

.code64
main PROC
    sub rsp, 8                       ; ����������� ����� �� 16 ����� (�� ����'������)

    ; ������������ ��������� ��� MessageBoxA
    mov rcx, offset message          ; �������� 1: ������ �����������
    mov rdx, offset caption          ; �������� 2: ������ ���������
    xor rax, rax                     ; �������� 3: MB_OK

    ; ������ MessageBoxA
    call MessageBoxA                 ; ������ ��� @32

    ; ������ ExitProcess
    xor rcx, rcx                     ; �������� ��� ExitProcess (0)
    call ExitProcess                  ; ������ ��� @8

    add rsp, 8                       ; ³��������� �����, ���� �������
    retn
main ENDP

END

