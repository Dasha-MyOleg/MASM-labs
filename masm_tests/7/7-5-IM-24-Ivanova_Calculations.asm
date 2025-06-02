.386
.model flat, stdcall
option casemap :none

;include \masm32\include\masm32rt.inc
;includelib \masm32\lib\kernel32.lib
;includelib \masm32\lib\user32.lib


PUBLIC CalculateDenominator

EXTRN DenominatorArrayA:QWORD             ; Оголошення зовнішнього масиву MyArrayA
EXTRN DenominatorArrayB:QWORD             ; Оголошення зовнішнього масиву MyArrayB
EXTRN MyDenominator:QWORD                 ; Оголошення зовнішньої змінної MyDenominator


.code
    CalculateDenominator PROC
        ;a * b - 1
        fld DenominatorArrayA                 ; Завантаження значення DenominatorArrayA
        fld DenominatorArrayB                 ; Завантаження значення DenominatorArrayB
        fmul                                  ; Множення
        fld1                                  ; Завантаження константи 1
        fsub                                  ; Віднімання 1
        fstp MyDenominator                    ; Збереження результату в MyDenominator
        RET
    CalculateDenominator ENDP

END