;	Project Name:	johnsey_program2
;	File Name:		sieve.asm
;	Author:			Hayley Johnsey
;	Date:			10-1-18 (Changes made 1.3.19)


.586
.MODEL FLAT

INCLUDE io.h

.STACK 4096                 ; reserve 4096-byte stack

.DATA                       ; reserve storage for data

string				BYTE    40 DUP (?)
prompt1				BYTE    "Enter number of primes to generate: ", 0
blank				BYTE    " ", 0
errorStmt			BYTE	"Please enter a number between 1 and 100.", 0
errorLbl			BYTE	"Error:", 0
primenum			BYTE    11 DUP (?), 0
inputNum			DWORD	 0
endMessage			BYTE	"Press any key to exit program.", 0

max					DWORD	541				;user cannot generate more than 100 primes (541 is the 100th prime)
sqrtMax				DWORD	24				;the squareroot of max is 24
intArray			BYTE	540 DUP(1)		;make an int array (representing 2-541) and set all elements to 1
primeNum1			DWORD	2				;initialize the first prime number to 2
currentElement		DWORD	1				;initialize the currentElement to (not starting at 2)

printloopCntr		DWORD	0				;printLoop counter to make sure only the input number of primes are printed

EXTERN genPrimes:PROC

.CODE

_sieve  PROC                            ;start of sieve program code

inputsect:
      input   prompt1, string, 40       ;read ASCII characters

	  atod string						;convert to doubleword integer
	  mov inputNum, eax					;store the doubleword integer in inputNum

	  cmp eax, 100
	  jg errorprint
	  cmp eax, 1
	  jl errorprint
	  jmp parampush

errorprint:
	  output errorLbl, errorStmt		;if a number greater than 100 is entered, output an error statement
	  jmp inputsect						;jump to inputsect

parampush:
	  ;push parameters onto the stack
	  push max							;6th parameter [ebp+28]
	  push sqrtMax						;5th parameter [ebp+24]
	  push primeNum1					;4th parameter [ebp+20]
	  push currentElement				;3rd parameter [ebp+16]
	  lea eax, intArray					;2nd parameter, put address of the first element of intArray in eax
	  push eax							;push the parameter onto the stack [ebp+12]
	  push inputNum						;1st parameter, push the parameter onto the stack [ebp+8]

      call  genPrimes					;call the genPrimes procedure

	  ;loop to print the prime numbers
	  mov ebx, 0						;clear ebx
	  lea ebx, intArray					;load address of the first element of intArray into eax
	  mov ecx, ebx						;move the address of the first element of intArray into ecx (represents currentElement)

printLoop:
	  ;if the value held at the address in currentElement is 1 (true), print the represented value
	  ;if the value held at the address in currentElement is 0 (false), continue
	
	  mov eax, ebx						;move the address of the first element of the array into eax
	  sub eax, ecx						;subtract the address of the current element by the address of the first element
	  add eax, 2						;eax now holds the represented number

	  mov eax, ecx						;move address held in currentElement/ecx/[ebp+16] to eax
	  mov eax, [eax]					;move the data held inside that address to eax
	  cmp al, 1							;compare the data at the address (current array element being looked at) to 1
	  jne continueLoop					;if the contents of the array is not equal to 1 (already crossed out) then jump to continueLoop

	  ;produce represented number
	  mov eax, ecx						;move the data located at the address held within ecx (currentElement) to eax
	  sub eax, ebx						;eax should now hold the value of how many elements we are away from the beginning
	  add eax, 2						;adding 2 to eax will determine the value the element represents

	  dtoa primeNum, eax				;convert doubleword integer in eax to ASCII characters and store it in primeNum
      output primenum, blank			;output label and primeNum
	  add printloopCntr, 1

continueLoop:
	  mov eax, printloopCntr
	  cmp eax, inputNum
	  jge endProcSequence				;if the array printing is done, jump to endProcSequence

	  add ecx, 1						;add one to ecx to increment to the next element of the array

	  jmp printLoop						;jump to printLoop

endProcSequence:
	  output endMessage, blank
	  input blank, string, 40

      mov   eax, 0						; exit with return code 0
      ret

_sieve  ENDP

END