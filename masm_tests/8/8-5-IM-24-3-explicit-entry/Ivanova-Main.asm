.386
.model flat, stdcall
option casemap :none

; ϳ��������� ������� �������
; ��������������� masm32rt.inc ��� ���������� ��������� ������� Windows API:
; - FloatToStr � ����������� ����� � �����
; - wsprintf � ������������ ����� ����� ���������� � ����
; - MessageBox � ��������� ���������� � ������ ���������� ����
; - ExitProcess � ���������� ������ ��������
include \masm32\include\masm32rt.inc

.data
    Oh_no db "�� �!", 0
    MsgBoxCaption5 db "����������", 0

    MyArrayA dq 9.52, 14.5, -10.0, 5.8, 2.5
    MyArrayB dq 4.89, 3.7, 1.8, -0.5, 0.4
    MyArrayC dq 2.45, 3.0, 5.7, 9.2, 4.9
    MyArrayD dq -1.82, 15.4, -34.5, 7.0, 4.8

    MyCustomFormula db "(tg(a + c / 4) - 12 * d) / (a * b - 1)", 0 

    outputResultTable db "�������: %s", 13, 10, "a = %s", 13, 10, "b = %s", 13, 10, "c = %s", 13, 10, "d = %s", 13, 10, \
                      "��������� = %s", 13, 10, "��������� = %s", 13, 10, "��������� = %s", 0
    outputResultYEsZERO db "�������: %s", 13, 10, "a = %s", 13, 10, "b = %s", 13, 10, "c = %s", 13, 10, "d = %s", 13, 10, \
                         "�����! ��������� ������� ����. ��������� �������� ����������.", 0

    MyDivisor dq 4.0
    MyMultiplier dq 12.0

.data?
    buffRes db 64 DUP(?)
    buffResA db 64 DUP(?)
    buffResB db 64 DUP(?)
    buffResC db 64 DUP(?)
    buffResD db 64 DUP(?)

    buffNumerator db 64 DUP(?)      
    buffDenominator db 64 DUP(?)    
    buff db 512 DUP(?)
    buffNO db 512 DUP(?)

    DenominatorArrayA dq ?
    DenominatorArrayB dq ?
    MyDenominator dq ?
    FinalResult dq ?
    TgResult dq ?
    Numerator dq ?

.code

main:
    xor esi, esi

repeat_loop:
    cmp esi, 5
    je exit_loop

    ; ���������� �������� � ������
    invoke FloatToStr, MyArrayA[esi*8], addr buffResA
    invoke FloatToStr, MyArrayB[esi*8], addr buffResB
    invoke FloatToStr, MyArrayC[esi*8], addr buffResC
    invoke FloatToStr, MyArrayD[esi*8], addr buffResD

    ; ����������� �������� � ���� ��� ���������� ����������
    fld MyArrayA[esi*8]
    fld MyArrayB[esi*8]
    fmul
    fld1
    fsub
    fstp MyDenominator

    ; ����������, �� ��������� ������� ����
    fldz
    fld MyDenominator
    fcompp
    fstsw ax
    sahf
    je veryBigProblem

    ; ���������� ����������
    CALL CalculateNumeratorRegisterPart
    CALL CalculateNumeratorStackPart

    ; ���������� ����������
    fld Numerator
    fld MyDenominator
    fdiv
    fstp FinalResult

    ; ���������� ���������, ��������� � ��������� � ������
    invoke FloatToStr, Numerator, addr buffNumerator
    invoke FloatToStr, MyDenominator, addr buffDenominator
    invoke FloatToStr, FinalResult, addr buffRes

    ; �������� ���������
    invoke wsprintf, addr buff, addr outputResultTable, addr MyCustomFormula, addr buffResA, addr buffResB, addr buffResC, addr buffResD, addr buffNumerator, addr buffDenominator, addr buffRes
    invoke MessageBox, 0, addr buff, addr MsgBoxCaption5, 0

    inc esi
    jmp repeat_loop

veryBigProblem:
    ; �������� ���������� ���� ��� ��������� ����������
    invoke wsprintf, addr buffNO, addr outputResultYEsZERO, addr MyCustomFormula, addr buffResA, addr buffResB, addr buffResC, addr buffResD
    invoke MessageBox, 0, addr buffNO, addr Oh_no, 0

    finit                      ; �������� �����
    inc esi                    ; ������� �� ���������� ��������
    jmp repeat_loop


exit_loop:
    invoke ExitProcess, 0

CalculateNumeratorRegisterPart PROC
    fld MyArrayA[esi*8]
    fld MyArrayC[esi*8]
    fld MyDivisor
    fdiv
    fadd
    fsincos
    fdiv
    fstp TgResult
    ret
CalculateNumeratorRegisterPart ENDP

CalculateNumeratorStackPart PROC
    fld TgResult
    fld MyArrayD[esi*8]
    fld MyMultiplier
    fmul
    fsub
    fstp Numerator
    ret
CalculateNumeratorStackPart ENDP

END main
