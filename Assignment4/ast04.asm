; *****************************************************************
;  Must include:
;	name: Michael Dimitrov
;	assignment #04
;	section #1003

; -----
;  Write a simple assembly language program to compute a series
;  of averages while iterating through an array.

;  Focus on learning basic arithmetic operations
;  (add, subtract, multiply, and divide).
;  Ensure understanding of signed and unsigned operations.
;  Learn how to use jump commands and control commands.

; *****************************************************************
;  Data Declarations .

section	.data
; -----
;  Define standard constants.

NULL		equ	0			; end of string

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; successful operation
SYS_exit	equ	60			; call code for terminate

; -----
; Data Declarations

lst		dd	 4224, -1116,  1542,  1240,  1677
		dd	-1635,  2420,  1820,  1246,  -333 
		dd	 2315,  -215,  2726,  1140,  2565
		dd	 2871,  1614,  2418,  2513,  1422 
		dd	 -119,  1215, -1525,  -712,  1441
		dd	-3622,  -731, -1729,  1615,  2724 
		dd	 1217,  -224,  1580,  1147,  2324
		dd	 1425,  1816,  1262, -2718,  1192 
		dd	-1435,   235,  2764, -1615,  1310
		dd	 1765,  1954,  -967,  1515,  1556 
		dd	 1342,  7321,  1556,  2727,  1227
		dd	-1927,  1382,  1465,  3955,  1435 
		dd	 -225, -2419, -2534, -1345,  2467
		dd	 1615,  1959,  1335,  2856,  2553 
		dd	-1035,  1833,  1464,  1915, -1810
		dd	 1465,  1554,  -267,  1615,  1656 
		dd	 2192,  -825,  1925,  2312,  1725
		dd	-2517,  1498,  -677,  1475,  2034 
		dd	 1223,  1883, -1173,  1350,  2415
		dd	 -335,  1125,  1118,  1713,  3025

length		dd	100
increment 	dd  0
sevenInt 	dd 	0
sevenRem	dd  0

lstMin		dd	0
estMed		dd	0
lstMax		dd	0
lstSum		dd	0
lstAve		dd	0

negCnt		dd	0
negSum		dd	0
negAve		dd	0

sevenCnt	dd	0
sevenSum	dd	0
sevenAve	dd	0


; *****************************************************************

section	.text
global _start
_start:

;*******************************CODE*******************************

;Set up Variables for first Loop---

mov ebx, dword[increment]  		;inc for a4in.txt
mov ecx, dword[length] 			;length(100) in bx.
mov rsi, 0						;index = 0, i

;SUMMATION / MAX / MIN LOOP---
;------------------------------------------------
sumLoop:
mov eax, dword[lst+(rsi*4)]		;lst[i]

cmp eax, dword[lstMax]			;Update MAX*
jle updateMax					;compare if <op1> <= <op2>
mov dword[lstMax], eax
updateMax:

cmp eax, dword[lstMin]			;Update MIN*
jge updateMin					;compare
mov dword[lstMin], eax
updateMin:

add dword[lstSum], eax			;Update SUM*
inc dword[increment]			;inc increment for a4in.txt
inc rsi							;i++
loop sumLoop
;------------------------------------------------


;Compute Average---
mov eax, dword[lstSum]
cdq
idiv dword[length]
mov dword[lstAve], eax



;Set up Variables for next Loop---

mov dword[increment], 0			;reset i
mov ebx, dword[increment]  		;increment for debugger.
mov ecx, dword[length] 			;length(100) in bx.
mov rsi, 0						;reset index = 0

;NEGATIVE LOOP---
;------------------------------------------------
negativeLoop:
mov eax, dword[lst+(rsi*4)]		;lst[i]

cmp eax, 0						;Count negative elements
jg negativeCnt					;signed, if <op1> > <op2>
inc dword[negCnt]				;count
negativeCnt:


cmp eax, 0						;Add negative elements
jg negativeSum					;compre i < 0
add dword[negSum], eax			;add i to negSum
negativeSum:


inc dword[increment]			;inc increment for a4in.txt
inc rsi							;i++
loop negativeLoop
;------------------------------------------------


;Compute negative average---
mov eax, dword[negSum]
cdq
idiv dword[negCnt]
mov dword[negAve], eax




;Set up Variables for next Loop---

mov dword[increment], 0			;reset i
mov ebx, 0
mov ecx, dword[length] 			;length(100) in bx.
mov rsi, 0						;reset index = 0

;THE SEVEN LOOP---
;------------------------------------------------
theSevenLoop:
mov eax, dword[lst+(rsi*4)]		;lst[i]


;divide eax by ebx(7), if remainder is '0'
;it is divisible
 
 cdq							; eax -> edx:eax
 mov ebx, 7
 idiv ebx
 mov dword[sevenInt], eax
 mov dword[sevenRem], edx

;If number is divisible by 7.


 cmp edx, 0						;Is edx(remainder) == '0'
 jne isDivisible					
 inc dword[sevenCnt]			;sevenCnt++
 mov eax, dword[lst+(rsi*4)]	;set eax back to the original arr element
 add dword[sevenSum], eax		;Sum Seven
 isDivisible:


inc dword[increment]			;inc increment for a4in.txt
inc rsi							;i++
loop theSevenLoop
;------------------------------------------------



;Compute Seven Average---
mov eax, dword[sevenSum]
cdq
idiv dword[sevenCnt]
mov dword[sevenAve], eax


;Set up Variables for next Loop---



mov eax, dword[length] 			;length(100) in eax
sub eax, 50						;eax = 50
movsxd rsi, eax					;rsi = 50
mov dword[length], eax			;length = 50


mov eax, dword[lst+(rsi*4)]		;lst[50]
mov rsi, 0						;reset rsi to 0
;mov dword[estMed], eax
			
mov ebx, dword[length] 			;ebx = 50
sub ebx, 1						;ebx = 49
mov dword[length], ebx			;length = 49
movsxd rsi, ebx					;rsi = 49

mov ebx, dword[lst+(rsi*4)]		;ebx = lst[49]

 ;mov eax, ebx					;lst[49] + lst[50]
 ;mov dword[estMed], eax			;estMed = lst[49] + lst[50]
mov eax, ebx
 ;cdq
 ;idiv 2
mov dword[estMed], eax			;estMed = lst[49] + lst[50]
		


; *****************************************************************
;	Done, terminate program.

last:
	mov	rax, SYS_exit		; call call for exit (SYS_exit)
	mov	rbx, EXIT_SUCCESS	; return code of 0 (no error)
	syscall