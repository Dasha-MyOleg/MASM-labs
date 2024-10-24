extrn MessageBoxA: PROC  
extrn ExitProcess: PROC
extrn GetStdHandle: PROC
extrn WriteFile: PROC

.data
    message db 'Full Name: Ivanova Daria Ivanivna', 13, 10,  
            'Date of Birth: 04.02.2005', 13, 10,              
            'Student ID: 125635', 13, 10,                     
            'Favorite Animal: Rat', 0                         
    caption db 'Personal Data', 0                           
    consoleMessage db 'Program started...', 0               
    STD_OUTPUT_HANDLE equ -11
    bytesWritten dq 0
    messageLength dq ($ - consoleMessage)

.code
main PROC
    sub rsp, 28h

    ; Виводимо діагностичне повідомлення в консоль
    mov rcx, STD_OUTPUT_HANDLE
    call GetStdHandle
    mov rdx, offset consoleMessage
    mov r8, messageLength
    mov r9, offset bytesWritten
    call WriteFile

    ; Викликаємо MessageBoxA
    mov rcx, 0                             ; Хендл вікна (NULL)
    mov rdx, offset message                ; Адреса повідомлення
    mov r8, offset caption                 ; Адреса заголовка
    mov r9d, 0                             ; MB_OK
    call MessageBoxA                       ; Виклик MessageBoxA для UTF-8

    xor rcx, rcx                           ; Аргумент для ExitProcess (0)
    call ExitProcess                       ; Виклик ExitProcess

    add rsp, 28h
    ret
main ENDP

END
