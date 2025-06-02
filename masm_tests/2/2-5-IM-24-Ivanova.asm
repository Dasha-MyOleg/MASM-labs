.386
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

.data
    ; Заголовок повідомлення
    msgTitle db "Результати обчислень", 0

    ; Формати для виведення чисел
    msgFormat1 db "A (byte): %d (0x%02X), -A (byte): %d (0x%02X)", 13, 10, \
                "A (word): %d (0x%04X), -A (word): %d (0x%04X)", 13, 10, \
                "A (dword): %d (0x%08X), -A (dword): %d (0x%08X)", 13, 10, \
                "A (qword): %d (%08X%08Xh), -A (qword): %d (%08X%08Xh)", 13, 10, 0

    msgFormat2 db "B (word): %d (0x%04X), -B (word): %d (0x%04X)", 13, 10, \
                "B (dword): %d (0x%08X), -B (dword): %d (0x%08X)", 13, 10, \
                "B (qword): %d (%08X%08Xh), -B (qword): %d (%08X%08Xh)", 13, 10, 0

    msgFormat3 db "C (dword): %d (0x%08X), -C (dword): %d (0x%08X)", 13, 10, \
                "C (qword): %d (%08X%08Xh), -C (qword): %d (%08X%08Xh)", 13, 10, 0

    msgFormat4 db "D (real4): 0.001 (0x%08X), -D (real4): -0.001 (0x%08X)", 13, 10, \
                "E (real8): 0.078 (%08X%08Xh), -E (real8): -0.078 (%08X%08Xh)", 13, 10, \
                "F (real10): 781.427 (%08X%08X%04Xh)", 13, 10, 0

    msgFormat5 db "-F (real10): -781.427 (%08X%08X%04Xh)", 13, 10, 0





    ; Додаткові змінні
    buffer db 1024 dup(0)
    tempBuffer db 512 dup(0)
    newLine db 13, 10, 0

    ; Цілі числа
    A_byte db 4
    negA_byte db -4

    A_word dw 4
    negA_word dw -4

    A_dword dd 4
    negA_dword dd -4

    A_qword dq 4
    negA_qword dq -4

    B_word dw 402
    negB_word dw -402

    B_dword dd 402
    negB_dword dd -402

    B_qword dq 402
    negB_qword dq -402

    C_dword dd 4022005
    negC_dword dd -4022005

    C_qword dq 4022005
    negC_qword dq -4022005

    ; Числа з дробовою частиною
    D_single real4 0.001
    negD_single real4 -0.001

    E_double real8 0.078
    negE_double real8 -0.078

    F_extended real10 781.427
    negF_extended real10 -781.427

    ; Для конвертації у шістнадцятковий формат
    D_hex dd ?
    negD_hex dd ?
    E_hex dd ?, ?
    negE_hex dd ?, ?
    F_hex dd ?, ?, ?
    negF_hex dd ?, ?, ?

    ; Змінні для перетворення
    A_byte_as_dword dd ?
    negA_byte_as_dword dd ?
	
    A_word_as_dword dd ?
    negA_word_as_dword dd ?
    B_word_as_dword dd ?
    negB_word_as_dword dd ?


.code
start:
    ; Ініціалізація FPU
    finit

    ; Обробка дробових чисел
    fld D_single
    fstp dword ptr D_hex

    fld negD_single
    fstp dword ptr negD_hex

    fld E_double
    fstp qword ptr E_hex

    fld negE_double
    fstp qword ptr negE_hex

    fld F_extended
    fstp tbyte ptr F_hex

    fld negF_extended
    fstp tbyte ptr negF_hex

    ; Перетворення у dword

    ; Перетворення A_byte і negA_byte у dword
    movzx eax, A_byte       ; Zero-extend для A_byte
    mov A_byte_as_dword, eax
    movsx eax, negA_byte    ; Sign-extend для negA_byte
	and eax, 0FFh         ; Обрізаємо старші біти
    mov negA_byte_as_dword, eax


    movzx eax, A_word       ; Zero-extend для знакового числа
    mov A_word_as_dword, eax
    movsx eax, negA_word    ; Sign-extend для від'ємного числа
	and eax, 0FFFFh         ; Обрізаємо старші біти
    mov negA_word_as_dword, eax


    movzx eax, B_word       ; Zero-extend для знакового числа
    mov B_word_as_dword, eax
	movsx eax, negB_word    ; Розширення до dword
	and eax, 0FFFFh         ; Обрізаємо старші біти
	mov negB_word_as_dword, eax


    ; Форматування чисел A
	invoke wsprintf, addr buffer, addr msgFormat1, \
		   A_byte_as_dword, A_byte_as_dword, \
		   negA_dword, negA_byte_as_dword, \
		   A_word_as_dword, A_word_as_dword, \
		   negA_dword, negA_word_as_dword, \
		   A_dword, A_dword, \
		   negA_dword, negA_dword, \
		   A_qword, dword ptr [A_qword], \
		   negA_qword, dword ptr [negA_qword]


    invoke lstrcat, addr buffer, addr tempBuffer
    invoke lstrcat, addr buffer, addr newLine

    ; Форматування чисел B
    invoke wsprintf, addr tempBuffer, addr msgFormat2, \
           B_word_as_dword, B_word_as_dword, \
           negB_dword, negB_word_as_dword, \
           B_dword, B_dword, \
           negB_dword, negB_dword, \
           B_qword, dword ptr [B_qword], \
           negB_qword, dword ptr [negB_qword]

    invoke lstrcat, addr buffer, addr tempBuffer
    invoke lstrcat, addr buffer, addr newLine

    ; Форматування чисел C
    invoke wsprintf, addr tempBuffer, addr msgFormat3, \
           C_dword, C_dword, \
           negC_dword, negC_dword, \
           C_qword, dword ptr [C_qword], \
           negC_qword, dword ptr [negC_qword]
    invoke lstrcat, addr buffer, addr tempBuffer
    invoke lstrcat, addr buffer, addr newLine

    ; Форматування чисел D, E, F
    invoke wsprintf, addr tempBuffer, addr msgFormat4, \
           D_hex, negD_hex, \
           dword ptr E_hex+4, dword ptr E_hex, \
           dword ptr negE_hex+4, dword ptr negE_hex, \
           dword ptr F_hex+6, dword ptr F_hex+2, word ptr F_hex
    invoke lstrcat, addr buffer, addr tempBuffer


    invoke wsprintf, addr tempBuffer, addr msgFormat5, \
           dword ptr negF_hex+6, dword ptr negF_hex+2, word ptr negF_hex
    invoke lstrcat, addr buffer, addr tempBuffer


    ; Виведення результатів
    invoke MessageBox, NULL, addr buffer, addr msgTitle, MB_OK
    invoke ExitProcess, 0

end start
