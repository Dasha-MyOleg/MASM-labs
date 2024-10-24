.386
.model flat, stdcall
option casemap:none

extrn MessageBoxA:PROC
extrn ExitProcess:PROC

.data
    message db 'Hello, World!', 0
    caption db 'Greeting', 0

.code
main PROC
    invoke MessageBoxA, NULL, addr message, addr caption, MB_OK
    invoke ExitProcess, 0
main ENDP

END main
