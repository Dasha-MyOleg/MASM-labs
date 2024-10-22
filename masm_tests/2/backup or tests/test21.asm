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
    finit                      ; Ініціалізуємо FPU
    
    ; Обробляємо число D
    fld D                     
    fistp D_int                 
    fld D                     
    fsub D_int                  
    fmul tenpow3                
    fistp D_frac                

    ; Обробляємо від'ємне число D
    fld negD                  
    fistp negD_int              
    fld negD                   
    fabs                     
    fsub negD_int               
    fmul tenpow3                
    fistp negD_frac             

    ; Обробляємо число E
    fld E                     
    fistp E_int                 
    fld E                     
    fsub E_int                  
    fmul tenpow3                
    fistp E_frac                

    ; Обробляємо від'ємне число E
    fld negE                  
    fistp negE_int              
    fld negE                   
    fabs                     
    fsub negE_int               
    fmul tenpow3                
    fistp negE_frac             

; Обробка числа F

    fld F                      ; Завантажити F в FPU
    fild tenpow3              ; Завантажити 1000 як ціле число
    fistp F_int               ; Зберегти цілу частину F без округлення



    fld st(0)                 ; Завантажити дробову частину (0.555)
    fmul tenpow3              ; Множити дробову частину на 1000 (переносимо кому на 3 знаки вперед)
    fistp F_frac              ; Зберегти дробову частину як ціле число






    ; Обробка від'ємного числа negF
    fld negF                   ; Завантажити negF в FPU
    fistp negF_int             ; Зберегти цілу частину negF
    fld negF                   ; Завантажити negF знову
    fsub negF_int              ; Відняти цілу частину, залишити дробову частину
    fmul tenpow3               ; Множити дробову частину на 1000
    fistp negF_frac            ; Зберегти дробову частину


    ; Формуємо повідомлення
    invoke wsprintf, addr buffer, addr msgFormat, A, negA, B, negB, C_val, negC, \
            D_int, D_frac, negD_int, negD_frac, E_int, E_frac, negE_int, negE_frac, \
            F_int, F_frac, negF_int, negF_frac 

    ; Виводимо повідомлення
    invoke MessageBoxA, 0, addr buffer, addr msgTitle, MB_OK

    ; Завершення програми
    invoke ExitProcess, 0

end start