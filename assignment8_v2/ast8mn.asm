;  CS 218 - Assignment 8
;  Provided Main.

;  DO NOT EDIT THIS FILE

; **********************************************************************************
;  Write assembly language functions:

;  * Function, cocktailSort(), sorts the numbers into descending order
;    (large to small).  Uses the cocktail sort algorithm (from asst #7).

;  * Function, simpleStats(), finds the minimum, maximum, median, sum,
;    and average for a list of numbers.  Note, for an odd number of items,
;    the median value is defined as the middle value.  For an even number
;    of values, it is the integer average of the two middle values.

;  * Function, iAverage(), to compute and return the average of a
;    list of numbers.

;  * Function, variance(), to compute and return the variance.
;    Summation and division performed as integer values.
;    Due to the data sizes, the summation for the dividend (top)
;    must be performed as a quad-word.
;    Note, function returns quad result in rax


; **********************************************************************************


section	.data

; -----
;  Define standard constants.

LF		equ	10			; line feed
NULL		equ	0			; end of string

TRUE		equ	0
FALSE		equ	-1

SUCCESS		equ	0			; Successful operation
NOSUCCESS	equ	1			; Unsuccessful operation

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_exit	equ	1			; system call code for terminate
SYS_fork	equ	2			; system call code for fork
SYS_read	equ	3			; system call code for read
SYS_write	equ	4			; system call code for write
SYS_open	equ	5			; system call code for file open
SYS_close	equ	6			; system call code for file close
SYS_create	equ	8			; system call code for file open/create


; -----
;  Data Sets for Assignment #8.

list1		dd	   21,    27,    10,    22,    31
		dd	   13,    12,    17,    19,    20
		dd	   24,    11,    14,    30,    33
		dd	   27,    34,    23,    37,    40
		dd	   38,    18,    15,    25,    16
		dd	   26,    39,    36
len1		dd	28
min1		dd	0
med1		dd	0
max1		dd	0
ave1		dd	0
var1		dq	0

list2		dd	12127, 61135, 21117, 11115, 11161
		dd	21110, 15120, 31122, 11124, 12126
		dd	16129, 91113, 11155, 11135, 14137
		dd	92119, 11141, 22143, 11145, 31149
		dd	19153, 91119, 11123, 21117, 12159
		dd	21116, 12115, 23151, 12167, 11169
		dd	11128, 91130, 31132, 11133, 11111
		dd	13138, 11140, 11142, 21144, 11146
		dd	12121, 11125, 51151, 21113, 12119
		dd	91257, 91199, 44153, 11165, 21179
		dd	11127, 11155, 41117, 51115, 11161
		dd	17183, 92114, 21121, 51128, 12112
		dd	21126, 11117, 11127, 11127, 31184
		dd	95174, 94112, 11125, 52126, 11129
		dd	21188, 11115, 15111, 21118, 12115
		dd	93126, 93117, 21115, 13110, 11114
		dd	11124, 11143, 31134, 21112, 21113
		dd	12172, 92176, 12156, 14165, 12156
		dd	11153, 11140, 21191, 12168, 11162
		dd	11146, 21147, 31167, 31177, 11144
len2		dd	100
min2		dd	0
med2		dd	0
max2		dd	0
ave2		dd	0
var2		dq	0


list3		dd	21244, 11234, 11313, 11221, 31216
		dd	12141, 41321, 21324, 21313, 51223
		dd	11318, 11333, 11112, 21410, 11110
		dd	21124, 31243, 31524, 11512, 21323
		dd	21153, 11440, 11111, 21618, 21212
		dd	41447, 31427, 41414, 31717, 21919
		dd	51183, 11450, 51651, 41828, 11515
		dd	31183, 21414, 41311, 21918, 11212
		dd	11426, 11917, 31217, 21717, 11414
		dd	21174, 21912, 21115, 11616, 21229
		dd	41318, 11335, 11351, 11818, 21515
		dd	11126, 31317, 21315, 10000, 11414
		dd	11124, 31113, 11514, 11212, 11313
		dd	41272, 31326, 21416, 21515, 11616
		dd	11153, 21910, 31451, 11818, 41212
		dd	21146, 21317, 11317, 21117, 11211
		dd	11255, 11452, 21615, 31219, 61111
		dd	11464, 11552, 11715, 41312, 11253
		dd	11483, 21515, 21911, 31418, 11137
		dd	21966, 31717, 11987, 21617, 21435
		dd	21610, 41320, 21332, 21524, 21659
		dd	11319, 11232, 11195, 11335, 11373
		dd	31339, 21341, 21343, 11345, 11494
		dd	11353, 11439, 11313, 10000, 11953
		dd	21416, 11415, 12551, 11667, 21912
		dd	11628, 21430, 11132, 21133, 10000
		dd	21938, 31240, 21342, 21444, 11461
		dd	11121, 41425, 11251, 11313, 11191
		dd	11257, 51999, 11153, 21665, 11791
		dd	11118, 21455, 21417, 31515, 21111
		dd	11283, 31234, 21611, 11828, 21221
		dd	21826, 41317, 31827, 21127, 21400
		dd	11168, 31115, 31611, 11218, 11550
		dd	21436, 21317, 11515, 21411, 11448
		dd	31314, 11243, 11334, 21312, 21381
		dd	11432, 81276, 21156, 11665, 11647
		dd	31353, 11140, 21231, 11868, 21265
		dd	21896, 61547, 11367, 11777, 21446
		dd	31455, 31332, 11385, 21449, 11146
		dd	11264, 31472, 21175, 31162, 11721
len3		dd	200
min3		dd	0
med3		dd	0
max3		dd	0
ave3		dd	0
var3		dq	0


; **********************************************************************************

extern	cocktailSort, simpleStats, iAverage, variance

section	.text
global	main
main:

; **************************************************
;  Call functions for data set 1.

;  HLL call:
;	cocktailSort(list, len)

	mov	rdi, list1
	mov	esi, dword [len1]
	call	cocktailSort

;  HLL call:
;	simpleStats(list, len, min, max, med)

	mov	rdi, list1
	mov	esi, dword [len1]
	mov	rdx, min1
	mov	rcx, max1
	mov	r8, med1
	call	simpleStats

;  HLL call:
;	ave = iAverage(list, len)

	mov	rdi, list1
	mov	esi, dword [len1]
	call	iAverage

	mov	dword [ave1], eax

;  HLL call:
;	var = variance(list, len)

	mov	rdi, list1
	mov	esi, dword [len1]
	call	variance

	mov	qword [var1], rax

; **************************************************
;  Call functions for data set 2.

;  HLL call:
;	cocktailSort(list, len)

	mov	rdi, list2
	mov	esi, dword [len2]
	call	cocktailSort

;  HLL call:
;	simpleStats(list, len, min, max, med)

	mov	rdi, list2
	mov	esi, dword [len2]
	mov	rdx, min2
	mov	rcx, max2
	mov	r8, med2
	call	simpleStats

;  HLL call:
;	ave = iAverage(list, len)

	mov	rdi, list2
	mov	esi, dword [len2]
	call	iAverage

	mov	dword [ave2], eax

;  HLL call:
;	var = variance(list, len)

	mov	rdi, list2
	mov	esi, dword [len2]
	call	variance

	mov	qword [var2], rax

; **************************************************
;  Call functions for data set 3.

;  HLL call:
;	cocktailSort(list, len)

	mov	rdi, list3
	mov	esi, dword [len3]
	call	cocktailSort

;  HLL call:
;	simpleStats(list, len, min, max, med)

	mov	rdi, list3
	mov	esi, dword [len3]
	mov	rdx, min3
	mov	rcx, max3
	mov	r8, med3
	call	simpleStats

;  HLL call:
;	ave = iAverage(list, len)

	mov	rdi, list3
	mov	esi, dword [len3]
	call	iAverage

	mov	dword [ave3], eax

;  HLL call:
;	var = variance(list, len)

	mov	rdi, list3
	mov	esi, dword [len3]
	call	variance

	mov	qword [var3], rax

; *****************************************************************
;  Done, terminate program.

last:
	mov	rax, SYS_exit
	mov	rbx, SUCCESS
	syscall

