.386
.model flat, stdcall
option casemap :none

include \masm32\include\masm32rt.inc

.data
    WindowTitle db "��������� ����", 0
    ErrorMessage db "����������� ��� �������: ��������� ��������!", 0
    CalculationFormula db "�������=(a*b/4 - l) / (41 - b*a + c)", 0

    Values_A dd 12, 80, 20, -28, 4
    Values_B dd 0, 17, -7, 10, -15
    Values_C dd -41, 3, 27, -4, 1
    Values_L dd 2432, 30000, 70809, 1, 140

    EvenNumberMessage db "�������=%s", 13, 10,
    "a=%d", 13,
    "b=%d", 13,
    "c=%d", 13,
    "l=%d", 13, 10,
    "��������� %d �����", 13, 10,
    "���� ���� ������� �� 2, ���������=%d", 0

    OddNumberMessage db "�������=%s", 13, 10,
    "a=%d", 13,
    "b=%d", 13,
    "c=%d", 13,
    "l=%d", 13, 10,
    "��������� %d �������", 13, 10,
    "���� ���� ��������� �� 5, ���������=%d", 0

    ZeroNumberMessage db "�������=%s", 13, 10,
    "a=%d", 13,
    "b=%d", 13,
    "c=%d", 13,
    "l=%d", 13, 10,
    "��������� ��������, ���������� �� ������ ���� �������", 0

    DivisorValue dd 4

.data?
    buffer db 128 DUP(?)
    bufferA dd ?    ; ����� ��� a
    bufferB dd ?    ; ����� ��� b
    bufferC dd ?    ; ����� ��� c
    bufferL dd ?    ; ����� ��� l
    result dd ?     ; ����� ��� ��������� ����������

.code
start:

xor esi, esi

.repeat 

    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx
    
    mov eax, Values_A[esi*4] ; a
    mov ebx, Values_B[esi*4] ; b
    mov ecx, Values_C[esi*4] ; c
    mov edx, Values_L[esi*4] ; l

    inc esi

    mov bufferA, eax
    mov bufferB, ebx
    mov bufferC, ecx
    mov bufferL, edx

    ; ��������� ���������: 41 - b*a + c
    mov edi, 41
    imul ebx, eax ; b*a
    sub edi, ebx  ; 41 - b*a
    add edi, ecx  ; + c

    ; ���������, �� ��������� ������� ����
    .if edi == 0
        invoke wsprintf, addr buffer, addr ZeroNumberMessage, addr CalculationFormula, bufferA, \
        bufferB, bufferC, bufferL
        invoke MessageBox, 0, addr buffer, addr ErrorMessage, 0
        .continue  ; ���������� �� �������� ��������
    .endif

    ; ��������� ���������: (a*b/4 - l)
    mov eax, bufferA ; a
    imul eax, bufferB ; a*b
    cdq
    idiv DivisorValue ; a*b / 4
    sub eax, bufferL ; a*b/4 - l

    ; ������� ��������� �� ���������
    mov ecx, edi ; ���������
    cdq
    idiv ecx ; (a*b/4 - l) / (41 - b*a + c)

    ; �������� ���������
    mov result, eax

    ; ���������, �� ��������� ������ ��� ��������
    xor edx, edx
    mov ebx, 2
    mov eax, result
    div ebx

    .if edx != 0
        ; ��������� ��������, ��������� �� 5
        mov eax, result
        imul eax, 5
        invoke wsprintf, addr buffer, addr OddNumberMessage, addr CalculationFormula, bufferA, \
        bufferB, bufferC, bufferL, result, eax
        invoke MessageBox, 0, addr buffer, addr WindowTitle, 0
        .continue
    .endif

    ; ��������� ������, ������� �� 2
    mov eax, result
    cdq
    idiv ebx
    invoke wsprintf, addr buffer, addr EvenNumberMessage, addr CalculationFormula, bufferA, \
    bufferB, bufferC, bufferL, result, eax
    invoke MessageBox, 0, addr buffer, addr WindowTitle, 0

    .until esi == 5

    invoke ExitProcess, 0

end start