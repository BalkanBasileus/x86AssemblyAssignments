; *****************************************************************
;  Must include:
;	name: Michael Dimitrov
;	assignment #05
;	section #1003

; -----
;PROGRAM DESCRIPTION:
;
;Write a simple assembly language program to calculate some
;geometric information for a series of isosceles triangular prisms.
;Specifically, the program should find the surface areas and
;volume for each isosceles triangular prism in a set of isosceles
;triangular prisms. Once the values are computed, the program
;should find the minimum, maximum, middle value, sum, and
;average for the surface areas and volumes.

;Purpose:
;Learn to use assembly language arithmetic instructions, control instructions,
;compare instructions, and conditional jump instructions.


; *****************************************************************

section	.data

; -----
;  Define standard constants.

NULL		equ	0			; end of string

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; successful operation
SYS_exit	equ	60			; call code for terminate

; -----
;  Provided Data Declerations

bases	db	  10,   14,   13,   37,   54,  31,   13,   20,   61,   36
		db	  14,   53,   44,   19,   42,  27,   41,   53,   62,   10
		db	  19,   28,   14,   10,   15,  15,   11,   22,   33,   70
		db	  18,   17,   10,   27,   15,  12,   53,   20,   39,   25
		db	  15,   23,   15,   63,   26,  24,   33,   10,   61,   15
		db	  14,   34,   13,   71,   81,  38,   73,   29,   17,   93

heights	dw	 113,  114,  113,  121,  125,  134,  144,  156,  122, 159
		dw	 147,  122,  135,  194,  143,  146,  117,  127,  166, 136
		dw	 126,  123,  128,  186,  164,  155,  136,  155,  155, 154
		dw	 124,  127,  122,  136,  134,  133,  141,  138,  144, 114
		dw	 123,  124,  121,  111,  124,  111,  154,  119,  113, 123
		dw	 126,  123,  128,  186,  136,  125,  139,  163,  168, 134

slants	dw	 133,  124,  173,  131,  115,  164,  173,  174,  123, 156
		dw	 144,  152,  131,  142,  156,  115,  124,  136,  175, 146
		dw	 113,  123,  153,  167,  135,  114,  129,  164,  167, 134
		dw	 116,  113,  164,  153,  165,  126,  112,  157,  167, 134
		dw	 126,  123,  128,  186,  135,  114,  129,  164,  167, 134
		dw	 117,  114,  117,  125,  153,  123,  173,  115,  106, 113

lengths	dd	1145, 1135, 1123, 1123, 1123, 1254, 1454, 1152, 1164, 1542
		dd	1353, 1457, 1182, 1142, 1354, 1364, 1134, 1154, 1344, 1142
		dd	1173, 1543, 1151, 1352, 1434, 1355, 1037, 1123, 1024, 1453
		dd	1353, 1457, 1182, 1142, 1354, 1364, 1134, 1154, 1344, 1142
		dd	1134, 2134, 1156, 1134, 1142, 1267, 1104, 1134, 1246, 1123
		dd	1235, 1263, 1267, 1273, 1225, 1233, 1237, 1244, 1221, 2233

length		dd	60

sAreaMin	dd	0
sAreaEstMed	dd	0
sAreaMax	dd	0
sAreaSum	dd	0
sAreaAve	dd	0

volMin		dd	0
volEstMed	dd	0
volMax		dd	0
volSum		dd	0
volAve		dd	0

; -----
;  Additional variables (if any)

ddTwo		dd  2


; --------------------------------------------------------------
; Uninitialized data

section	.bss

saAreas		resd	60
volumes		resd	60
tmp			resd	0


; *****************************************************************

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

;VOLUME---
;volumes(n) = ( bases[i] * heights[i] ) / 2(ddTwo)

movzx eax, byte [bases+rsi]
mul word[heights+rsi*2]
div dword [ddTwo]
	;mov dword[volumes], eax		;Debug statement
mov dword [volumes+rsi*4], eax

inc rsi									;i++
loop volLoop
;-------------------------------------------------------------------


;----
;Calculate Surface Area

mov ecx, dword[length]
mov rsi, 0
;-------------------------------------------------------------------
calcLoop:

;SURFACE AREA---
;saAreas[i] = (bases[i] × heights[i]) + (2 × lengths[i] × slants[i]) + (lengths[i] × bases[i])

movzx r8d, byte [bases+rsi]
movzx r9d, word[heights+rsi*2]
mov eax, r8d
mul r9d									;eax = bases[i] × heights[i]

mov dword[tmp], eax				;placeholder for eax.

movzx r9d, word[lengths+rsi*4]			;(lengths x 2)
mov eax, r9d
mul dword[ddTwo]							

movzx r9d, word[slants+rsi*2]			; x slants[i]
mul r9d

add dword[tmp], eax				;bases[i] × heights[i] + (lengths x 2)	
										;placeholder.

;mov eax, dword[saAreas]				;place back into eax, continue calc.

movzx r8d, byte[bases+rsi]
movzx r9d, word[lengths+rsi*4]

mov eax, r8d							;(lengths[i] x bases[i])
mul r9d

add dword[tmp], eax					; + (lengths[i] x bases[i]) placeholder.
mov eax, dword[tmp]					;place back into eax, continue calc.

	;mov dword[tmp], eax			;debug statement


mov dword[saAreas+rsi*4], eax			;place into saAreas and move on. CHECK!

inc rsi									;i++
loop calcLoop
;----------------------------------------------------------------------

; -----
; Find min, max, sum, and average for the total
; areas and volumes.

mov eax, dword [saAreas]
mov dword [sAreaMin], eax
mov dword [sAreaMax], eax

mov eax, dword [volumes]
mov dword [volMin], eax
mov dword [volMax], eax

mov dword [sAreaSum], 0
mov dword [volSum], 0

mov ecx, dword [length]
mov rsi, 0

;------------------------------------------------------------------
statLoop:

mov eax, dword [saAreas+rsi*4]
add dword [sAreaSum], eax

cmp eax, dword [sAreaMin]
jae notNewAreaMin
mov dword [sAreaMin], eax

notNewAreaMin:
cmp eax, dword[sAreaMax]
jbe notNewAreaMax
mov dword[sAreaMax], eax

notNewAreaMax:
mov eax, dword [volumes+rsi*4]
add dword [volSum], eax
cmp eax, dword [volMin]
jae notNewVolMin
mov dword [volMin], eax

notNewVolMin:
cmp eax, dword [volMax]
jbe notNewVolMax
mov dword [volMax], eax
notNewVolMax:

inc rsi									;i++
loop statLoop
;------------------------------------------------------------------

; -----
; Calculate averages.

mov eax, dword[sAreaSum]
mov edx, 0
div dword[length]
mov dword[sAreaAve], eax

mov eax, dword[volSum]
mov edx, 0
div dword[length]
mov dword[volAve], eax

; ----
; Estimated Medians
;saArea
mov rsi, 29							;rsi = 29
mov eax, dword [saAreas+rsi*4]
inc rsi								;rsi = 30
mov ebx, dword [saAreas+rsi*4]
mov edx, 0
add eax, ebx
div dword[ddTwo]
mov dword[sAreaEstMed], eax

;volume
mov rsi, 29							;rsi = 29
mov eax, dword [volumes+rsi*4]
inc rsi								;rsi = 30
mov ebx, dword [volumes+rsi*4]
mov edx, 0
add eax, ebx
div dword[ddTwo]
mov dword[volEstMed], eax




; *****************************************************************
;	Done, terminate program.

last:
	mov	rax, SYS_exit		; call call for exit (SYS_exit)
	mov	rbx, EXIT_SUCCESS	; return code of 0 (no error)
	syscall