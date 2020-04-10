;  CS 218
;  Assignment #7
;	name: Michael Dimitrov
;	assignment #07
;	section #1003

;PROGRAM DESCRIPTION:
;  Sort a list of number using the selection sort algorithm.
;  Also finds the minimum, median, maximum, sum, and average of the list.

; **********************************************************************************
;  Selection Sort Algorithm:

;	begin
;		for i = 0 to len-1
;			small = arr(i)
;			index = i
;			for  j = i to len-1
;				if ( arr(j) < small ) then
;					small = arr(j)
;					index = j
;				end_if
;			end_for
;			arr(index) = arr(i)
;			arr(i) = small
;		end_for
;	end_begin

; **********************************************************************************

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
;  Program specific constants

LIMIT		equ	10000
STR_SIZE	equ	10
MAX_STR_SIZE	equ	10

; -----
;  Provided data

array		dd	 1413,  1232,  5146,  1176,  2120,  2356,  3164,  4565,  3155,  3157
		dd	 2759,  6326,   171,   547,  5628,  7527,  7569,  1177,  6785,  3514
		dd	 1001,   128,  1133,  9105,  3327,   101,  2115,  1108,    11,  2115
		dd	 1227,  1226,  5129,   117,   107,   105,  3109,  9999,  1150,  3414
		dd	 1107,  6103,  1245,  5440,  1465,  2311,   254,  4528,  1913,  6722
		dd	 4149,  2126,  5671,  7647,  4628,   327,  2390,  1177,  8275,  5614
		dd	 3121,   415,   615,   122,  7217,   421,   410,  1129,  812,   2134
		dd	 1221,  2234,  7151,   432,   114,  1629,  2114,   522,  2413,   131
		dd	 5639,   126,  1162,   441,   127,   877,   199,  5679,  1101,  3414
		dd	 2101,   133,  5133,  6450,  4532,  8619,   115,  1618,  9999,   115
		dd	 1219,  3116,   612,   217,   127,  6787,  4569,   679,  5675,  4314
		dd	 3104,  6825,  1184,  2143,  1176,   134,  5626,   100,  4566,  2346
		dd	 1214,  6786,  1617,   183,  3512,  7881,  8320,  3467,  3559,   190
		dd	  103,   112,    11,  9186,   191,   186,   134,  1125,  5675,  3476
		dd	 1100,    11,  1146,   100,   101,    51,  5616,  5662,  6328,  2342
		dd	  137,  2113,  3647,   114,   115,  6571,  7624,   128,   113,  3112
		dd	 1724,  6316,  4217,  2183,  4352,   121,   320,  4540,  5679,  1190
		dd	 9130,   116,  5122,   117,   127,  5677,   101,  3727,    10,  3184
		dd	 1897,  6374,  1190,     9,  1224,    10,   116,  8126,  6784,  2329
		dd	 2104,   124,  3112,   143,   176,  7534,  2126,  6112,   156,  1103
		dd	 1153,   172,  1146,  2176,   170,   156,   164,   165,   155,  5156
		dd	  894,  4325,   900,   143,   276,  5634,  7526,  3413,  7686,  7563
		dd	  511,  1383, 11133,  4150,   825,  5721,  5615,  4568,  6813,  1231
		dd	 9999,   146,  8162,   147,   157,   167,   169,   177,   175,  2144
		dd	 1527,  1344,  1130,  2172,  7224,  7525,   100,    11,  2100,  1134   
		dd	  181,   155,  2145,   132,   167,   185,  2150,  3149,   182,  1434
		dd	  177,    64, 11160,  4172,  3184,   175,   166,  6762,   158,  4572
		dd	 7561,  1283,  5133,   150,   135,  5631,  8185,   178,  1197,  1185
		dd	 5649,  6366,  3162,  5167,   167,  1177,   169,  1177,   175,  1169
		dd	 3684,  9999, 11217,  3183,  2190,  1100,  4611,  1123,  3122,   131

length		dq	300

minimum		dd	0
median		dd	0
maximum		dd	0
sum		dd	0
average		dd	0

; -----
;  Misc. data definitions (if any).

weight		dd	13
dtwo		dd	2
ddTen		dd	10

i		dq	0
j		dq	0
index		dq	0
small		dd	0

nonBuggyIndex	dq	0
; -----
;  Provided string definitions.

newline		db	LF, NULL

hdr		db	"CS 218 - Assignment #7"
		db	LF, LF, NULL

hdrMin		db	"Minimum: %10d", LF, NULL
hdrMax		db	"Maximum: %10d", LF, NULL
hdrMed		db	"Median:  %10d", LF, NULL
hdrSum		db	"Sum:     %10d", LF, NULL
hdrAve		db	"Average: %10d", LF, LF, NULL


; **********************************************************************************

section .bss

tempString	resb	STR_SIZE


; **********************************************************************************

extern	printf

section	.text
;global	_start
;_start:
global main
main:
	push	rbp
	mov	rbp, rsp

; ******************************
;  Sort data using selection sort.


;	YOUR CODE GOES HERE
  
  mov rsi, 0 			;i
  mov rcx, 0			;theILoop counter (and for Debugging)
  mov rdx, 0	 		;theJLoop counter (and for Debugging)
  mov r8,0
  mov r9, 0				;Variables
  mov r10,0
  mov r12, 0			;used for i, turned into Index
  mov r13, 0			;used for Index
  
  theILoop:						;I-Loop (i=0;i<len-1;i++)

    mov eax, dword[array + rsi*4] 	; Array[i]
    mov dword[small], eax			; small = Array[i]
    mov qword[i], rsi				; i counter
    mov qword[j], rsi				; j counter
    mov qword[nonBuggyIndex],rsi	; Index	
    mov rdx,0 	
    mov rdx, qword[j]				;r8
    
	theJLoop:						;J-Loop (j=i;j<len-1;j++)
	 
    mov ebx, dword[array+rdx*4]		;Index for comparison Array[j]
       
    cmp ebx, dword[small]			;if Array[j] < small
    jb smaller
    jmp backInnerLoop

	smaller:
    mov dword[small], ebx			;small = Array[j]
  	mov qword[nonBuggyIndex], rdx	;r8

    backInnerLoop:

    inc rdx   						;theJLoop counter++
	cmp rdx, qword[length]
	jb theJLoop 				


  mov r12, qword[i]					;r12 = i
  mov r13, qword[nonBuggyIndex]		;r13 = Index

  mov r10d, dword[array+r12*4]		;Array[Index] = Array[i]
  mov dword[array+r13*4], r10d
 
  mov r9d, dword[small]				;Array[i] = small	
  mov dword[array + r12*4], r9d
  inc rsi							;i++

  inc rcx				 			;theILoop counter++
  cmp rcx, qword[length]
  jb theILoop 


  
; ******************************
;  Find statistics
;	sum, average, min, max, and median.


;	YOUR CODE GOES HERE

;Set up Variables -----
;----------------------
  mov rsi,0
  mov eax, dword[array+rsi*4]

;----------------------
 obtainSum:

  mov eax, dword[array+rsi*4]
  add dword[sum], eax
  
  inc rsi			;i++
 loop obtainSum
;----------------------


;Calculate Average ----

 mov eax, dword[sum]
 mov edx, 0
 div dword[length]			;Average= (Sum / Length)
 mov dword[average], eax

;Minimum ----
 mov eax, dword[array]		;array[0] 
 mov dword[minimum], eax	;min = first element in array

;Maximum ----
 mov rsi,299
 mov eax, dword[array+rsi*4]
 mov dword[maximum], eax	;max = array[299], last element.

;Calculate Median ----
 mov rsi, 149
 mov eax, dword[array+rsi*4] ;eax = Array[149]
 mov rsi, 150
 mov ebx, dword[array+rsi*4] ;ebx = Array[150]
 add eax, ebx				 ;eax = (eax + ebx) , Array[149] + Array[150]
 mov edx, 0
 mov ebx, dword[dtwo]		 ;ebx = 2
 div ebx					 ;eax = (eax / 2)
 mov dword[median], eax		 ;median = eax

 
 



; ******************************
;  Display results to screen.

	mov	rdi, hdr
	mov	rax, 0
	call	printf

	mov	rdi, hdrMin
	mov	rsi, 0
	mov	esi, dword [minimum]
	mov	rax, 0
	call	printf

	mov	rdi, hdrMax
	mov	rsi, 0
	mov	esi, dword [maximum]
	mov	rax, 0
	call	printf

	mov	rdi, hdrMed
	mov	rsi, 0
	mov	esi, dword [median]
	mov	rax, 0
	call	printf

	mov	rdi, hdrSum
	mov	rsi, 0
	mov	esi, dword [sum]
	mov	rax, 0
	call	printf

	mov	rdi, hdrAve
	mov	rsi, 0
	mov	esi, dword [average]
	mov	rax, 0
	call	printf

; ******************************
; Done, terminate program.

last:
	mov	rax, SYS_exit
	mov	rbx, SUCCESS
	syscall

