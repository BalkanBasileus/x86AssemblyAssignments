;  CS 218
;  Assignment #7
;	name: Michael Dimitrov
;	assignment #07
;	section #1001

;PROGRAM DESCRIPTION:
;
;Impliment cocktailSort algorithm in Assimbly language.
;Use code from previous macro assignment to convert
;statistical info in base (3) and display.

; ===========================================================================
; Cocktail sort algorithm:

; function cocktailSort(list, list_length) {
;	bottom = 0
;	top = list_length - 1
;	swapped = true
;	while(swapped == true)		// if no elements have been
;						// swapped, then list is sorted
;	{
;		swapped = false
;		for(i = bottom; i < top; i = i + 1)
;		{
;		if(list[i] > list[i + 1])	// test iftwo elements are
;						// in the correct order
;		{
;		   swap(list[i], list[i + 1])	// let the two elements
;						// change places
;		   swapped = true
;		}
;	}
;						// decreases `top` because the
;						// element with the largest
;						// value in the
;					        // unsorted part of the list
;						// is now on the position top
;	top = top - 1;
;	for(i = top; i > bottom; i = i - 1)
;	{
;		if(list[i] < list[i - 1])
;		{
;		   swap(list[i], list[i - 1])
;		   swapped = true
;		}
;	}
; }

; ===========================================================================
;  Macro, int2ternary, to convert a signed base-10 integer into
;  an ASCII string representing the ternary value.

;  The macro stores the result into an ASCII string (STR_SIZE characters,
;  byte-size, right justified, blank filled, NULL terminated).
;  Each integer is a double word value.

;  Assumes valid/correct data.  As such, no error checking is performed.

;  NOTE, addresses are passed.  For example:
;	mov	eax, dword [%1], eax	-> gets 1st argument value
;	mov	rbx, %1 		-> copies 2nd argument address to rbx




;	CODE FROM ASST #6
%macro	int2ternary	2	; integer, string

mov dword[digitCnt], 0
mov eax, dword[%1]
mov rcx, 0

%%divideLoop:
	mov edx, 0
	cdq
	idiv dword[weight]	;weight = 3

	push rdx 			;divide by 3, get remainder
	inc rcx

	cmp eax, 0			;more division?
	;mov dword[ans0],eax
	jne %%divideLoop 

mov rbx, %2			;get addr of str
mov rdi, 0				;index = 0

%%popLoop:
	pop rax 			;pop intDigit
	add al, "0" 		;Char = int + "0"

	mov byte[rbx+rdi], al ;str[index] = char
	inc rdi
loop %%popLoop

mov byte[rbx+rdi], NULL	;str[idx] = NULL

%endmacro

; =====================================================================
;  Simple macro to display a string to the console.
;  Count characters (excluding NULL).
;  Display string starting at address <stringAddr>

;  Macro usage:
;	printString  <stringAddr>

;  Arguments:
;	%1 -> <stringAddr>, string address

%macro	printString	1
	push	rax			; save altered registers
	push	rdi
	push	rsi
	push	rdx
	push	rcx

	lea	rdi, [%1]		; get address
	mov	rdx, 0			; character count
%%countLoop:
	cmp	byte [rdi], NULL
	je	%%countLoopDone
	inc	rdi
	inc	rdx
	jmp	%%countLoop
%%countLoopDone:

	mov	rax, SYS_write		; system call for write (SYS_write)
	mov	rdi, STDOUT		; standard output
	lea	rsi, [%1]		; address of the string
	syscall				; call the kernel

	pop	rcx			; restore registers to original values
	pop	rdx
	pop	rsi
	pop	rdi
	pop	rax
%endmacro

; =====================================================================

section	.data

; -----
;  Define standard constants.

TRUE		equ	1
FALSE		equ	0

SUCCESS		equ	0			; successful operation
NOSUCCESS	equ	1			; unsuccessful operation

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; system call code for read
SYS_write	equ	1			; system call code for write
SYS_open	equ	2			; system call code for file open
SYS_close	equ	3			; system call code for file close
SYS_fork	equ	57			; system call code for fork
SYS_exit	equ	60			; system call code for terminate
SYS_creat	equ	85			; system call code for file open/create
SYS_time	equ	201			; system call code for get time

LF		equ	10
SPACE		equ	" "
NULL		equ	0
ESC		equ	27

; -----
;  Program specific constants.

STR_SIZE	equ	15

; -----
;  Provided Data

lst	dd	123,  42, 146,  76, 120,  56, 164,  65, 155,  57
	dd	111, 188,  33,  05,  27, 101, 115, 108,  13, 115
	dd	 17,  26, 129, 117, 107, 105, 109,  30, 150,  14
	dd	147, 123,  45,  40,  65,  11,  54,  28,  13,  22
	dd	 69,  26,  71, 147,  28,  27,  90, 177,  75,  14
	dd	181,  25,  15,  22,  17,  11,  10, 129,  12, 134
	dd	 61,  34, 151,  32,  12,  29, 114,  22,  13, 131
	dd	127,  64,  40, 172,  24, 125,  16,  62,   8,  92
	dd	111, 183, 133,  50,   2,  19,  15,  18, 113,  15
	dd	 29, 126,  62,  17, 127,  77,  89,  79,  75,  14
	dd	114,  25,  84,  43,  76, 134,  26, 100,  56,  63
	dd	 24,  16,  17, 183,  12,  81, 320,  67,  59, 190
	dd	193, 132, 146, 186, 191, 186, 134, 125,  15,  76
	dd	 67, 183,   7, 114,  15,  11,  24, 128, 113, 112
	dd	 24,  16,  17, 183,  12, 121, 320,  40,  19,  90
	dd	135, 126, 122, 117, 127,  27,  19, 127, 125, 184
	dd	 97,  74, 190,   3,  24, 125, 116, 126,   4,  29
	dd	104, 124, 112, 143, 176,  34, 126, 112, 156, 103
	dd	 69,  26,  71, 147,  28,  27,  39, 177,  75,  14
	dd	153, 172, 146, 176, 170, 156, 164, 165, 155, 156
	dd	 94,  25,  84,  43,  76,  34,  26,  13,  56,  63
	dd	147, 153, 143, 140, 165, 191, 154, 168, 143, 162
	dd	 11,  83, 133,  50,  25,  21,  15,  88,  13,  15
	dd	169, 146, 162, 147, 157, 167, 169, 177, 175, 144
	dd	 27,  64,  30, 172,  24,  25,  16,  62,  28,  92
	dd	181, 155, 145, 132, 167, 185, 150, 149, 182,  34
	dd	 81,  25,  15,   9,  17,  25,  37, 129,  12, 134
	dd	177, 164, 160, 172, 184, 175, 166,  62, 158,  72
	dd	 61,  83, 133, 150, 135,  31, 185, 178, 197, 185
	dd	147, 123,  45,  40,  66,  11,  54,  28,  13,  22
	dd	 49,   6, 162, 167, 167, 177, 169, 177, 175, 164
	dd	161, 122, 151,  32,  70,  29,  14,  22,  13, 131
	dd	 84, 179, 117, 183, 190, 100, 112, 123, 122, 131
	dd	123,  42, 146,  76,  20,  56,  64,  66, 155,  57
	dd	 39, 126,  62,  41, 127,  77, 199,  79, 175,  14

len	dd	350

min	dd	0
med	dd	0
max	dd	0
sum	dd	0
avg	dd	0


; -----
;  Misc. variables.

bottom	dq	0
top	dq	0
i	dq	0
swapped	db	FALSE

tmp	dd	0
digitCnt dd 0
two	dd	2
weight	dd	3

;My Additional Variables
theTop 		dd 0
theBottom 	dd 0
debug 	dd 0
; -----
;  String definitions

newLine		db	LF, NULL

hdr		db	"**********************************"
		db	LF, "CS 218 - Assignment #7", LF
		db	LF, "List Statistics:"
		db	LF, LF, NULL

lstMin		db	"List Minimum: ", NULL
lstMed		db	"List Median:  ", NULL
lstMax		db	"List Maximum: ", NULL
lstSum		db	"List Sum:     ", NULL
lstAve		db	"List Average: ", NULL

; -----

section	.bss
tempString	resb	33


; =====================================================================

section	.text
global	_start
_start:
push	rbp
mov		rbp, rsp

; ******************************
;  Sort data using cocktail sort.
; -----

;	YOUR CODE GOES HERE...
mov rsi, 0					;i
mov rcx, qword[len]			;get length value	
mov qword[bottom], 0		;bottom = 0
mov rax, qword[len]
dec rax
mov qword[top], rax			;top = len-1
mov dword[swapped], 0		;swapped = true, 0=true 
mov rax, 0 					;reset eax

;------------------------------------------------------------
cocktailSort:
cmp dword[swapped], 0 ;if swapped = true(0)
je ifSwappedTrue

cmp dword[swapped], 1 ;if swapped = false(0)
je ifSwappedFalse


mov rax, qword[top]
cmp rax, qword[bottom]
jne cocktailSort

jmp exit
;------------------------------------------------------------

;for(i = bottom; i < top; i = i + 1)
;------------------------------------------------------------
ifSwappedTrue:
	mov dword[swapped], 1 		;swapped = false(1)
	mov rsi, qword[bottom]		;i = bottom
	mov r8, qword[bottom]		;i+1
	inc r8						;rbx = i+1
	;;mov qword[bottom], rbx		;bottom++	
	mov rcx, qword[top] 		;i < top, rcx = len(top)

firstForLoop:
;inc dword[debug]
	mov eax, dword[lst+rsi*4] 	;eax = lst[i]
	mov ebx, dword[lst+r8*4]	;lst[i+1]
	cmp eax, dword[lst+r8*4]	;if(list[i] > list[i + 1])
	ja swapFirstForLoop
	backInLoop:

	;if i ever hits top, sorting is done..
	cmp rsi, qword[top] ;to prevent segfault. 
	je exit				;terminate prog.

	inc rsi		;i++
	inc r8	    ;(i+1)++ len set to 349 to prevent segfault.
loop firstForLoop


;When finished lets go back to beginning of program
jmp cocktailSort

;------------------------------------------------------------
;top = top - 1;
;	for(i = top; i > bottom; i = i - 1)
;------------------------------------------------------------
ifSwappedFalse:
	;mov dword[swapped], 1 		;swapped = false(1)
	dec qword[top]				;top = top - 1;
	mov rsi, qword[top]			;i = top
	mov r8, qword[top]			
	dec r8						;r8d = i-1 
	mov rcx, qword[top] 	;i > bottom, rcx = len(350)
;inc dword[debug]
secondForLoop:
;inc dword[debug]
	mov eax, dword[lst+rsi*4] 	;eax = lst[i]
	mov ebx, dword[lst+r8*4]	;ebx = lst[i+1]
	cmp eax, dword[lst+r8*4]	;if(list[i] < list[i - 1])
	jb swapSecondForLoop
	backInSecondLoop:

	dec rsi		;i--
	dec r8	    ;(i-1)-- len set to 349 to prevent segfault.

dec rcx
cmp rcx,1		
jne secondForLoop 
					
jmp cocktailSort	;back to beginning of cocktail sort
;------------------------------------------------------------


;The Swap code for each forloop
;------------------------------------------------------------

;let the two elements change places
;swap(list[i], list[i + 1])
swapFirstForLoop:
	mov dword[tmp], eax 		;tmp = lst[i]
	mov dword[lst+rsi*4], ebx 	;lst[i] = lst[i+1]
	mov eax, dword[tmp]
	mov dword[lst+r8*4], eax 	;lst[i+1] = lst[i]
	mov dword[swapped], 0 		;swapped = true(0)
	jmp backInLoop				;Jmp back into 


;let the two elements change places
;swap(list[i], list[i - 1])
swapSecondForLoop:
	mov dword[tmp], eax 		;tmp = lst[i-1]
	mov dword[lst+rsi*4], ebx 	;lst[i] = lst[i-1]
	mov eax, dword[tmp]
	mov dword[lst+r8*4], eax 	;lst[i-1] = lst[i]
	mov dword[swapped], 0 		;swapped = true(0)
	jmp ifSwappedTrue				;Jmp back into 
;------------------------------------------------------------


;Lets get out of here!
exit:
mov eax, dword[two]
mov dword[lst], eax
inc eax
mov dword[lst+4], eax

;Statistics -----
;----------------------
  mov rsi,0
  mov dword[sum], 0
  mov eax, dword[lst+rsi*4]
  mov rcx, 350
	;mov dword[debug], 0
;Sum------------------
 obtainSum:

  mov eax, dword[lst+rsi*4]
  add dword[sum], eax
  ;inc dword[debug]
  inc rsi			;i++
 loop obtainSum
;----------------------

;Calculate Average ----

 mov eax, dword[sum]
 mov edx, 0
 div dword[len]			;Average= (Sum / Length)
 mov dword[avg], eax

;Minimum ----
 mov eax, dword[lst]		
 mov dword[min], eax	;min = first element in array

;Maximum ----
 mov r8d, dword[len]
 dec r8d					;len-1
 mov eax, dword[lst+r8d*4]
 mov dword[max], eax	;max = array[299], last element.

 ;Calculate Median ----
 mov r8d, 174
 mov eax, dword[lst+r8d*4]   ;eax = Array[174]
 mov r8d, 175
 mov ebx, dword[lst+r8d*4]   ;ebx = Array[175]
 add eax, ebx				 ;eax = (eax + ebx) , Array[149] + Array[150]
 mov edx, 0
 mov ebx, dword[two]		 ;ebx = 2
 div ebx					 ;eax = (eax / 2)
 mov dword[med], eax		 ;median = eax


; -----
;  Output results to console.
;	Convert each result into a string
;	Display header and then ASCII/binary string

	printString	hdr

	printString	lstMin
	int2ternary	min, tempString
	printString	tempString
	printString	newLine

	printString	lstMed
	int2ternary	med, tempString
	printString	tempString
	printString	newLine

	printString	lstMax
	int2ternary	max, tempString
	printString	tempString
	printString	newLine

	printString	lstSum
	int2ternary	sum, tempString
	printString	tempString
	printString	newLine

	printString	lstAve
	int2ternary	avg, tempString
	printString	tempString
	printString	newLine

	printString	newLine


; *****************************************************************
;  Done, terminate program.

last:
	mov	rax, SYS_exit
	mov	rbx, SUCCESS
	syscall

