.386
.model flat, stdcall
option casemap:none

include C:\masm32\include\windows.inc
include C:\masm32\include\user32.inc
include C:\masm32\include\kernel32.inc
includelib C:\masm32\lib\user32.lib
includelib C:\masm32\lib\kernel32.lib

.data
    msgTitle db "Formatted Values", 0
    
    msgFormat db "A: %d, -A: %d", 13, 10, "B: %d, -B: %d", 13, 10, "C: %d, -C: %d", 13, 10, \
                "D: %d.%03d, -D: -%d.%03d", 13, 10, "E: %d.%03d, -E: -%d.%03d", 13, 10, \
                "F: %d.%03d, -F: -%d.%03d", 0

    A dd 4
    B dd 402
    C_val dd 4022005
    negA dd -4
    negB dd -402
    negC dd -4022005

    D real4 0.001
    E real4 0.078
    F real8 781.555
    negD real4 -0.001
    negE real4 -0.078
    negF real8 -781.555

    D_int dd ?
    D_frac dd ?
    E_int dd ?
    E_frac dd ?
    F_int dd ?
    F_frac dd ?

    negD_int dd ?
    negD_frac dd ?
    negE_int dd ?
    negE_frac dd ?
    negF_int dd ?
    negF_frac dd ?

    buffer db 512 dup(0)  
    tenpow3 real4 1000.0
    tenpow8 real4 1000.0


.code
start:
    finit                      ; ���������� FPU
    
    ; ���������� ����� D
    fld D                     
    fistp D_int                 
    fld D                     
    fsub D_int                  
    fmul tenpow3                
    fistp D_frac                

    ; ���������� ��'���� ����� D
    fld negD                  
    fistp negD_int              
    fld negD                   
    fabs                     
    fsub negD_int               
    fmul tenpow3                
    fistp negD_frac             

    ; ���������� ����� E
    fld E                     
    fistp E_int                 
    fld E                     
    fsub E_int                  
    fmul tenpow3                
    fistp E_frac                

    ; ���������� ��'���� ����� E
    fld negE                  
    fistp negE_int              
    fld negE                   
    fabs                     
    fsub negE_int               
    fmul tenpow3                
    fistp negE_frac             

; ������� ����� F

    fld F                      ; ����������� F � FPU
    fild tenpow3              ; ����������� 1000 �� ���� �����
    fistp F_int               ; �������� ���� ������� F ��� ����������



    fld st(0)                 ; ����������� ������� ������� (0.555)
    fmul tenpow3              ; ������� ������� ������� �� 1000 (���������� ���� �� 3 ����� ������)
    fistp F_frac              ; �������� ������� ������� �� ���� �����






    ; ������� ��'������ ����� negF
    fld negF                   ; ����������� negF � FPU
    fistp negF_int             ; �������� ���� ������� negF
    fld negF                   ; ����������� negF �����
    fsub negF_int              ; ³����� ���� �������, �������� ������� �������
    fmul tenpow3               ; ������� ������� ������� �� 1000
    fistp negF_frac            ; �������� ������� �������


    ; ������� �����������
    invoke wsprintf, addr buffer, addr msgFormat, A, negA, B, negB, C_val, negC, \
            D_int, D_frac, negD_int, negD_frac, E_int, E_frac, negE_int, negE_frac, \
            F_int, F_frac, negF_int, negF_frac 

    ; �������� �����������
    invoke MessageBoxA, 0, addr buffer, addr msgTitle, MB_OK

    ; ���������� ��������
    invoke ExitProcess, 0

end start