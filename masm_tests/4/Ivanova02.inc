;; Ivanova02.inc

; Макрос для шифрування введеного пароля
EncryptPassword macro passwordPtr
    local xorLoop

    mov edi, passwordPtr          ;; Вказівник на буфер пароля
    mov ecx, 5                    ;; Довжина пароля в байтах
    lea esi, XorKey

    xorLoop:
        mov bl, byte ptr [edi]          ;; Завантаження символу пароля
        xor bl, byte ptr [esi]          ;; XOR з відповідним байтом ключа
        mov byte ptr [edi], bl          ;; Збереження зашифрованого символу
        inc edi
        inc esi
        loop xorLoop
endm

; Макрос для точного побайтного порівняння
CompareEncryptedPassword macro inputPtr, originalHashPtr
    local notEqual
    mov esi, inputPtr
    mov edi, originalHashPtr
    mov ecx, 5                           ;; Кількість символів пароля для порівняння

    repe cmpsb                           ;; Порівняння байтів один за одним
    jne notEqual                         ;; Якщо є різниця — не збігаються
    jmp PasswordCorrect                  ;; Якщо паролі збігаються, виконується ця секція

notEqual:
    jmp PasswordIncorrect                ;; Якщо паролі не збігаються
endm

; Макрос для виведення тексту з використанням MessageBox
ShowMessage macro text, title
    invoke MessageBoxA, NULL, text, title, MB_OK
endm
