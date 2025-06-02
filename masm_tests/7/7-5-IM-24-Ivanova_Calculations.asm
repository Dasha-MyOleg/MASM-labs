.386
.model flat, stdcall
option casemap :none

;include \masm32\include\masm32rt.inc
;includelib \masm32\lib\kernel32.lib
;includelib \masm32\lib\user32.lib


PUBLIC CalculateDenominator

EXTRN DenominatorArrayA:QWORD             ; ���������� ���������� ������ MyArrayA
EXTRN DenominatorArrayB:QWORD             ; ���������� ���������� ������ MyArrayB
EXTRN MyDenominator:QWORD                 ; ���������� �������� ����� MyDenominator


.code
    CalculateDenominator PROC
        ;a * b - 1
        fld DenominatorArrayA                 ; ������������ �������� DenominatorArrayA
        fld DenominatorArrayB                 ; ������������ �������� DenominatorArrayB
        fmul                                  ; ��������
        fld1                                  ; ������������ ��������� 1
        fsub                                  ; ³������� 1
        fstp MyDenominator                    ; ���������� ���������� � MyDenominator
        RET
    CalculateDenominator ENDP

END