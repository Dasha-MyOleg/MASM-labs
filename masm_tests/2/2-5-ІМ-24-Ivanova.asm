.386
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

.data
    msgTitle db "���������� ���������", 0
    
    msgFormat db "A: %d (0x%X), -A: %d (0x%X)", 13, 10, \
                "B: %d (0x%X), -B: %d (0x%X)", 13, 10, \
                "C: %d (0x%X), -C: %d (0x%X)", 13, 10, \
                "D: %d.%03d (0x%X.%03X), -D: -%d.%03d (0x%X.%03X)", 13, 10, \
                "E: %d.%03d (0x%X.%03X), -E: -%d.%03d (0x%X.%03X)", 13, 10, \
                "F: %d.%03d (0x%X.%03X), -F: -%d.%03d (0x%X.%03X)", 0

    A dd 4
    B dd 402
    C_val dd 4022005
    C_int dd ?                  
    C_frac dd ?                 
    negC_int dd ?               ; ������: ��'���� ���� ������� C
    negC_frac dd ?              ; ������: ��'���� ������� ������� C
    negA dd -4
    negB dd -402
    negC dd -4022005

    D real4 0.001
    E real4 0.078
    F_string db "781.555", 0     
    negF_string db "781.555", 0    

    D_int dd ?
    D_frac dd ?
    E_int dd ?
    E_frac dd ?
    F_int dd ?
    F_frac dd ?
    negD dd -0.001               
    negD_int dd ?
    negD_frac dd ?
    negE dd -0.078               
    negE_int dd ?
    negE_frac dd ?
    negF_int dd ?
    negF_frac dd ?

    D_hex_int dd ?              
    D_hex_frac dd ?             
    E_hex_int dd ?               
    E_hex_frac dd ?             

    buffer db 512 dup(0)
    tenpow3 real4 1000.0       

.code
start:
    finit                          ; ���������� FPU

    ; ������� ����� D
    fld D                         
    fistp D_int                   
    fld D                         
    fsub D_int                    
    fmul tenpow3                  
    fistp D_frac                  

    ; ������� ��'������ ����� D
    fld negD                      
    fistp negD_int                
    fld negD                      
    fabs                         
    fsub negD_int                 
    fmul tenpow3                  
    fistp negD_frac              

    ; ������� ����� E
    fld E                         
    fistp E_int                   
    fld E                         
    fsub E_int                    
    fmul tenpow3                  
    fistp E_frac                  

    ; ������� ��'������ ����� E
    fld negE                      
    fistp negE_int                
    fld negE                      
    fabs                         
    fsub negE_int                 
    fmul tenpow3                  
    fistp negE_frac              

    ; ������� ����� C
    fld C_val                     
    fistp C_int                  
    fld C_val                     
    fsub C_int                   
    fmul tenpow3                 
    fistp C_frac                 

    ; ������� ��'������ ����� C
    fld negC                      
    fistp negC_int                
    fld negC                      
    fabs                         
    fsub negC_int                 
    fmul tenpow3                  
    fistp negC_frac              

    ; ������� ����� F (� �����)
    lea esi, F_string             ; ����������� ������ F_string
    xor eax, eax                  ; �������� EAX ��� ��������� ������ �����
    xor ebx, ebx                  ; �������� EBX ��� ��������� ������� �������

extract_integer_F:
    movzx ecx, byte ptr [esi]     ; ����������� ������
    cmp ecx, '.'                  ; ��������� �� ������
    je store_integer_F            ; ���� ������, ������� �� ���������� ������ �����
    sub ecx, '0'                  ; ����������� ASCII � �����
    imul eax, 10                  ; ������� �� 10
    add eax, ecx                  ; ������ ���� �����
    inc esi                       ; ������� �� ���������� �������
    jmp extract_integer_F         ; ����������� �� �����

store_integer_F:
    mov F_int, eax                ; �������� ���� �������

extract_fraction_F:
    inc esi                       ; ������� ����� ������
    xor ebx, ebx                  ; �������� EBX ��� ��������� ������� �������

extract_fraction_loop:
    movzx ecx, byte ptr [esi]     ; ����������� ��������� ������
    cmp ecx, 0                    ; ��������� �� ����� �����
    je store_fraction_F            ; ���� �����, ������� �� ���������� ������� �������
    sub ecx, '0'                  ; ����������� ASCII � �����
    imul ebx, 10                  ; ������� �� 10
    add ebx, ecx                  ; ������ ���� �����
    inc esi                       ; ������� �� ���������� �������
    jmp extract_fraction_loop      ; ����������� �� �����

store_fraction_F:
    mov F_frac, ebx               ; �������� ������� �������

    ; ������� ��'������ ����� negF (� �����)
    lea esi, negF_string          ; ����������� ������ negF_string
    xor eax, eax                  ; �������� EAX ��� ��������� ������ �����
    xor ebx, ebx                  ; �������� EBX ��� ��������� ������� �������

extract_integer_negF:
    movzx ecx, byte ptr [esi]     ; ����������� ������
    cmp ecx, '.'                  ; ��������� �� ������
    je store_integer_negF         ; ���� ������, ������� �� ���������� ���� �������
    sub ecx, '0'                  ; ����������� ASCII � �����
    imul eax, 10                  ; ������� �� 10
    add eax, ecx                  ; ������ ���� �����
    inc esi                       ; ������� �� ���������� �������
    jmp extract_integer_negF       ; ����������� �� �����

store_integer_negF:
    mov negF_int, eax             ; �������� ���� �������

extract_fraction_negF:
    inc esi                       ; ������� ����� ������
    xor ebx, ebx                  ; �������� EBX ��� ��������� ������� �������

extract_fraction_neg_loop:
    movzx ecx, byte ptr [esi]     ; ����������� ��������� ������
    cmp ecx, 0                    ; ��������� �� ����� �����
    je store_fraction_negF         ; ���� �����, ������� �� ���������� ������� �������
    sub ecx, '0'                  ; ����������� ASCII � �����
    imul ebx, 10                  ; ������� �� 10
    add ebx, ecx                  ; ������ ���� �����
    inc esi                       ; ������� �� ���������� �������
    jmp extract_fraction_neg_loop   ; ����������� �� �����

store_fraction_negF:
    mov negF_frac, ebx            ; �������� ������� �������

    ; ������������ ������
    invoke wsprintf, addr buffer, addr msgFormat, A, A, negA, negA, \
           B, B, negB, negB, C_val, C_int, negC, negC, \
           D_int, D_frac, D_hex_int, D_hex_frac, negD_int, negD_frac, \
           E_int, E_frac, E_hex_int, E_hex_frac, negE_int, negE_frac, \
           F_int, F_frac, negF_int, negF_frac

    invoke MessageBox, NULL, addr buffer, addr msgTitle, MB_OK
    invoke ExitProcess, 0
end start

