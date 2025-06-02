.386
.model flat, stdcall
option casemap :none

include \masm32\include\masm32rt.inc

.data
    Oh_no db "Ой ні!", 0
    MsgBoxCaption5 db "Обчислення", 0

    MyArrayA dq 9.52, 14.5, 10.0, 5.8, 1.0, 7.3    
    MyArrayB dq 4.89, 3.7, 1.8, -0.5,  1.0, -5.3  
    MyArrayC dq 2.45, 3.0, 5.7, 9.2, 4.9, -9.0
    MyArrayD dq -1.82, 15.4, -34.5, 7.0, 4.8, -44.4

    MyCustomFormula db "(tg(a + c / 4) - 12 * d) / (a * b - 1)", 0 

    outputResultTable db "Формула: %s", 13, 10, "a = %s", 13, 10, "b = %s", 13, 10, "c = %s", 13, 10, "d = %s", 13, 10, \
                      "Чисельник = %s", 13, 10, "Знаменник = %s", 13, 10, "Результат = %s", 0
    outputResultYEsZERO db "Формула: %s", 13, 10, "a = %s", 13, 10, "b = %s", 13, 10, "c = %s", 13, 10, "d = %s", 13, 10, \
                         "Увага!", 13, 10, "знаменник дорівнює нулю, його не можна обчислити", 0

    MyDivisor dq 4.0               
    MyMultiplier dq 12.0           
    additiveSin dq 53.0            

.data?
    buffRes db 64 DUP(?)
    buffResA db 64 DUP(?)
    buffResB db 64 DUP(?)
    buffResC db 64 DUP(?)
    buffResD db 64 DUP(?)

    buffNumerator db 64 DUP(?)       ; Буфер для чисельника
    buffDenominator db 64 DUP(?)     ; Буфер для знаменника
    buff db 512 DUP(?)
    buffNO db 512 DUP(?)
    MyDenominator dq ?               
    FinalResult dq ?                 
    TgResult dq ?                    
    Numerator dq ?                   ; Змінна для збереження чисельника

.code
start:
    xor esi, esi

repeat_loop: 
    ; Конвертуємо вхідні значення в рядок для виводу
    invoke FloatToStr, MyArrayA[esi*8], addr buffResA
    invoke FloatToStr, MyArrayB[esi*8], addr buffResB
    invoke FloatToStr, MyArrayC[esi*8], addr buffResC
    invoke FloatToStr, MyArrayD[esi*8], addr buffResD

    finit
    fld MyArrayA[esi*8]          
    fld MyArrayB[esi*8]          
    fmul                          
    fld1                          
    fsub                          
    fstp MyDenominator            

    fldz                          
    fld MyDenominator             
    fcompp
    fstsw ax
    sahf

    je veryBigProblem            

    ; Розрахунок чисельника
    fld MyArrayA[esi*8]          ; Завантаження a
    fld MyArrayC[esi*8]          ; Завантаження c
    fld MyDivisor                ; Завантаження подільника для c
    fdiv                          ; c / 4
    fadd                          ; a + c / 4

    fsincos                       ; Обчислення синуса і косинуса
    fdiv                          ; Тангенс (синус / косинус)
    fstp TgResult                 ; Збереження тангенса

    fld MyArrayD[esi*8]           ; Завантаження d
    fld MyMultiplier              ; Завантаження множника для d
    fmul                          ; 12 * d

    fld TgResult                  ; Завантаження tg(a + c / 4)
    fsub                          ; tg(a + c / 4) - 12 * d
    fchs
    fstp Numerator                ; Збереження чисельника

    ; Ділення чисельника на знаменник для остаточного результату
    fld Numerator                 ; Завантаження чисельника
    fld MyDenominator             ; Завантажуємо знаменник
    fdiv                          ; Ділення чисельника на знаменник
    fstp FinalResult              ; Збереження остаточного результату

    ; Конвертуємо чисельник у рядок
    invoke FloatToStr, Numerator, addr buffNumerator          

    ; Конвертуємо знаменник та результат у рядки
    invoke FloatToStr, MyDenominator, addr buffDenominator
    invoke FloatToStr, FinalResult, addr buffRes

    ; Формуємо вихідне повідомлення
    invoke wsprintf, addr buff, addr outputResultTable, addr MyCustomFormula, addr buffResA, addr buffResB, addr buffResC, addr buffResD, addr buffNumerator, addr buffDenominator, addr buffRes
    invoke MessageBox, 0, addr buff, addr MsgBoxCaption5, 0
   
    inc esi                       

    cmp esi, 5                    ; Перевірка на 5 ітерацій
    jl repeat_loop                ; Повертаємося на початок циклу, якщо ще є приклади

    invoke ExitProcess, 0

veryBigProblem:
    ; Повідомлення про помилку при нульовому знаменнику
    invoke wsprintf, addr buffNO, addr outputResultYEsZERO, addr MyCustomFormula, addr buffResA, addr buffResB, addr buffResC, addr buffResD
    invoke MessageBox, 0, addr buffNO, addr Oh_no, 0
    inc esi                       
    jmp repeat_loop               

end start