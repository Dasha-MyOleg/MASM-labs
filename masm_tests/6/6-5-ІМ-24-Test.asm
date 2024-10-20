.386
.model flat, stdcall
option casemap :none

include \masm32\include\masm32rt.inc

.data
    Oh_no db "OH NOOOO!", 0
    MsgBoxCaption5 db "Calculation", 0

    ArrayOf_A_sses dq 14.2, 12.4, 10.1, 3.6, 11.3
    ArrayOf_B_sses dq 2.7, 3.1, 8.9, -7.3, 3.5
    ArrayOf_C_sses dq -3.4, -3.8, 4.3, 40.7, 31.6
    ArrayOf_D_sses dq 4.1, 6.1, 5.4, 5.1, 9.8

    myFormulaBy6Variant db "(tg(a + c/4) - 12*d) / (a*b - 1)", 0 

    outputResultYEs db "Formula=%s", 13, 10, "a=%s", 13, 10, "b=%s", 13, 10, "c=%s", 13, 10, "d=%s", 13, 10, "result=%s", 0
    outputResultYEsZERO db "Formula=%s", 13, 10, "a=%s", 13, 10, "b=%s", 13, 10, "c=%s", 13, 10, "d=%s", 13, 10, "Anyway", 13, 10, "denominator is equal to zero, it can't be calculated", 0

    multiplicand dq 12.0
    divisorA dq 4.0               ; Додано визначення divisorA

.data?
    buffRes db 64 DUP(?)
    buffResA db 64 DUP(?)
    buffResB db 64 DUP(?)
    buffResC db 64 DUP(?)
    buffResD db 64 DUP(?)

    buff db 512 DUP(?)
    buffNO db 512 DUP(?)
    denominator dt ?
    result dq ?
    tgValue dt ?

.code
start:
    xor esi, esi

.repeat 
    ; Convert input values to string for output
    invoke FloatToStr, ArrayOf_A_sses[esi*8], addr buffResA
    invoke FloatToStr, ArrayOf_B_sses[esi*8], addr buffResB
    invoke FloatToStr, ArrayOf_C_sses[esi*8], addr buffResC
    invoke FloatToStr, ArrayOf_D_sses[esi*8], addr buffResD

    finit
    fld ArrayOf_A_sses[esi*8]     ; Load A
    fld ArrayOf_C_sses[esi*8]     ; Load C
    fdiv divisorA                  ; C / 4
    fadd                           ; A + (C / 4)
    fptan                         ; tg(A + C / 4)
    fstp tgValue                   ; Store tg value

    fld multiplicand               ; Load 12
    fld ArrayOf_D_sses[esi*8]     ; Load D
    fmul                          ; 12 * D
    fsub                          ; tg(A + C/4) - 12 * D

    fld ArrayOf_A_sses[esi*8]     ; Load A again
    fld ArrayOf_B_sses[esi*8]     ; Load B
    fmul                          ; A * B
    fld1                          ; Load constant 1
    fsub                          ; (A * B) - 1
    fstp denominator                ; Store denominator

    fldz                          ; Load 0
    fld denominator               ; Load denominator
    fcompp                       ; Compare with 0
    fstsw ax                     ; Store status word
    sahf                        ; Update flags
    je veryBigProblem            ; If denominator is 0, jump to error handling

    fld tgValue                  ; Load tg value
    fld denominator               ; Load denominator
    fdiv                         ; (tg(A + C/4) - 12 * D) / (A * B - 1)
    fstp result                   ; Store result

    ; Format and display result
    invoke FloatToStr, result, addr buffRes
    invoke wsprintf, addr buff, addr outputResultYEs, addr myFormulaBy6Variant, addr buffResA, addr buffResB, addr buffResC, addr buffResD, addr buffRes
    invoke MessageBox, 0, addr buff, addr MsgBoxCaption5, 0
   
    inc esi                     ; Move to next set of inputs
    .until esi == 5             ; Repeat for all inputs

    invoke ExitProcess, 0

veryBigProblem:
    inc esi                     ; Move to next set of inputs
    invoke wsprintf, addr buffNO, addr outputResultYEsZERO, addr myFormulaBy6Variant, addr buffResA, addr buffResB, addr buffResC, addr buffResD
    invoke MessageBox, 0, addr buffNO, addr Oh_no, 0
    jmp start                   ; Restart the loop

end start
