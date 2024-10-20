.386
.model flat, stdcall
option casemap :none

include \masm32\include\masm32rt.inc

.data
    Oh_no db "�� �!", 0
    MsgBoxCaption5 db "����������", 0

    MyArrayA dq 1.0, 14.5, 10.0, 5.8, 18.7     ; ���� �������� � �����
    MyArrayB dq 1.0, 3.7, 1.8, -0.5, 10.2      ; ���� �������� � �����
    MyArrayC dq 2.8, -3.0, 5.7, 9.2, -3.5  
    MyArrayD dq 13.0, 15.4, 2.5, 7.0, 8.7

    MyCustomFormula db "(tg(a + c / 4) - 12 * d) / (a * b - 1)", 0 

    outputResultYEs db "�������=%s", 13, 10, "a=%s", 13, 10, "b=%s", 13, 10, "c=%s", 13, 10, "d=%s", 13, 10, "���������=%s", 0
    outputResultYEsZERO db "�������=%s", 13, 10, "a=%s", 13, 10, "b=%s", 13, 10, "c=%s", 13, 10, "d=%s", 13, 10, "�����!", 13, 10, "��������� ������� ����, ���� �� ����� ���������", 0

    MyDivisor dq 4.0               ; ������
    MyMultiplier dq 12.0           ; ������
    additiveSin dq 53.0            ; ������

.data?
    buffRes db 64 DUP(?)
    buffResA db 64 DUP(?)
    buffResB db 64 DUP(?)
    buffResC db 64 DUP(?)
    buffResD db 64 DUP(?)

    buff db 512 DUP(?)
    buffNO db 512 DUP(?)
    MyDenominator dq ?            
    FinalResult dq ?                 
    TgResult dq ?                

.code
start:
    xor esi, esi

.repeat 
    ; ���������� ����� �������� � ����� ��� ������
    invoke FloatToStr, MyArrayA[esi*8], addr buffResA
    invoke FloatToStr, MyArrayB[esi*8], addr buffResB
    invoke FloatToStr, MyArrayC[esi*8], addr buffResC
    invoke FloatToStr, MyArrayD[esi*8], addr buffResD

    finit
    fld MyArrayA[esi*8]          ; ����������� a
    fld MyArrayB[esi*8]          ; ����������� b
    fmul                          ; a * b
    fld1                          ; 1
    fsub                          ; a * b - 1
    fstp MyDenominator            ; �������� ���������

    fldz                          ; ����������� 0 ��� ���������
    fld MyDenominator             ; ����������� ���������
    fcompp
    fstsw ax
    sahf

    je veryBigProblem            ; ���� ��������� ������� ����, ���������� �� ������� �������

    fld MyArrayA[esi*8]          ; ����������� a
    fld MyArrayC[esi*8]          ; ����������� c
    fld MyDivisor                ; ����������� 4.0 (�������� divisor)
    fdiv                          ; c / 4
    fadd                          ; a + (c / 4)
    
    fld st(0)                    ; ������� ����� �������� ��� ���������� tg
    fsincos                       ; ���������� ����� �� �������
    fld st(0)                    ; ������� �������
    fld st(0)                    ; ������� �����
    fdiv                          ; tg = sin/cos
    fstp TgResult                ; �������� tg

    fld MyArrayD[esi*8]          ; ����������� d
    fld MyMultiplier              ; ����������� 12.0
    fmul                          ; 12 * d

    fld TgResult                  ; ����������� tg
    fsub                          ; tg(a + c/4) - 12 * d
    fadd additiveSin              ; ������ 53

    fld MyDenominator             ; ����������� ���������
    fdiv                          ; ����� ��������� �� ���������
    fstp FinalResult              ; �������� ��������� ���������    

    invoke FloatToStr, FinalResult, addr buffRes
    invoke wsprintf, addr buff, addr outputResultYEs, addr MyCustomFormula, addr buffResA, addr buffResB, addr buffResC, addr buffResD
    invoke MessageBox, 0, addr buff, addr MsgBoxCaption5, 0
   
    inc esi                       ; ���������� �� ���������� ��������

    .until esi == 5

    invoke ExitProcess, 0

veryBigProblem:
    invoke wsprintf, addr buffNO, addr outputResultYEsZERO, addr MyCustomFormula, addr buffResA, addr buffResB, addr buffResC, addr buffResD
    invoke MessageBox, 0, addr buffNO, addr Oh_no, 0
    jmp start 

end start

