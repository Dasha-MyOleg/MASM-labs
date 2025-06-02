.386
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32rt.inc
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\msvcrt.lib

.data?
    PasswordBuffer db 15 dup (?)     ; Буфер для введеного користувачем пароля
    ;InitialEncryptedPass db 2Ah, 3Bh, 29h, 29h, 13h, 17h, 2Ah 


.data
    ; "passIMp" зашифрований вручну за допомогою XOR 5Ah
    InitialEncryptedPass db 2Ah, 3Bh, 29h, 29h, 13h, 17h, 0Ah, 0 
    ; PasswordBuffer db 15 dup (?)     ; Буфер для введеного користувачем пароля
    
    StudentDetails db "Іванова Дар'я Іванівна", 13, 10, "Дата народження: 04.02.2005", 13, 10, "Залікова книжка: 5147", 0
    ErrorMsg db "Хибний пароль", 0
    PromptMsg db "Введіть пароль:", 0
    DialogTitle db "Персональні дані студента", 0
    TitleInput db "Перевірка пароля", 0
    XorKey db 5Ah  ; Ключ для XOR
    

dialogHandler PROTO :DWORD, :DWORD, :DWORD, :DWORD

.code
main:
;invoke MessageBoxA, NULL, addr InitialEncryptedPass, addr TitleInput, MB_OK

    Dialog "Персональні дані студента", "Times New Roman", 15, \
        WS_OVERLAPPED or WS_SYSMENU or DS_CENTER, \
        4, 10, 10, 150, 70, 1024  
    DlgStatic "Введіть пароль:", SS_CENTER, 30,  2, 80,  15, 100  
    DlgEdit   WS_BORDER, 10,  18, 130, 10, 5089  
    DlgButton "Продовжити", WS_TABSTOP, 10,  40, 40,  10, IDOK  
    DlgButton "Вийти", WS_TABSTOP, 100, 40, 40,  10, IDCANCEL

    CallModalDialog 0, 0, dialogHandler, NULL
    ;invoke MessageBoxA, NULL, addr InitialEncryptedPass, addr TitleInput, MB_OK


encryptXOR proc
    


    ; Шифруємо введений користувачем пароль PasswordBuffer
    mov edi, offset PasswordBuffer
    mov ecx, 7  ; Довжина пароля
    xorLoopPassword:
        mov al, byte ptr [edi]
        xor al, XorKey  ; Застосовуємо XOR з ключем
        mov byte ptr [edi], al
        inc edi
        loop xorLoopPassword
    ret
encryptXOR endp

checkOnEquality proc
    ; Шифруємо введений пароль
    invoke encryptXOR

    ; Перевіряємо довжину введеного пароля
    mov ecx, 0
    mov edi, offset PasswordBuffer
    
checkLengthLoop:
    cmp byte ptr [edi + ecx], 0   ; Перевірка на кінець рядка
    je passwordLengthCheckDone
    inc ecx
    cmp ecx, 7
    ja incorrectPassword           ; Якщо більше 7 символів, виводимо помилку
    jmp checkLengthLoop


passwordLengthCheckDone:

    cmp ecx, 7                     ; Перевірка, чи введено рівно 7 символів
    jne incorrectPassword          ; Якщо довжина не 7, виводимо помилку

    ; Порівняння зашифрованого введеного пароля з InitialEncryptedPass
    mov esi, offset InitialEncryptedPass
    mov edi, offset PasswordBuffer
    mov ecx, 7                     ; Тепер порівнюємо всі 7 символів
    repe cmpsb
    jne incorrectPassword

correctPassword:
    invoke MessageBoxA, NULL, addr StudentDetails, addr DialogTitle, MB_OK
    invoke ExitProcess, 0

incorrectPassword:
    ;invoke MessageBoxA, NULL, addr PasswordBuffer, addr TitleInput, MB_OK

    invoke MessageBoxA, NULL, addr ErrorMsg, addr DialogTitle, MB_OK
    invoke ExitProcess, 0
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
        invoke GetDlgItemText, hWnd, 5089, addr PasswordBuffer, 15
        invoke checkOnEquality
    .elseif wParam == IDCANCEL
        invoke ExitProcess, 0
    .endif
    return 0

dialogHandler endp

end main


