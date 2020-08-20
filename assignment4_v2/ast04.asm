; *****************************************************************
;	name: Michael Dimitrov
;	assignment #04
;	section #1001

; -----
;  Assembly  program to compute a series of averages while 
;  iterating through an array. Uses arithmetic and jmp
;  commands for loops.

;Some answers Obtained. 
;Oddcnt: 58
;OddSum: 12446
;Fourcnt: 21
;FourSum: 7108
;Size: 100
;Min: -967
;Sum: 23568
;Avg: 235
;ect..


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

lst		dd	 367,  316,  542,  240,  677
		dd	 635,  426,  820,  146, -333
		dd	 317, -115,  226,  140,  565
		dd	 871,  614,  218,  313,  422	
		dd	-119,  215, -525, -712,  441
		dd	-622, -731, -729,  615,  724
		dd	 217, -224,  580,  147,  324
		dd	 425,  816,  262, -718,  192
		dd	-432,  235,  764, -615,  310
		dd	 765,  954, -967,  515,  556
		dd	 342,  321,  556,  727,  227
		dd	-927,  382,  465,  955,  435
		dd	-225, -419, -534, -145,  467
		dd	 315,  961,  335,  856,  553
  		dd	-032,  835,  464,  915, -810
		dd	 465,  554, -267,  615,  656
		dd	 192, -825,  925,  312,  725
		dd	-517,  498, -677,  475,  234
		dd	 223,  883, -173,  350,  415
		dd	 335,  125,  218,  713,  025
len		dd	100

lstMin		dd	0
lstMid		dd	0
lstMax		dd	0
lstSum		dd	0
lstAve		dd	0

oddCnt		dd	0
oddSum		dd	0
oddAve		dd	0

fourCnt		dd	0
fourSum		dd	0
fourAve		dd	0
fourInt     dd  0
fourRem     dd  0

numTwo      dd  2

; *****************************************************************

section	.text
global _start
_start:

;*******************************CODE*******************************

;Set up variables for loop
mov ecx, dword[len] 			;length(100) in bx.
mov rsi, 0						;index = 0, i

;Sum/Min/Max Loop ----

;SUMMATION / MAX / MIN LOOP---
;------------------------------------------------
sumLoop:
mov eax, dword[lst+(rsi*4)]		;lst[i]

cmp eax, dword[lstMax]			;Update MAX
jle updateMax					;compare if <op1> <= <op2>
mov dword[lstMax], eax
updateMax:

cmp eax, dword[lstMin]			;Update MIN
jge updateMin					;compare
mov dword[lstMin], eax
updateMin:

add dword[lstSum], eax			;Update SUM
inc rsi							;i++
loop sumLoop
;------------------------------------------------

;Compute Average---
mov eax, dword[lstSum]
cdq
idiv dword[len]
mov dword[lstAve], eax

;Find mid
mov rsi, 49
mov eax, dword[lst+(rsi*4)] ;Place middle val 
mov dword[lstMid], eax

mov rsi, 50
mov eax, dword[lst+(rsi*4)]
add eax, dword[lstMid]
cdq
idiv dword[numTwo] 
mov dword[lstMid], eax


;Set up Variables for next Loop---
mov ecx, dword[len] 			;length(100) in bx.
mov rsi, 0						;reset index = 0

;FOUR LOOP---
;------------------------------------------------
fourLoop:
mov eax, dword[lst+(rsi*4)]

;divide eax by ebx(4), if remainder is '0'
;it is divisible
 cdq							; eax -> edx:eax
 mov ebx, 4
 idiv ebx
 mov dword[fourInt], eax
 mov dword[fourRem], edx

;If number is divisible by 4.

 cmp edx, 0						;Is edx(remainder) == '0'
 jne isDivisible				;Not je?? Is it reversed?..
 inc dword[fourCnt]			    ;fourCnt++
 mov eax, dword[lst+(rsi*4)]	;set eax back to the original arr element
 add dword[fourSum], eax		;Sum four             
 isDivisible:

inc rsi							;i++
loop fourLoop
;------------------------------------------------

;Compute Four Average---
mov eax, dword[fourSum]
cdq
idiv dword[fourCnt]
mov dword[fourAve], eax



;Set up variables for loop
mov ecx, dword[len] 			;length(100) in bx.
mov rsi, 0						;index = 0, i

;Odd Loop ----
;------------------------------------------------
oddLoop:
mov eax, dword[lst+(rsi*4)]		;lst[i]

;divide eax by ebx(2), if remainder is '0'
;it is even
 cdq							; eax -> edx:eax
 mov ebx, 2
 idiv ebx
 mov dword[fourInt], eax
 mov dword[fourRem], edx

;If not divisible by 2 (odd!)
cmp edx, 0
je isOdd                       ;If rem % 2 != 0...not jne??
inc dword[oddCnt]              ;Inc odd since not div by 2
mov ebx, dword[lst+(rsi*4)]    ;Place odd into ebx
add dword[oddSum], ebx         ;Sub odd nums
isOdd:

inc rsi                         ;i++
loop oddLoop
;------------------------------------------------

;Compute Odd Average---
mov eax, dword[oddSum]
cdq
idiv dword[oddCnt]
mov dword[oddAve], eax


; *****************************************************************
;	Done, terminate program.

last:
	mov	rax, SYS_exit		; call call for exit (SYS_exit)
	mov	rbx, EXIT_SUCCESS	; return code of 0 (no error)
	syscall