.386
.model flat, stdcall
option casemap :none

include \masm32\include\masm32rt.inc

.data
    WindowTitle db "Заголовок вікна", 0
    ErrorMessage db "Повідомлення про помилку: знаменник нульовий!", 0
    CalculationFormula db "Формула=(a*b/4 - l) / (41 - b*a + c)", 0

    Values_A dd 12, 80, 20, -28, 4
    Values_B dd 0, 17, -7, 10, -15
    Values_C dd -41, 3, 27, -4, 1
    Values_L dd 2432, 30000, 70809, 1, 140

    EvenNumberMessage db "Формула=%s", 13, 10,
    "a=%d", 13,
    "b=%d", 13,
    "c=%d", 13,
    "l=%d", 13, 10,
    "результат %d парне", 13, 10,
    "тому якщо поділити на 2, результат=%d", 0

    OddNumberMessage db "Формула=%s", 13, 10,
    "a=%d", 13,
    "b=%d", 13,
    "c=%d", 13,
    "l=%d", 13, 10,
    "результат %d непарне", 13, 10,
    "тому якщо помножити на 5, результат=%d", 0

    ZeroNumberMessage db "Формула=%s", 13, 10,
    "a=%d", 13,
    "b=%d", 13,
    "c=%d", 13,
    "l=%d", 13, 10,
    "Знаменник нульовий, обчислення не можуть бути виконані", 0

    DivisorValue dd 4

.data?
    buffer db 128 DUP(?)
    bufferA dd ?    ; Змінна для a
    bufferB dd ?    ; Змінна для b
    bufferC dd ?    ; Змінна для c
    bufferL dd ?    ; Змінна для l
    result dd ?     ; Змінна для зберігання результату

.code
start:

xor esi, esi

.repeat 

    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx
    
    mov eax, Values_A[esi*4] ; a
    mov ebx, Values_B[esi*4] ; b
    mov ecx, Values_C[esi*4] ; c
    mov edx, Values_L[esi*4] ; l

    inc esi

    mov bufferA, eax
    mov bufferB, ebx
    mov bufferC, ecx
    mov bufferL, edx

    ; Обчислити знаменник: 41 - b*a + c
    mov edi, 41
    imul ebx, eax ; b*a
    sub edi, ebx  ; 41 - b*a
    add edi, ecx  ; + c

    ; Перевірити, чи знаменник дорівнює нулю
    .if edi == 0
        invoke wsprintf, addr buffer, addr ZeroNumberMessage, addr CalculationFormula, bufferA, \
        bufferB, bufferC, bufferL
        invoke MessageBox, 0, addr buffer, addr ErrorMessage, 0
        .continue  ; Продовжити до наступної ітерації
    .endif

    ; Обчислити чисельник: (a*b/4 - l)
    mov eax, bufferA ; a
    imul eax, bufferB ; a*b
    cdq
    idiv DivisorValue ; a*b / 4
    sub eax, bufferL ; a*b/4 - l

    ; Поділити чисельник на знаменник
    mov ecx, edi ; Знаменник
    cdq
    idiv ecx ; (a*b/4 - l) / (41 - b*a + c)

    ; Зберегти результат
    mov result, eax

    ; Перевірити, чи результат парний або непарний
    xor edx, edx
    mov ebx, 2
    mov eax, result
    div ebx

    .if edx != 0
        ; Результат непарний, помножити на 5
        mov eax, result
        imul eax, 5
        invoke wsprintf, addr buffer, addr OddNumberMessage, addr CalculationFormula, bufferA, \
        bufferB, bufferC, bufferL, result, eax
        invoke MessageBox, 0, addr buffer, addr WindowTitle, 0
        .continue
    .endif

    ; Результат парний, поділити на 2
    mov eax, result
    cdq
    idiv ebx
    invoke wsprintf, addr buffer, addr EvenNumberMessage, addr CalculationFormula, bufferA, \
    bufferB, bufferC, bufferL, result, eax
    invoke MessageBox, 0, addr buffer, addr WindowTitle, 0

    .until esi == 5

    invoke ExitProcess, 0

end start