.386
.model flat, stdcall
option casemap:none

include C:\masm32\include\windows.inc
include C:\masm32\include\user32.inc
include C:\masm32\include\kernel32.inc

includelib C:\masm32\lib\user32.lib
includelib C:\masm32\lib\kernel32.lib

.data
    szAppName db "Password Protected", 0
    szPrompt db "Enter Password:", 0
    szCorrectPassword db "password123", 0
    szInputPassword db 50 dup(0)
    szError db "Incorrect password!", 0
    szWelcome db "Access granted. Welcome!", 0

.code
start:
    invoke MessageBoxA, NULL, addr szPrompt, addr szAppName, MB_OKCANCEL
    cmp eax, IDCANCEL
    je end_program

    invoke lstrcmpA, addr szInputPassword, addr szCorrectPassword
    cmp eax, 0
    jne incorrect_password

    invoke MessageBoxA, NULL, addr szWelcome, addr szAppName, MB_OK
    jmp end_program

incorrect_password:
    invoke MessageBoxA, NULL, addr szError, addr szAppName, MB_OK

end_program:
    invoke ExitProcess, 0
end start

