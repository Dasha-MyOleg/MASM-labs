.386
.model flat, stdcall
option casemap :none

include \masm32\include\masm32rt.inc

.data
    Oh_no db "Ой ні!", 0
    MsgBoxCaption5 db "Обчислення", 0

    MyArrayA dq 1.0, 14.5, 10.0, 5.8, 18.7     ; Зміна значення в масиві
    MyArrayB dq 1.0, 3.7, 1.8, -0.5, 10.2      ; Зміна значення в масиві
    MyArrayC dq 2.8, -3.0, 5.7, 9.2, -3.5  
    MyArrayD dq 13.0, 15.4, 2.5, 7.0, 8.7

    MyCustomFormula db "(tg(a + c / 4) - 12 * d) / (a * b - 1)", 0 

    outputResultYEs db "Формула=%s", 13, 10, "a=%s", 13, 10, "b=%s", 13, 10, "c=%s", 13, 10, "d=%s", 13, 10, "результат=%s", 0
    outputResultYEsZERO db "Формула=%s", 13, 10, "a=%s", 13, 10, "b=%s", 13, 10, "c=%s", 13, 10, "d=%s", 13, 10, "Увага!", 13, 10, "знаменник дорівнює нулю, його не можна обчислити", 0

    MyDivisor dq 4.0               ; Додано
    MyMultiplier dq 12.0           ; Додано
    additiveSin dq 53.0            ; Додано

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
    ; Конвертуємо вхідні значення в рядок для виводу
    invoke FloatToStr, MyArrayA[esi*8], addr buffResA
    invoke FloatToStr, MyArrayB[esi*8], addr buffResB
    invoke FloatToStr, MyArrayC[esi*8], addr buffResC
    invoke FloatToStr, MyArrayD[esi*8], addr buffResD

    finit
    fld MyArrayA[esi*8]          ; Завантажуємо a
    fld MyArrayB[esi*8]          ; Завантажуємо b
    fmul                          ; a * b
    fld1                          ; 1
    fsub                          ; a * b - 1
    fstp MyDenominator            ; Зберігаємо знаменник

    fldz                          ; Завантажуємо 0 для порівняння
    fld MyDenominator             ; Завантажуємо знаменник
    fcompp
    fstsw ax
    sahf

    je veryBigProblem            ; Якщо знаменник дорівнює нулю, переходимо до обробки помилки

    fld MyArrayA[esi*8]          ; Завантажуємо a
    fld MyArrayC[esi*8]          ; Завантажуємо c
    fld MyDivisor                ; Завантажуємо 4.0 (значення divisor)
    fdiv                          ; c / 4
    fadd                          ; a + (c / 4)
    
    fld st(0)                    ; Копіюємо верхнє значення для обчислення tg
    fsincos                       ; Обчислюємо синус та косинус
    fld st(0)                    ; Копіюємо косинус
    fld st(0)                    ; Копіюємо синус
    fdiv                          ; tg = sin/cos
    fstp TgResult                ; Зберігаємо tg

    fld MyArrayD[esi*8]          ; Завантажуємо d
    fld MyMultiplier              ; Завантажуємо 12.0
    fmul                          ; 12 * d

    fld TgResult                  ; Завантажуємо tg
    fsub                          ; tg(a + c/4) - 12 * d
    fadd additiveSin              ; додаємо 53

    fld MyDenominator             ; Завантажуємо знаменник
    fdiv                          ; ділимо результат на знаменник
    fstp FinalResult              ; Зберігаємо фінальний результат    

    invoke FloatToStr, FinalResult, addr buffRes
    invoke wsprintf, addr buff, addr outputResultYEs, addr MyCustomFormula, addr buffResA, addr buffResB, addr buffResC, addr buffResD
    invoke MessageBox, 0, addr buff, addr MsgBoxCaption5, 0
   
    inc esi                       ; Переходимо до наступного елемента

    .until esi == 5

    invoke ExitProcess, 0

veryBigProblem:
    invoke wsprintf, addr buffNO, addr outputResultYEsZERO, addr MyCustomFormula, addr buffResA, addr buffResB, addr buffResC, addr buffResD
    invoke MessageBox, 0, addr buffNO, addr Oh_no, 0
    jmp start 

end start

