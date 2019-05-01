;/************************************************************************
;**  Program Name:   Calculator ASM			      						**
;**  Version Number: V1.0                                     			**
;**  Copyright (C):  September 6, 2010  Richard W. Allen	   			**
;**  Date Started:   September 1, 2010	                      			**
;**  Date Ended:     September 6, 2010    	             				**
;**  Author:         Richard W. Allen                         			**
;**  Webpage:        http://www.richardallenonline.com					**
;**  IDE:            RadASM 3.0.0.7					         			**
;**  Compiler:		 JWASM	2.03			      						**
;**  Langage:        MASM					     						**
;**  License:	     GNU GENERAL PUBLIC LICENSE Version 2				**
;**					 see license.txt for for details	      			**
;*************************************************************************/
.386
.model flat, stdcall
option casemap:none

include Inc\CalculatorASM.inc

.code

start:

	invoke GetModuleHandle, NULL
	mov hInstance, eax
	;invoke GetCommandLine
	invoke InitCommonControls
	;mov CommandLine, eax
	invoke WinMain, hInstance, NULL, NULL, SW_SHOWDEFAULT
	invoke ExitProcess, eax
	
WinMain proc hInst:HINSTANCE, hPrevInst:HINSTANCE, CmdLine:LPSTR, CmdShow:DWord
	LOCAL wc:WNDCLASSEX
	LOCAL msg:MSG
	
	mov wc.cbSize, sizeof WNDCLASSEX
	mov wc.style, CS_HREDRAW or CS_VREDRAW
	mov wc.lpfnWndProc, offset WndProc
	mov wc.cbClsExtra, NULL
	mov wc.cbWndExtra, DLGWINDOWEXTRA
	
	push hInst
	pop wc.hInstance
	
	mov wc.hbrBackground, COLOR_BTNFACE + 1
	mov wc.lpszMenuName, IDR_MENU
	mov wc.lpszClassName, offset ClassName
	
	invoke LoadIcon, NULL, IDI_APPLICATION
	
	mov wc.hIcon, eax
	mov wc.hIconSm, eax
	
	invoke LoadCursor, NULL, IDC_ARROW
	
	mov wc.hCursor, eax
	
	invoke RegisterClassEx, addr wc
	invoke CreateDialogParam, hInstance, IDD_DLG1, NULL, addr WndProc, NULL
	invoke ShowWindow, hWnd, SW_SHOWNORMAL
	invoke UpdateWindow, hWnd
	.while TRUE
		invoke GetMessage, addr msg, NULL, 0, 0
		.break .if !eax
		invoke TranslateMessage, addr msg
		invoke DispatchMessage, addr msg
	.endw
	mov eax, msg.wParam
	ret

WinMain endp

AboutDlgProc proc hWin:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	
	mov	eax,uMsg
	.if eax==WM_INITDIALOG
		m2m hAbout, hWin
		invoke SetDlgItemText, hAbout, IDC_STC5, addr AppName
		invoke SetDlgItemText, hAbout, IDC_STC6, addr Verison
		invoke SetDlgItemText, hAbout, IDC_STC7, addr Details
		invoke SetDlgItemText, hAbout, IDC_STC8, addr Company
		
	.elseif eax==WM_COMMAND
		
	.elseif eax==WM_CLOSE
		mov	hAbout, NULL
		invoke EndDialog, hWin, NULL
	.else
		mov eax, FALSE
		ret
	.endif
	mov eax, TRUE
	
	ret

AboutDlgProc endp

WndProc proc hWin:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	
	mov eax, uMsg
	.if eax == WM_INITDIALOG
		invoke ClearRegister
		invoke ClearFPU
		m2m hWnd, hWin
		invoke ClearText
	.elseif eax == WM_COMMAND
		mov eax, wParam
		and eax, 0FFFFh
		mov ebx, wParam
		ror ebx, 16
		.if eax == IDM_FILE_EXIT
			invoke SendMessage, hWin, WM_CLOSE, 0, 0
		.elseif eax == IDM_HELP_ABOUT
			;invoke ShellAbout, hWin, addr AppName, addr Details, NULL
			invoke CreateDialogParam, hInstance, IDD_DLG2, hWin, addr AboutDlgProc, FALSE
		;=====================
		;	Number Buttons
		;=====================
		.elseif eax == IDC_BTN0
			.if bx == BN_CLICKED
				invoke AddText, '0'
			.endif
		.elseif eax == IDC_BTN1
			.if bx == BN_CLICKED
				invoke AddText, '1'
			.endif
		.elseif eax == IDC_BTN2
			.if bx == BN_CLICKED
				invoke AddText, '2'
			.endif
		.elseif eax == IDC_BTN3
			.if bx == BN_CLICKED
				invoke AddText, '3'
			.endif
		.elseif eax == IDC_BTN4
			.if bx == BN_CLICKED
				invoke AddText, '4'
			.endif
		.elseif eax == IDC_BTN5
			.if bx == BN_CLICKED
				invoke AddText, '5'
			.endif
		.elseif eax == IDC_BTN6
			.if bx == BN_CLICKED
				invoke AddText, '6'
			.endif
		.elseif eax == IDC_BTN7
			.if bx == BN_CLICKED
				invoke AddText, '7'
			.endif
		.elseif eax == IDC_BTN8
			.if bx == BN_CLICKED
				invoke AddText, '8'
			.endif
		.elseif eax == IDC_BTN9
			.if bx == BN_CLICKED
				invoke AddText, '9'
			.endif
		;=====================
		;	Operator Buttons
		;=====================
		.elseif eax == IDC_BTNDIV
			.if bx == BN_CLICKED
				invoke Operator, eDivide
			.endif
		.elseif eax == IDC_BTNMUL
			.if bx == BN_CLICKED
				invoke Operator, eMultiply
			.endif
		.elseif eax == IDC_BTNSUB
			.if bx == BN_CLICKED
				invoke Operator, eSubtract
			.endif
		.elseif eax == IDC_BTNADD
			.if bx == BN_CLICKED
				invoke Operator, eAdd
			.endif
		.elseif eax == IDC_BTNPER
			.if bx == BN_CLICKED
				.if period == FALSE
					invoke AddText, '.'
					mov period, TRUE
				.endif
			.endif
		.elseif eax == IDC_BTNNAG
			.if bx == BN_CLICKED
				invoke NagText
			.endif
		.elseif eax == IDC_BTNCLR
			.if bx == BN_CLICKED
				invoke ClearText
				finit
				fldz
				fstp rMem10
				mov sign, eNone
			.endif
		.elseif eax == IDC_BTNEQU
			.if bx == BN_CLICKED
				invoke Operator, sign
				invoke RemoveExZero
				invoke SetBox, addr sTemp
				Mov sign, eEquals
			.endif
		.endif
	.elseif eax == WM_CLOSE
		invoke DestroyWindow, hWin
	.elseif uMsg == WM_DESTROY
		invoke PostQuitMessage, NULL
	.else
		invoke DefWindowProc, hWin, uMsg, wParam, lParam
		ret
	.endif
	xor eax, eax
	ret

WndProc endp

AddText proc sNum:Byte

	.if nPosition < 100
		mov ecx, nPosition
		mov al, sNum
		mov [sDisplay + ecx], al

		inc nPosition
		
		invoke SetBox, addr sDisplay		
	.endif

	ret
AddText endp

ClearFPU proc
	finit
	
	FFREE st(0)
	FFREE st(1)
	FFREE st(2)
	FFREE st(3)
	FFREE st(4)
	FFREE st(5)
	FFREE st(6)
	FFREE st(7)
	
	ret

ClearFPU endp

ClearRegister proc
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	ret
ClearRegister endp

ClearText proc
	
	mov period, FALSE

	mov al, 0
	.while nPosition > 0
		mov ecx, nPosition
		mov [sDisplay + ecx], al

		dec nPosition
	.endw
	
	mov sDisplay, al

	invoke AddText, ' '
	
	ret
ClearText endp

NagText proc
	
	.if sDisplay == ' '
		mov sDisplay, '-'
	.else
		mov sDisplay, ' '
	.endif

	invoke SetBox, addr sDisplay
	
	ret
NagText endp

Operator proc eType:Byte
	.if sign != eEquals
		finit
		invoke FpuAtoFL, addr sDisplay, 0, DEST_FPU
		.if sign == eNone
			fstp rMem10
		.endif
		;.elseif
		.if sign != eNone
			fld rMem10
			.if eType == eAdd
				fadd st(0), st(1)
			.elseif eType == eSubtract
				fsub st(0), st(1)
			.elseif eType == eMultiply
				fmul st(0), st(1)
			.elseif eType == eDivide
				fdiv st(0), st(1)
			.endif
			invoke FpuFLtoA, 0, 10, addr sTemp, SRC1_FPU or SRC2_DIMM
			fstp rMem10
		.endif
	.endif

	invoke ClearText

	mov al, eType
	mov sign, al

	ret
Operator endp

RemoveExZero proc
	
	mov ecx, 0
	
	mov eax, [sTemp + ecx]
	
	;Finds the end of the string
	.while al != 0
		inc ecx
		mov eax, [sTemp + ecx]
	.endw

	;Need to decroment to the char before the null
	dec ecx

	;Puts the last char into eax
	mov eax, [sTemp + ecx]

	;If al has a zero in it we change it to a null
	.while al == '0'
		mov [sTemp + ecx], 0		;Puts a null over the zero
		dec ecx						;Decroment to the next char
		mov eax, [sTemp + ecx]		;Moves the next char into eax
		.if al == '.'				;Check to see if the next char is a period
			mov [sTemp + ecx], 0	;If it is change to a null ie there is no number after the period
		.endif
	.endw
	
	ret
	
RemoveExZero endp

SetBox proc sTx:DWord
	
	invoke SetDlgItemText, hWnd, IDC_EDT1, sTx
	ret
SetBox endp

end start