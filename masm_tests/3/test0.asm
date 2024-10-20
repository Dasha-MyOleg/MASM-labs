
.386
.model flat, stdcall
option casemap :none

include \masm32\include\masm32rt.inc
includelib \masm32\lib\msvcrt.lib

.data?
    secretWordInput     db 10 dup (?)

.data
    hidenWindowText db "Student info", 0
    myInfo        db "Kovalenko Vladislav Yuriiovych", 13, 10, "20.09.2005", 13, 10, "5089", 0	
    badSecretTitle    db "Bad secret word", 0
    badSecretText    db "You ented bad secret word", 0
    secretWord       db "12345", 0

dialogHandler	PROTO :DWORD, :DWORD, :DWORD, :DWORD

.code	
main:    
	Dialog "Some text", "Arial", 15, \
        WS_OVERLAPPED or WS_SYSMENU or DS_CENTER, \   							
        4, 10, 10, 200, 150, 1024

	DlgStatic "Write a secret word", SS_CENTER, 50,  12, 100,  10, 100	
	DlgEdit   WS_BORDER, 10,  25, 180, 15, 5089		
	DlgButton "Go", WS_TABSTOP, 10,  55, 50,  15, IDOK 				
	DlgButton "Quit", WS_TABSTOP, 140, 55, 50,  15, IDCANCEL 	

	CallModalDialog 0, 0, dialogHandler, NULL


     checkOnEquality proc
            mov esi, offset secretWord
            mov edi, offset secretWordInput

            IsWordsEqual:
                
                mov al, byte ptr [edi]
                mov bl, byte ptr [esi]  
                
                .if al!=bl
                invoke MessageBox, 0, offset badSecretText, offset badSecretTitle, 0
		    invoke ExitProcess, 0 
                .endif

                .if al==0      
                invoke MessageBox, 0, offset myInfo, offset hidenWindowText, 0
		    invoke ExitProcess, 0
                .endif

                .if bl==0      
                invoke MessageBox, 0, offset myInfo, offset hidenWindowText, 0
		    invoke ExitProcess, 0
                .endif

                inc esi
                inc edi
                jmp IsWordsEqual

		return 0
	checkOnEquality endp

	dialogHandler proc hWnd:DWORD, uMsg:DWORD, wParam:DWORD, lParam:DWORD
            .if uMsg==WM_INITDIALOG
            jmp createDialogWindow

            .elseif uMsg==WM_CLOSE
		   invoke ExitProcess, 0

            .elseif uMsg==WM_COMMAND
               jmp handleOKorCANSEL

            .elseif uMsg==10
            mov eax,10
            .endif

		createDialogWindow:
			invoke GetWindowLong, hWnd, GWL_USERDATA
			return 0

		handleOKorCANSEL:
			.if wParam==IDOK
			invoke GetDlgItemText, hWnd, 5089, offset secretWordInput, 10
			call checkOnEquality
			return 0

			.elseif wParam==IDCANCEL
			invoke ExitProcess, 0
                  .endif
			return 0
			
	dialogHandler endp
end main