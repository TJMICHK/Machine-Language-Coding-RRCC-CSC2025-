; **********************************************************************;
; Program Name: Fibonacci Sequence
; Program Description: This program utilizes the Fibonacci Sequence up to the 26th value.
; Author:	Terrence Micciche Hall
; Creation Date: 06/04/26
; Revisions: 	0
; Date Last Modified:	06/04/26
;***********************************************************************;

.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

.data

	fibArray DWORD 26 DUP(?) ; creates an array fibArray with 26 uninitialized elements

; **********************************************************************;
; Functional description of the main program
;	Inputs: 
;		There are no user inputs. The program utilizes 4 initialized DWORD variables, varA, varB, varC, and varD.
;	Outputs: 
;		This program stores the final calculated value in the DWORD variable result.
;	Registers used and associated purpose of each: 
;		The EAX register was used as an accumulator to hold the calculations.
;	Memory locations used and associated purpose of each: 
;		The memory locations are,
;		varA - This value is added to the total. It is the first value in the expression.
;		varB - This value is added to the total
;		varC - This value is subtracted from the total.
;		varD - This value is subtracted from the total.
;		result - This stores the final result of varA + varB - varC - varD.
;	Functional details
;		This program loads varA into EAX, then adds varB, subtracts varC, subtracts varD, then stores
;		the final value from the EAX register into result.
; **********************************************************************;

.code
main PROC

	mov esi, OFFSET fibArray ; this finds the address of the first element of fibArray
	mov ecx, 24 ; this will allow the fib loop to run 24 times.
	; it should be noted that every time a loop runs, ecx implicitly lowers by 1 with every iteration
	
	mov eax, 0 ; let eax be the previous, fib(0) = 0
	mov ebx, 1 ; let ebx be the current, fib(1) = 1

	mov fibArray, eax ; initializes fibArray[0] with 0
	mov fibArray+4, ebx ; initializes fibArray[1] with 1

	add esi, 8 ; skip to the address of fibArray. This address is at fibArray[3]

	fib:
		; register to register is allowed
		mov edx, eax ; next = previous
		add edx, ebx ; next = next + current

		mov [esi], edx ; the element of fibArray pointed by esi is equal to next
		add esi, 4 ; move to the next address in fibArray

		mov eax, ebx ; previous = current
		mov ebx, edx ; current = next

		loop fib ; this repeats the loop until ecx = 0

    INVOKE ExitProcess,0

main ENDP

END main