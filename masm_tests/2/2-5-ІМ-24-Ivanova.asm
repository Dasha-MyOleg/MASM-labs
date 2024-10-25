.386
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

.data
    msgTitle db "Результати обчислень", 0
    
    msgFormat db "A: %d (0x%X), -A: %d (0x%X)", 13, 10, \
                "B: %d (0x%X), -B: %d (0x%X)", 13, 10, \
                "C: %d (0x%X), -C: %d (0x%X)", 13, 10, \
                "D: %d.%03d (0x%X.%03X), -D: -%d.%03d (0x%X.%03X)", 13, 10, \
                "E: %d.%03d (0x%X.%03X), -E: -%d.%03d (0x%X.%03X)", 13, 10, \
                "F: %d.%03d (0x%X.%03X), -F: -%d.%03d (0x%X.%03X)", 0

    A dd 4
    B dd 402
    C_val dd 4022005
    C_int dd ?                  
    C_frac dd ?                 
    negC_int dd ?               ; Додано: від'ємна ціла частина C
    negC_frac dd ?              ; Додано: від'ємна дробова частина C
    negA dd -4
    negB dd -402
    negC dd -4022005

    D real4 0.001
    E real4 0.078
    F_string db "781.555", 0     
    negF_string db "781.555", 0    

    D_int dd ?
    D_frac dd ?
    E_int dd ?
    E_frac dd ?
    F_int dd ?
    F_frac dd ?
    negD dd -0.001               
    negD_int dd ?
    negD_frac dd ?
    negE dd -0.078               
    negE_int dd ?
    negE_frac dd ?
    negF_int dd ?
    negF_frac dd ?

    D_hex_int dd ?              
    D_hex_frac dd ?             
    E_hex_int dd ?               
    E_hex_frac dd ?             

    buffer db 512 dup(0)
    tenpow3 real4 1000.0       

.code
start:
    finit                          ; Ініціалізуємо FPU

    ; Обробка числа D
    fld D                         
    fistp D_int                   
    fld D                         
    fsub D_int                    
    fmul tenpow3                  
    fistp D_frac                  

    ; Обробка від'ємного числа D
    fld negD                      
    fistp negD_int                
    fld negD                      
    fabs                         
    fsub negD_int                 
    fmul tenpow3                  
    fistp negD_frac              

    ; Обробка числа E
    fld E                         
    fistp E_int                   
    fld E                         
    fsub E_int                    
    fmul tenpow3                  
    fistp E_frac                  

    ; Обробка від'ємного числа E
    fld negE                      
    fistp negE_int                
    fld negE                      
    fabs                         
    fsub negE_int                 
    fmul tenpow3                  
    fistp negE_frac              

    ; Обробка числа C
    fld C_val                     
    fistp C_int                  
    fld C_val                     
    fsub C_int                   
    fmul tenpow3                 
    fistp C_frac                 

    ; Обробка від'ємного числа C
    fld negC                      
    fistp negC_int                
    fld negC                      
    fabs                         
    fsub negC_int                 
    fmul tenpow3                  
    fistp negC_frac              

    ; Обробка числа F (з рядка)
    lea esi, F_string             ; Завантажити адресу F_string
    xor eax, eax                  ; Очистити EAX для зберігання цілого числа
    xor ebx, ebx                  ; Очистити EBX для зберігання дробової частини

extract_integer_F:
    movzx ecx, byte ptr [esi]     ; Завантажити символ
    cmp ecx, '.'                  ; Перевірити на крапку
    je store_integer_F            ; Якщо крапка, перейти до збереження цілого числа
    sub ecx, '0'                  ; Перетворити ASCII в число
    imul eax, 10                  ; Множити на 10
    add eax, ecx                  ; Додати нову цифру
    inc esi                       ; Перейти до наступного символу
    jmp extract_integer_F         ; Повернутися до циклу

store_integer_F:
    mov F_int, eax                ; Зберегти цілу частину

extract_fraction_F:
    inc esi                       ; Перейти через крапку
    xor ebx, ebx                  ; Очистити EBX для зберігання дробової частини

extract_fraction_loop:
    movzx ecx, byte ptr [esi]     ; Завантажити наступний символ
    cmp ecx, 0                    ; Перевірити на кінець рядка
    je store_fraction_F            ; Якщо кінець, перейти до збереження дробової частини
    sub ecx, '0'                  ; Перетворити ASCII в число
    imul ebx, 10                  ; Множити на 10
    add ebx, ecx                  ; Додати нову цифру
    inc esi                       ; Перейти до наступного символу
    jmp extract_fraction_loop      ; Повернутися до циклу

store_fraction_F:
    mov F_frac, ebx               ; Зберегти дробову частину

    ; Обробка від'ємного числа negF (з рядка)
    lea esi, negF_string          ; Завантажити адресу negF_string
    xor eax, eax                  ; Очистити EAX для зберігання цілого числа
    xor ebx, ebx                  ; Очистити EBX для зберігання дробової частини

extract_integer_negF:
    movzx ecx, byte ptr [esi]     ; Завантажити символ
    cmp ecx, '.'                  ; Перевірити на крапку
    je store_integer_negF         ; Якщо крапка, перейти до збереження цілої частини
    sub ecx, '0'                  ; Перетворити ASCII в число
    imul eax, 10                  ; Множити на 10
    add eax, ecx                  ; Додати нову цифру
    inc esi                       ; Перейти до наступного символу
    jmp extract_integer_negF       ; Повернутися до циклу

store_integer_negF:
    mov negF_int, eax             ; Зберегти цілу частину

extract_fraction_negF:
    inc esi                       ; Перейти через крапку
    xor ebx, ebx                  ; Очистити EBX для зберігання дробової частини

extract_fraction_neg_loop:
    movzx ecx, byte ptr [esi]     ; Завантажити наступний символ
    cmp ecx, 0                    ; Перевірити на кінець рядка
    je store_fraction_negF         ; Якщо кінець, перейти до збереження дробової частини
    sub ecx, '0'                  ; Перетворити ASCII в число
    imul ebx, 10                  ; Множити на 10
    add ebx, ecx                  ; Додати нову цифру
    inc esi                       ; Перейти до наступного символу
    jmp extract_fraction_neg_loop   ; Повернутися до циклу

store_fraction_negF:
    mov negF_frac, ebx            ; Зберегти дробову частину

    ; Форматування виводу
    invoke wsprintf, addr buffer, addr msgFormat, A, A, negA, negA, \
           B, B, negB, negB, C_val, C_int, negC, negC, \
           D_int, D_frac, D_hex_int, D_hex_frac, negD_int, negD_frac, \
           E_int, E_frac, E_hex_int, E_hex_frac, negE_int, negE_frac, \
           F_int, F_frac, negF_int, negF_frac

    invoke MessageBox, NULL, addr buffer, addr msgTitle, MB_OK
    invoke ExitProcess, 0
end start

