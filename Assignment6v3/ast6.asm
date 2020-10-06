; *****************************************************************
;	name: ...
;	assignment #06
;	section #1004

;   Program Description:
;Request user input and generate sorted array of random numbers.
;Check for error within certain range, and do work within 4 
;functions. Additionally use macros and sort array with Comb Sort. 
;
;Shows mastery of Functions.
;
; *****************************************************************

; ---- 

section .data
	; 	System Service Call Constants
	SYSTEM_EXIT equ 60
	SUCCESS equ 0
	SYSTEM_WRITE equ 1
	SYSTEM_READ equ 0
	STANDARD_OUT equ 1
	STANDARD_IN equ 0

	;	ASCII Values
	NULL equ 0
	LINEFEED equ 10
	
	;	Program Constraints
	MINIMUM_ARRAY_SIZE equ 2
	MAXIMUM_ARRAY_SIZE equ 10000
	INPUT_LENGTH equ 20
	OUTPUT_LENGTH equ 11
	VALUES_PER_LINE equ 5

	; Rand Constants
	A equ 48271		  ; from ast pdf
	M equ 2147483647  ; (2^31) - 1
	
	;	Labels / Useful Strings
	labelHeader db "Sorted Random Number Generator!", LINEFEED, LINEFEED, NULL
	labelSorted db "Sorted Random Numbers:", LINEFEED, NULL
	endOfLine db LINEFEED, NULL
	space db " "
    screenHeader db "**********************************************************************", LINEFEED, NULL
	
	;	Prompts
	promptNumValues db "Number of values to generate (2-10,000):", LINEFEED, NULL
	promptMaxValue db "Maximum Value (1-100,000):", LINEFEED, NULL
	
	;	Error Messages
	;		Array Length
	errorArrayMinimum db LINEFEED, "Error - Program can only convert at least 2 values.", LINEFEED, LINEFEED, NULL
	errorArrayMaximum db LINEFEED, "Error - Program can only convert at most 10,000 values.", LINEFEED, LINEFEED, NULL
	errorRangeMaximum db LINEFEED, "Error - Program can only convert at most 100,000 values.", LINEFEED, LINEFEED, NULL		 
	errorRangeMinimum db LINEFEED, "Error - Program can only convert at least 1 value.", LINEFEED, LINEFEED, NULL
	;		Decimal String Conversion
	errorStringUnexpected db LINEFEED,"Error - Unexpected character found in input." , LINEFEED, LINEFEED, NULL
	errorStringNoDigits db LINEFEED,"Error - Value must contain at least one numeric digit." , LINEFEED, LINEFEED, NULL
	
	;		Input Length
	errorStringTooLong db LINEFEED, "Error - Input can be at most 20 characters long." , LINEFEED, LINEFEED, NULL
	
	
	;	Program variables
	arrayLength dd 0
	rngRandNum dd 0
	amtRandNum dd 0
	randNum dd 0
	lcg	dd 1		; lcg starts at 1 to function as seed

section .bss
	;	Array of integer values, not all will necessarily be used
	array resd 1000
	inputString resb 21
	outputString resb 11

section .text
global main
main:
; ********************************MAIN*********************************

;	Output Screen Header
	mov rax, SYSTEM_WRITE
	mov rdi, STANDARD_OUT
	mov rsi, screenHeader
	mov rdx, 60
	syscall
	; newLine
	mov rax, SYSTEM_WRITE
	mov rdi, STANDARD_OUT
	mov rsi, endOfLine
	mov rdx, 1
	syscall

;	Output Header
	mov rax, SYSTEM_WRITE
	mov rdi, STANDARD_OUT
	mov rsi, labelHeader
	mov rdx, 32
	syscall
	; newLine
	mov rax, SYSTEM_WRITE
	mov rdi, STANDARD_OUT
	mov rsi, endOfLine
	mov rdx, 1
	syscall

    ;	Output Array Length Prompt
	mov rax, SYSTEM_WRITE
	mov rdi, STANDARD_OUT
	mov rsi, promptNumValues
	mov rdx, 40
	syscall

    ; newLine
	mov rax, SYSTEM_WRITE
	mov rdi, STANDARD_OUT
	mov rsi, space
	mov rdx, 1
	syscall

    ; Read in Number of Randoms to generate
	mov rax, SYSTEM_READ
	mov rdi, STANDARD_IN
	lea rsi, byte[inputString]
	mov rdx, INPUT_LENGTH
	syscall

    ; decToIntFunction(inputString, amtRandNum); //C++
    mov esi, dword[amtRandNum]  ; 2nd arg
    mov rdi, inputString    	; 1st arg
    call function3

	mov dword[amtRandNum], esi	; update var

	; if too large
	cmp dword[amtRandNum], 10000
	ja errPromptAbove

	;if too small
	cmp dword[amtRandNum], 2
	jb errPromptBelow

    ;	Output Array Length Prompt
	mov rax, SYSTEM_WRITE
	mov rdi, STANDARD_OUT
	mov rsi, promptMaxValue
	mov rdx, 26
	syscall

    ; newLine
	mov rax, SYSTEM_WRITE
	mov rdi, STANDARD_OUT
	mov rsi, space
	mov rdx, 1
	syscall

    ; Reuse 'inputString' var.
    ; Read in Range of Randoms to generate
	mov rax, SYSTEM_READ
	mov rdi, STANDARD_IN
	lea rsi, byte[inputString]
	mov rdx, INPUT_LENGTH
	syscall

    ; decToIntFunction(inputString, funcInt); //C++
    mov esi, dword[rngRandNum] ; 2nd arg
    mov rdi, inputString       ; 1st arg
    call function3

	mov dword[rngRandNum], esi  ; update var

	; if too large
	cmp dword[rngRandNum], 100000
	ja errPromptAboveRange

	;if too small
	cmp dword[rngRandNum], 1
	jb errPromptBelowRange


    ; Output Screen Header
	mov rax, SYSTEM_WRITE
	mov rdi, STANDARD_OUT
	mov rsi, screenHeader
	mov rdx, 60
	syscall

	; newLine
	mov rax, SYSTEM_WRITE
	mov rdi, STANDARD_OUT
	mov rsi, endOfLine
	mov rdx, 1
	syscall

	; Output Array Length Prompt
	mov rax, SYSTEM_WRITE
	mov rdi, STANDARD_OUT
	mov rsi, labelSorted
	mov rdx, 22
	syscall

    ; newLine
	mov rax, SYSTEM_WRITE
	mov rdi, STANDARD_OUT
	mov rsi, endOfLine
	mov rdx, 1
	syscall

	; Loop to Gen Rand and populate array, then we combsort
	mov r9d, dword[amtRandNum] ; amt to output
	mov r12d, 0 		;arr[i]
	genRandLoop;

		; call Rand func 
		mov r8d, dword[rngRandNum]
		mov ecx, lcg
		mov edx, dword[randNum]
		mov esi, M 
		mov edi, A 
		call function1 ; Generate Random
		inc dword[rngRandNum] ; update rng 

		; Update Rand number.
		mov dword[randNum], edx 

		; Update array w/Rands(Int)
		mov dword[array+(r12d*4)], edx 

		
	keepGo:
	inc r12d 	; arr[i++]
	dec r9d	 	; total to output to terminal
	cmp r9d, 0
	jne genRandLoop

	; ----------

	; New line
	mov rax, SYSTEM_WRITE
	mov rdi, STANDARD_OUT
	mov rsi, endOfLine
	mov rdx, 1
	syscall

	;Call Comb Sort Function
	mov edi, array
	mov esi, dword[amtRandNum]
	call function2

	; ----
	; Output array to Terminal in Hex string
	
	mov r12d, 0 		; Index of Array
	mov r13d, 1			; Output index
	outputInHexLoop:

	; Convert index to Hex
	mov esi, outputString
	mov edi, dword[array+(r12d*4)]
	call function4

	; Output Hex to Terminal 
	mov rax, SYSTEM_WRITE
	mov rdi, STANDARD_OUT
	lea rsi, byte[outputString]
	mov rdx, 11
	syscall

	; space
	mov rax, SYSTEM_WRITE
	mov rdi, STANDARD_OUT
	mov rsi, space
	mov rdx, 1
	syscall

	; / 5 to check for 5th index and print \n
	mov edx, 0
	mov eax, r13d
	mov ebx, 5
	div ebx
	cmp edx, 0
	jne keepGoing
		; Print EndLine at 5th index to Terminal
		mov rax, SYSTEM_WRITE
		mov rdi, STANDARD_OUT
		mov rsi, endOfLine
		mov rdx, 1
		syscall
	
	keepGoing:

	inc r12d
	inc r13d
	cmp	r12d, dword[amtRandNum]
	jne outputInHexLoop

	; End of Line
	mov rax, SYSTEM_WRITE
	mov rdi, STANDARD_OUT
	mov rsi, endOfLine
	mov rdx, 1
	syscall

	;	Output Screen Header
	mov rax, SYSTEM_WRITE
	mov rdi, STANDARD_OUT
	mov rsi, screenHeader
	mov rdx, 60
	syscall
	; newLine
	mov rax, SYSTEM_WRITE
	mov rdi, STANDARD_OUT
	mov rsi, endOfLine
	mov rdx, 1
	syscall

	jmp exit ; exit program

	; List of Possible Errors

	; large error
	errPromptAbove:
		mov rax, SYSTEM_WRITE
		mov rdi, STANDARD_OUT
		mov rsi, errorArrayMaximum
		mov rdx, 56
		syscall
		; newLine
		mov rax, SYSTEM_WRITE
		mov rdi, STANDARD_OUT
		mov rsi, endOfLine
		mov rdx, 1
		syscall
		jmp exit

	; to small error
	errPromptBelow:
		mov rax, SYSTEM_WRITE
		mov rdi, STANDARD_OUT
		mov rsi, errorArrayMinimum
		mov rdx, 52
		syscall
		; newLine
		mov rax, SYSTEM_WRITE
		mov rdi, STANDARD_OUT
		mov rsi, endOfLine
		mov rdx, 1
		syscall
		jmp exit

	; large error
	errPromptAboveRange:
		mov rax, SYSTEM_WRITE
		mov rdi, STANDARD_OUT
		mov rsi, errorRangeMaximum
		mov rdx, 57
		syscall
		; newLine
		mov rax, SYSTEM_WRITE
		mov rdi, STANDARD_OUT
		mov rsi, endOfLine
		mov rdx, 1
		syscall
		jmp exit

	; to small error
	errPromptBelowRange:
		mov rax, SYSTEM_WRITE
		mov rdi, STANDARD_OUT
		mov rsi, errorRangeMinimum
		mov rdx, 51
		syscall
		; newLine
		mov rax, SYSTEM_WRITE
		mov rdi, STANDARD_OUT
		mov rsi, endOfLine
		mov rdx, 1
		syscall
		jmp exit

exit: ; if error in input detected in Function 4, jmp here and exit.
; ******************************************************************
endProgram:
	mov rax, SYSTEM_EXIT
	mov rdi, SUCCESS
	syscall




; FUNCTIONS 
; ******************************************************************
   
   	; Variables Passed
	; r8d = rngRandNum
	; ecx = lcg
	; edx = randNum  
   	; esi = M
	; edi = A
    global function1
    function1:
    ; prologue

	movsxd rax, ecx 	; rax = lcg = seed(1)
	mul rdi 	; * A
	div rsi		; / M
	mov rcx, rdx ; update lcg?

	
	; update lcg:  lcg % rngRandNum
	mov rax, rdx
	mov rdx, 0 		; initialize
	mov rbx, r8
	div rbx			
	;mov r8, rdx	

    ; epilogue
    ret
	
	; ----------

	;Variables Passed
	; esi: amtRandGen
	; rdi: dword[array]
    global function2
    function2:
    ; prologue
	push r11 ; gapsize
	push r12 ; temp
	push r13 ; swapDone
	push r14 ; n - gapsize
	push r15 ; inner Loop [i]

	; initialize
	mov r12, 0
	mov r13, 0

	mov r11d, esi ; gapsize = amtRandGen = arraySize
	;mov r8d, edi	  ; array

	mov r9d, 0 ; arr[i]

	theLoop:

	push r9
		
		; gapsize = (gap * 10) / 13
		mov edx, 0
		mov eax, r11d
		mov ebx, 10
		mul ebx
		mov ebx, 13
		div ebx

		mov r11d, eax
		cmp r11d, 0
		jne proceed 		; if (gapsize == 0) gapsize = 1
			mov r11d, 1	
		proceed:
		; swapDone = 0
		mov r13d, 0

		mov r14d, dword[amtRandNum]
		mov eax, r14d
		sub eax, r11d		
		mov r14d, eax ; n - gapsize

		; for ( i = 0, i < n – gapsize, i++ )
			mov r12d, 0  ; temp = 0
			mov r15d, 0	 ; inner Loop [i]
			innerLoop:

			; if(array[i] > array[i+gapsize])
			mov eax, dword[edi+(r9d*4)]
			mov ebx, dword[edi+(r14d*4)]  ; ebx = array[i+gapsize]
			cmp eax, ebx
			ja startSwap
				jmp nextIteration
				
			startSwap:

			; temp = array[i]
			mov r12d , dword[edi+(r9d*4)] 

			; array[i] = array[i+gapsize]
			mov dword[edi+(r9d*4)], ebx

			; array[i+gapsize] = temp
			mov dword[edi+(r14d*4)], r12d

			; swapsDone++
			inc r13

			nextIteration: 

			inc r15d
			inc r9d
			cmp r15d, r14d
			jne innerLoop

	; if(gapsize == 1 and swapsDone == 0) exit loop
	cmp r11d, 1
	je checkSwapsDone

		jmp moreLoops

	checkSwapsDone:
		cmp r13, 0
		je breakOut

	moreLoops:

	pop r9
	inc r9d
	jmp theLoop

	breakOut:

    ; epilogue
	pop r15
	pop r14
	pop r13
	pop r12
	pop r11 
	pop r9
    ret 	
    
	; ----------

	; Variables Passed
	; esi: dword[amtRandNum]
	; edi: array
    global function3
    function3:
    ; prologue

    mov eax, 0
	mov rbx, rdi
	mov r9d, 1	; sign
	mov r8d, 10 ; base
	mov r10, 0  ; digits processed
	
	checkForSpaces1:
		mov cl, byte[rbx]
		cmp cl, " "
		jne nextCheck1
		
		inc rbx
	jmp checkForSpaces1
	nextCheck1:

	cmp cl, "+"
	je checkForSpaces2Adjust
	cmp cl, "-"
	jne checkNumerals
	mov r9d, -1
	
	checkForSpaces2Adjust:
		inc rbx
	checkForSpaces2:
		mov cl, byte[rbx]
		cmp cl, " "
		jne nextCheck2
		
		inc rbx
	jmp checkForSpaces2
	nextCheck2:

	checkNumerals:
		movzx ecx, byte[rbx]
		cmp cl, LINEFEED
		je finishConversion

		cmp cl, " "
		je checkForSpaces3
		
		cmp cl, "0"
		jb errorUnexpectedCharacter
		cmp cl, "9"
		ja errorUnexpectedCharacter
		jmp convertCharacter
		errorUnexpectedCharacter:
	
			; unexpected Char error
			errUnexChar:
				mov rax, SYSTEM_WRITE
				mov rdi, STANDARD_OUT
				mov rsi, errorStringUnexpected
				mov rdx, 45
				syscall
				; newLine
				mov rax, SYSTEM_WRITE
				mov rdi, STANDARD_OUT
				mov rsi, endOfLine
				mov rdx, 1
				syscall
				jmp exit
			
		convertCharacter:
		sub cl, "0"
		mul r8d
		add eax, ecx
		inc r10

		inc rbx
	jmp checkNumerals
	
	checkForSpaces3:
		mov cl, byte[rbx]
		cmp cl, " "
		jne checkNull
		
		inc rbx
	jmp checkForSpaces3
	
	checkNull:
		cmp cl, LINEFEED
		je finishConversion
			jmp errUnexChar
	
	finishConversion:
		cmp r10, 0
		jne applySign
			; no digit error
			errNoDigit:
				mov rax, SYSTEM_WRITE
				mov rdi, STANDARD_OUT
				mov rsi, errorStringNoDigits
				mov rdx, 55
				syscall
				; newLine
				mov rax, SYSTEM_WRITE
				mov rdi, STANDARD_OUT
				mov rsi, endOfLine
				mov rdx, 1
				syscall
				jmp exit
	applySign:
		mul r9d
		mov esi, eax

    ; epilogue
    ret

	; ----------

	; esi: byte[outputString] ... ?
	; rdi: dword[randNum]
	global function4
    function4:
    ; prologue

	mov r8, 9 ; begin at index 10
	;mov ecx, esi

	mov byte[outputString+10], NULL ; hardcode NULL

	mov eax, edi ; value

	begin:
	; division
	mov edx, 0
	mov ebx, 16
	div ebx

	; if edx = 0, fill remainder with zeros (i.e. 0x0000)
	cmp edx, 0		
	je fillZero

	; 0 - 9
	cmp edx, 9
	ja checkCapLet
		add edx, '0'
		mov byte[outputString+r8d], dl
		dec r8
	cmp r8, 1
	jne begin

	; skip to end
	jmp complete


	; A-F
	checkCapLet:
		add edx, '7'
		mov byte[outputString+r8d], dl
		dec	r8
	cmp r8, 1
	jne begin

	; Fill remainder of string with 0 (i.e. 0x0000)
	fillZero:
		mov byte[outputString+r8d], "0"
			dec r8
		cmp r8, 0
		jne fillZero

	; Format Output "0x" hardcoded
	mov byte[outputString], "0"
	mov byte[outputString+1], "x"

	complete:

    ; epilogue
    ret
