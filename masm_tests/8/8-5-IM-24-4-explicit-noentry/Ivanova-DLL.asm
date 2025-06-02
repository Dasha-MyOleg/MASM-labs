.386
.model flat, stdcall
option casemap :none

.data
    IvanovaConstZero dq 0.0
    IvanovaConstOne dq 1.0
    IvanovaConstFour dq 4.0
    IvanovaConstTwelve dq 12.0

.data?
    IvanovaDenominator dt ?
    IvanovaNumerator dt ?
    IvanovaFinalResult dt ?

.code

PerformCalculation proc paramA:ptr qword, paramB:ptr qword, paramC:ptr qword, paramD:ptr qword, result:ptr qword
    xor eax, eax
    finit

    ; Calculating denominator: a * b - 1
    mov ebx, paramA
    fld qword ptr[ebx]
    mov ebx, paramB
    fld qword ptr[ebx]
    fmul
    fld IvanovaConstOne
    fsub

    ; Checking if denominator is zero
    fcom IvanovaConstZero
    fstsw ax
    sahf
    je DenominatorZero

    fstp IvanovaDenominator

    ; Calculating numerator: tg(a + c / 4) - 12 * d
    mov ebx, paramC
    fld qword ptr[ebx]
    fld IvanovaConstFour
    fdiv
    mov ebx, paramA
    fld qword ptr[ebx]
    fadd
    fsincos
    fstp st(0)
    mov ebx, paramD
    fld qword ptr[ebx]
    fld IvanovaConstTwelve
    fmul
    fsub
    fstp IvanovaNumerator

    ; Final calculation: numerator / denominator
    fld IvanovaNumerator
    fld IvanovaDenominator
    fdiv
    mov ebx, result
    fstp qword ptr[ebx]
    ret

DenominatorZero:
    mov eax, 1
    ret
PerformCalculation endp

end
