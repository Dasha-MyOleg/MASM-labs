; 4-5-IM-24-Ivanova02.inc - ���� � ���������

; ������ ��� ��������� ������ � MessageBox
ShowMessage macro text
    invoke MessageBoxA, NULL, addr text, addr hidenWindowTitle, MB_OK
endm

; ������ ��� ���������� ������ �� ��������� XOR � ������ 0x5A
EncryptXOR macro password
    local loopStart
    mov esi, offset password
    mov ecx, 5  ; ������� ������
    
    loopStart:
        mov al, byte ptr [esi]
        xor al, 5Ah
        mov byte ptr [esi], al
        inc esi
        loop loopStart
endm

; ������ ��� ��������� ������������� ������ � ���������
ComparePasswords macro original, entered
    local cmpLoop, exitSuccess, exitFailure
    
    mov esi, offset original
    mov edi, offset entered

    cmpLoop:
        mov al, byte ptr [edi]
        mov bl, byte ptr [esi]

        .if al != bl
            ShowMessage badSecretText
            jmp exitFailure
        .endif

        .if al == 0
            jmp exitSuccess
        .endif

        inc esi
        inc edi
        jmp cmpLoop

    exitSuccess:
        call DisplayStudentData
        jmp done

    exitFailure:
        invoke ExitProcess, 0

    done:
endm
