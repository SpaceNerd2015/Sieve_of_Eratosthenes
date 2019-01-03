;	Project Name:	johnsey_program2
;	File Name:		genprimes.asm
;	Author:			Hayley Johnsey
;	Date:			10-26-18


.586
.MODEL FLAT

INCLUDE io.h

PUBLIC genPrimes

.STACK 4096

.CODE
genPrimes PROC

	push ebp					;save base pointer
	mov ebp, esp				;establish stack frame
	push eax					;save eax
	push ebx					;save ebx
	push ecx					;save ecx
	push edx					;save edx

	;inputNum: [ebp+8]
	;intArray (first element address): [ebp+12]
	;currentElement: [ebp+16]
	;primeNum1: [ebp+20]
	;sqrtMax: [ebp+24]
	;max: [ebp+28]

resetPointer:
;ebx: intArray first element address
;ecx: currentElement
	mov ebx, 0					;make sure all of ebx is clear with 0s first
	mov ebx, [ebp+12]			;initialize ebx as the pointer to the first element in intArray

	mov ecx, ebx				;move ebx (the address of the first element of intArray) into ecx (which now represents currentElement)
	add ecx, 1					;currentElement/ecx/[ebp+16] starts at element 2 (represents 3)

;for loop to test numbers as primes from 2 to n*n <= max
primeLoop:
	mov eax, 0					;clear eax
	mov edx, 0					;clear edx

	;only check numbers that are not already determined as composite
	mov eax, [ecx]				;move the data found at the address held in currentElement/ecx/[ebp+16] to eax
;	mov eax, [eax]				;move the data held inside that address to eax
	cmp al, 1					;compare the data at the address (current array element being looked at) to 1 (see if the element has already been crossed out)
	jne arrayAddInc				;if the contents of the array is not equal to 1 (already crossed out) then jump to arrayAddInc

;for loop to test each number in the array for multiples
arrayLoop:
	;clear the contents of edx and eax to perform operations
	mov edx, 0					;clear out edx
	mov eax, 0					;clear out eax

	;modulo arithmetic is the same as (num - divisor * (num/divisor))
	mov eax, ecx				;move the address held within ecx (currentElement) to eax
	sub eax, ebx				;eax should now hold the value of how many elements we are away from the beginning
	add eax, 2					;adding 2 to eax will determine the value the element represents

	cmp eax, [ebp+20]			;compare primeNum1 [ebp+20] to eax (the value of the prime being represented)
	je arrayAddInc				;if primeNum1 is equal to eax then jump to arrayAddInc

	push ebx
	mov ebx, [ebp+20]			;move primeNum1 into ebx
	div ebx						;divide eax (the number being represented) by primeNum1 [ebp+20]
	mov edx, 0					;clear edx (remainder)
	mov edx, [ebp+20]			;move primeNum1 into edx
	mul ebx						;multiply the result by primeNum1 [ebp+20]
	pop ebx

	mov edx, 0					;clear edx
	mov edx, ecx				;move the address held within ecx (currentElement) to edx
	sub edx, ebx				;edx should now hold the value of how many elements we are away from the beginning
	add edx, 2					;adding 2 to edx will determine the value the element represents

	sub edx, eax				;subtract the number the element represents by the result from the previous multiplication
	cmp edx, 0					;compare ecx with 0 to see if there is a remainder or no
	jne	arrayLoopCheck			;if ecx is not equal to 0 (there is a remainder), jump to arrayLoopCheck

	;if no jump was made it is assumed that the contents of the current array element is evenly divisible by the prime
	mov eax, 0					;clear eax
	mov eax, ecx				;move the address held in currentElement (ecx) to eax
;	mov eax, [eax]				;move the data held at that address to eax
	mov BYTE PTR [eax], 0		;the byte at the address contained in eax is changed to 0
	
arrayLoopCheck:
	;compare where we are in the array with 541 and if greater or equal to, jump to resetPointer

	mov edx, 0					;clear edx 
	mov edx, ecx				;move the address held in ecx (currentElement) to edx
	sub edx, ebx				;edx should now hold the value of how many elements we are away from the beginning
	add edx, 2					;adding 2 to edx will determine the value the element represents

	cmp edx, [ebp+28]			;compare edx with max [ebp+18] (compare edx with 541)
	jl arrayAddInc				;if edx is less than 541, then jump to arrayAddInc

	mov eax, 0					;clear eax

	;check to stop prime checking
	mov eax, [ebp+20]			;move contents of primeNum1 [ebp+20] into eax
	cmp eax, [ebp+24]			;compare primeNum1 to the squareroot of max (compare primeNum1 to 24)
	jg exitSequence				;if the square of primeNum1 is greater than max, then jump to exit

	lea edx, [ebp+20]
	add eax, 1					;add 1 to primeNum1 (increment the prime number we are checking)
	mov DWORD PTR [edx], eax	;increment primeNum1
	jmp resetPointer			;jump to resetPointer

arrayAddInc:
	add ecx, 1					;increment the ecx/currentElement by 1 to move to the next element of the array
	jmp arrayLoop				;jump to arrayLoop

exitSequence:
	pop edx						;restore edx
	pop ecx						;restore ecx
	pop ebx						;restore ebx
	pop eax						;restore eax

	pop ebp						;restore ebp

	ret							;exit genPrimes

genPrimes	ENDP

END
