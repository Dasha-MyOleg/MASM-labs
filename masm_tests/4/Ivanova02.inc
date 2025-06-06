;; Ivanova02.inc

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

; ������ ��� ��������� ������ � ������������� MessageBox
ShowMessage macro text, title
    invoke MessageBoxA, NULL, text, title, MB_OK
endm
