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
include 	\jwasm\Win32Inc135\Include\Windows.inc
include		\jwasm\Win32Inc135\Include\Commctrl.inc

include \jwasm\Fpulib2_32\fpu.inc

includelib \jwasm\Fpulib2_32\fpu.lib

includelib	\jwasm\Win32Inc135\Lib\kernel32.lib
includelib	\jwasm\Win32Inc135\Lib\user32.lib
includelib	\jwasm\Win32Inc135\Lib\Comctl32.lib

; ----------------------------
; memory to memory assignment
; ----------------------------
m2m MACRO M1, M2
	push M2
	pop  M1
ENDM

WinMain			PROTO :DWord, :DWord, :DWord, :DWord
WndProc			PROTO :DWord, :DWord, :DWord, :DWord

AddText			PROTO :Byte
ClearFPU 		PROTO
ClearRegister	PROTO
ClearText		PROTO
NagText			PROTO
Operator		PROTO :Byte
RemoveExZero	PROTO
SetBox			PROTO :DWord

;=====================
;	Dialog IDs Main
;=====================
IDD_DLG1		equ		1100

;=====================
;	EditText IDs
;=====================
IDC_EDT1		equ		1200

;=====================
;	Button IDs
;=====================
IDC_BTN0		equ		1000
IDC_BTN1		equ		1001
IDC_BTN2		equ		1002
IDC_BTN3		equ		1003
IDC_BTN4		equ		1004
IDC_BTN5		equ		1005
IDC_BTN6		equ		1006
IDC_BTN7		equ		1007
IDC_BTN8		equ		1008
IDC_BTN9		equ		1009

IDC_BTNDIV		equ		1010
IDC_BTNMUL		equ		1011
IDC_BTNSUB		equ		1012
IDC_BTNADD		equ		1013

IDC_BTNPER		equ		1014
IDC_BTNNAG		equ		1015

IDC_BTNCLR		equ		1016
IDC_BTNEQU		equ		1017

;=====================
;	Menu IDs
;=====================
IDR_MENU		equ		10000
IDM_FILE_EXIT	equ		10002
IDM_HELP_ABOUT	equ		10004

;=====================
;	Dialog IDs About
;=====================
IDD_DLG2		equ		1000

;=====================
;	Static IDs
;=====================
IDC_STC5		equ		1005
IDC_STC6		equ		1006
IDC_STC7		equ		1007
IDC_STC8		equ		1008

;=====================
;	Enum Types
;=====================
eNone			equ 	0
eEquals 		equ 	1
eAdd 			equ 	2
eSubtract 		equ 	3
eMultiply 		equ 	4
eDivide 		equ 	5

.const

ClassName		Byte	'DLGCLASS', 0

AppName			Byte	'Calculator ASM', 0
Verison			Byte	'1.0.0.0', 0
Details			Byte	'Copyright © 2010, Richard W. Allen',13, 10, 'See license.txt', 0
Company			Byte	'See license.txt', 0

Zero			Real10 	0.0

.data

hWnd		HWND		NULL
hAbout		HWND		NULL

hInstance	HINSTANCE	NULL
CommandLine	LPSTR		NULL

hBox 		HANDLE		NULL

period		Byte		FALSE

rMem10		Real10		0.0

sign 		Byte		eNone
sDisplay	Byte		101		Dup(0)
nPosition 	DWord		0

;=====================
;	temp var
;=====================
sTemp 		DWord		0