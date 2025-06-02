.386
.model flat, stdcall
option casemap:none

; Підключення зовнішніх бібліотек та інклюдів
include \masm32\include\windows.inc    ; Файл з основними Windows API функціями
include \masm32\include\user32.inc     ; Функції для роботи з графічним інтерфейсом
include \masm32\include\kernel32.inc   ; Функції для базових операцій ОС
include \masm32\include\masm32rt.inc   ; Базові функції MASM32

includelib \masm32\lib\user32.lib      ; Бібліотека для графічного інтерфейсу
includelib \masm32\lib\kernel32.lib    ; Бібліотека для системних викликів
includelib \masm32\lib\msvcrt.lib      ; Бібліотека C runtime

.data?
    PasswordBuffer db 15 dup (?)         ; Введений користувачем пароль

.data
    ; Зашифрований пароль "54321" із ключем XOR
    InitialEncryptedPass db 5Ah, 78h, 09h, 2Fh, 4Ah
    StudentName db "Іванова Дар'я Іванівна", 0
    BirthDate db "Дата народження: 04.02.2005", 0
    RecordBook db "Залікова книжка: 5147", 0
    ErrorMsg db "Хибний пароль", 0
    SuccessMsg db "Пароль вірний", 0
    PromptMsg db "Введіть пароль:", 0
    DialogTitle db "Персональні дані студента", 0
    XorKey db 6Fh, 4Ch, 3Ah, 1Dh, 7Bh  ; Ключ для XOR
    HexMessage db "Зашифрований пароль: %02X %02X %02X %02X %02X", 0
    BufferForHex db 50 dup (?)          ; Буфер для форматування шістнадцяткових значень

dialogHandler PROTO :DWORD, :DWORD, :DWORD, :DWORD

; Макрос для шифрування введеного паролю
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

ShowMessage macro text, title
    invoke MessageBoxA, NULL, text, title, MB_OK
endm

.code
main:
    ; Налаштування діалогового вікна
    Dialog "Персональні дані студента", "Times New Roman", 15, \
        WS_OVERLAPPED or WS_SYSMENU or DS_CENTER, \
        4, 10, 10, 150, 70, 1024  
    DlgStatic "Введіть пароль:", SS_CENTER, 30,  2, 80,  15, 100  
    DlgEdit   WS_BORDER, 10,  18, 130, 10, 5089  
    DlgButton "Продовжити", WS_TABSTOP, 10,  40, 40,  10, IDOK  
    DlgButton "Вийти", WS_TABSTOP, 100, 40, 40,  10, IDCANCEL

    CallModalDialog 0, 0, dialogHandler, NULL

checkOnEquality proc hWnd:DWORD
    ; Отримання введеного пароля
    invoke GetDlgItemText, hWnd, 5089, addr PasswordBuffer, 15
    ; Шифрування введеного пароля
    EncryptPassword offset PasswordBuffer             

    ;; Виведення зашифрованого пароля в шістнадцятковому форматі
    ;;invoke wsprintf, addr BufferForHex, addr HexMessage, \
    ;;    byte ptr PasswordBuffer[0], byte ptr PasswordBuffer[1], \
    ;;    byte ptr PasswordBuffer[2], byte ptr PasswordBuffer[3], \
    ;;    byte ptr PasswordBuffer[4]
    ;;invoke MessageBoxA, NULL, addr BufferForHex, addr DialogTitle, MB_OK

    ;; Діагностичне повідомлення після шифрування
    ;;ShowMessage offset PasswordBuffer, offset DialogTitle

    ; Порівняння зашифрованого пароля з очікуваним значенням
    CompareEncryptedPassword offset PasswordBuffer, offset InitialEncryptedPass 

PasswordCorrect:
    ;;ShowMessage offset SuccessMsg, offset DialogTitle ; Повідомлення про успіх
    ShowMessage offset StudentName, offset DialogTitle
    ShowMessage offset BirthDate, offset DialogTitle
    ShowMessage offset RecordBook, offset DialogTitle
    invoke ExitProcess, 0

PasswordIncorrect:
    ShowMessage offset ErrorMsg, offset DialogTitle ;; Повідомлення про невірний пароль
    invoke ExitProcess, 0                           ;; Завершення програми, якщо пароль невірний
checkOnEquality endp

dialogHandler proc hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
    .if uMsg == WM_INITDIALOG
        jmp createDialogWindow

    .elseif uMsg == WM_CLOSE
        invoke ExitProcess, 0

    .elseif uMsg == WM_COMMAND
        jmp handleOKorCancel

    .endif

createDialogWindow:
    invoke GetWindowLong, hWnd, GWL_USERDATA
    return 0

handleOKorCancel:
    .if wParam == IDOK
        invoke checkOnEquality, hWnd ; Передаємо hWnd до процедури
    .elseif wParam == IDCANCEL
        invoke ExitProcess, 0
    .endif
    return 0

dialogHandler endp

end main
