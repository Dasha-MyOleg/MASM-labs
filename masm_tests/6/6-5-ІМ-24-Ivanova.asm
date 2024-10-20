.386
.model flat, stdcall
option casemap :none

include \masm32\include\masm32rt.inc

.data
    Oh_no db "Ой ні!", 0
    MsgBoxCaption5 db "Обчислення", 0

    MyArrayA dq 1.0, 14.5, 10.0, 5.8, 18.7     
    MyArrayB dq 1.0, 3.7, 1.8, -0.5, 10.2      
    MyArrayC dq 2.8, -3.0, 5.7, 9.2, -3.5  
    MyArrayD dq 13.0, 15.4, 2.5, 7.0, 8.7

    MyCustomFormula db "(tg(a + c / 4) - 12 * d) / (a * b - 1)", 0 

    outputResultYEs db "Формула=%s", 13, 10, "a=%s", 13, 10, "b=%s", 13, 10, "c=%s", 13, 10, "d=%s", 13, 10, "результат=%s", 0
    outputResultYEsZERO db "Формула=%s", 13, 10, "a=%s", 13, 10, "b=%s", 13, 10, "c=%s", 13, 10, "d=%s", 13, 10, "Увага!", 13, 10, "знаменник дорівнює нулю, його не можна обчислити", 0

    MyDivisor dq 4.0               
    MyMultiplier dq 12.0           
    additiveSin dq 53.0            

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

    fld MyArrayA[esi*8]          
    fld MyArrayC[esi*8]          
    fld MyDivisor                
    fdiv                          
    fadd                          
    
    fld st(0)                    
    fsincos                       
    fld st(0)                    
    fld st(0)                    
    fdiv                          
    fstp TgResult                

    fld MyArrayD[esi*8]          
    fld MyMultiplier              
    fmul                          

    fld TgResult                  
    fsub                          
    fadd additiveSin              

    fld MyDenominator             
    fdiv                          
    fstp FinalResult              

    ; Переконайтеся, що результат правильно конвертується у рядок
    invoke FloatToStr, FinalResult, addr buffRes
    invoke wsprintf, addr buff, addr outputResultYEs, addr MyCustomFormula, addr buffResA, addr buffResB, addr buffResC, addr buffResD, addr buffRes
    invoke MessageBox, 0, addr buff, addr MsgBoxCaption5, 0
   
    inc esi                       

    cmp esi, 5                    ; Перевірка на 5 ітерацій
    jl repeat_loop                ; Повертаємося на початок циклу, якщо ще є приклади

    invoke ExitProcess, 0

veryBigProblem:
    invoke wsprintf, addr buffNO, addr outputResultYEsZERO, addr MyCustomFormula, addr buffResA, addr buffResB, addr buffResC, addr buffResD
    invoke MessageBox, 0, addr buffNO, addr Oh_no, 0
    inc esi                       ; Перехід до наступного прикладу
    jmp repeat_loop               ; Повертаємося на початок циклу 

end start

