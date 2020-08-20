; *****************************************************************
;  Must include:
;	name: Michael Dimitrov
;	assignment #05
;	section #1001

; -----
;PROGRAM DESCRIPTION:
;
;Write a simple assembly language program to calculate some
;geometric information for a series of rectangular parallelepipeds.
;Specifically, the program should find the surface areas and
;volume for each rectangular parallelepiped in a set of rectangular 
;parallelepipeds. Once the values are computed, the program
;should find the minimum, maximum, middle value, sum, and
;average for the surface areas and volumes.

;Purpose:
;Learn to use assembly language arithmetic instructions, control instructions,
;compare instructions, and conditional jump instructions.

; *****************************************************************

section	.data

; -----
;  Define constants

NULL		equ	0			; end of string

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; successful operation
SYS_exit	equ	60			; call code for terminate

; -----
;  Provided Data Set

aSides		db	   10,    14,    13,    37,    54
		db	   31,    13,    20,    61,    36
		db	   14,    53,    44,    19,    42
		db	   27,    41,    53,    62,    10
		db	    9,     8,     4,    10,    15
		db	    5,    11,    22,    33,    70
		db	   15,    23,    15,    63,    26
		db	   24,    33,    10,    61,    15
		db	   14,    34,    13,    71,    81
		db	   38,    73,    29,    17,    93

bSides		dw	  133,   114,   173,   131,   115
		dw	  164,   173,   174,   123,   156
		dw	  144,   152,   131,   142,   156
		dw	  115,   124,   136,   175,   146
		dw	  113,   123,   153,   167,   135
		dw	  114,   129,   164,   167,   134
		dw	  116,   113,   164,   153,   165
		dw	  126,   112,   157,   167,   134
		dw	  117,   114,   117,   125,   153
		dw	  123,   173,   115,   106,    13

cSides		dd	 1145,  1135,  1123,  1123,  1123
		dd	 1254,  1454,  1152,  1164,  1542
		dd	 1353,  1457,   182,  1142,  1354
		dd	 1364,  1134,  1154,  1344,   142
		dd	 1173,  1543,  1151,  1352,  1434
		dd	 1355,  1037,   123,  1024,  1453
		dd	 1134,  2134,  1156,  1134,  1142
		dd	 1267,  1104,  1134,  1246,   123
		dd	 1134,  1161,  1176,  1157,  1142
		dd	 1153,  1193,  1184,   142,  2034

length		dd	50

vMin		dd	0
vMid		dd	0
vMax		dd	0
vSum		dd	0
vAve		dd	0

saMin		dd	0
saMid		dd	0
saMax		dd	0
saSum		dd	0
saAve		dd	0

; -----
; Additional variables (if any)
ddTwo			dd	2


; --------------------------------------------------------------
; Uninitialized data

section	.bss

volumes		    resd	50
surfaceAreas	resd	50
tmp				resd	 0

;*****************************************************************

section	.text
global _start
_start:

;*******************************CODE*******************************

;----
;Calculate Volume
mov ecx, dword[length]
mov rsi, 0
;-------------------------------------------------------------------
volLoop:

;VOLUME--- b x w x h
;volumes(n) = ( aSides[i] * bSides[i] * cSides[i] ) 

movzx r8d, byte [aSides+rsi]
movzx r9d, word [bSides+rsi*2]
mov eax, r8d
mul r9d 
mov r8d, dword [cSides+rsi*4]
mul r8d

mov dword[volumes+rsi*4], eax

inc rsi									;i++
loop volLoop
;-------------------------------------------------------------------


;----
;Calculate Surface Area
mov ecx, dword[length]
mov rsi, 0
;-------------------------------------------------------------------
saLoop:
;surfaceAreas[i] = 2 * ( (aSide*bSides) + (aSides*cSides) + (bSides*cSides) )

;eax = aSides[i] × bSides[i]
movzx r8d, byte [aSides+rsi]
movzx r9d, word[bSides+rsi*2]
mov eax, r8d
mul r9d					
mov dword[tmp], eax		;Temporarily store it

;eax = aSides[i] × cSides[i]
movzx r8d, byte [aSides+rsi]
mov r9d, dword[cSides+rsi*4]
mov eax, r8d
mul r9d					
add dword[tmp], eax		;Temporarily add it

;eax = bSides[i] × cSides[i]
movzx r8d, word [bSides+rsi*2]
mov r9d, dword[cSides+rsi*4]
mov eax, r8d
mul r9d					
add dword[tmp], eax		;Temporarily add it

mov eax, dword[tmp]
mul dword[ddTwo]
mov dword[surfaceAreas+rsi*4], eax

inc rsi 
loop saLoop
;-------------------------------------------------------------------


; -----
; Find min, max, sum, and average for the total
; areas and volumes.

mov eax, dword [surfaceAreas]
mov dword [saMin], eax
mov dword [saMax], eax

mov eax, dword [volumes]
mov dword [vMin], eax
mov dword [vMax], eax

mov dword [saSum], 0
mov dword [vSum], 0

mov ecx, dword [length]
mov rsi, 0

;------------------------------------------------------------------
statLoop:

mov eax, dword [surfaceAreas+rsi*4]
add dword[saSum], eax

cmp eax, dword[saMin]
jae notNewAreaMin
mov dword[saMin], eax

notNewAreaMin:
cmp eax, dword[saMax]
jbe notNewAreaMax
mov dword[saMax], eax

notNewAreaMax:
mov eax, dword[volumes+rsi*4]
add dword[vSum], eax
cmp eax, dword[vMin]
jae notNewVolMin
mov dword[vMin], eax

notNewVolMin:
cmp eax, dword[vMax]
jbe notNewVolMax
mov dword[vMax], eax
notNewVolMax:

inc rsi									;i++
loop statLoop
;------------------------------------------------------------------

; -----
; Calculate averages.

mov eax, dword[saSum]
mov edx, 0
div dword[length]
mov dword[saAve], eax

mov eax, dword[vSum]
mov edx, 0
div dword[length]
mov dword[vAve], eax

; ----
; Estimated Medians

;volume
mov rsi, 24							;rsi = 24
mov eax, dword [volumes+rsi*4]
inc rsi								;rsi = 25
mov ebx, dword [volumes+rsi*4]
mov edx, 0
add eax, ebx
div dword[ddTwo]
mov dword[vMid], eax

;surface area
mov rsi, 24							;rsi = 24
mov eax, dword [surfaceAreas+rsi*4]
inc rsi								;rsi = 25
mov ebx, dword [surfaceAreas+rsi*4]
mov edx, 0
add eax, ebx
div dword[ddTwo]
mov dword[saMid], eax


; *****************************************************************
;	Done, terminate program.

last:
	mov	rax, SYS_exit		; call call for exit (SYS_exit)
	mov	rbx, SUCCESS	; return code of 0 (no error)
	syscall