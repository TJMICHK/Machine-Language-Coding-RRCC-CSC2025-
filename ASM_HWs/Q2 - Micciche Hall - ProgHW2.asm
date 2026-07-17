; **********************************************************************;
; Program Name: Fibonacci Sequence
; Program Description: This program stores the first 26 values of the Fibonacci sequence.
; Author:	Terrence Micciche Hall
; Class and Course Section: CSC2025X40
; Creation Date: 06/04/26
; Revisions: 	0
; Date Last Modified:	06/04/26
;***********************************************************************;

.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

.data

	fibArray DWORD 26 DUP(?) ; creates an array named fibArray with 26 uninitialized DWORD elements

; **********************************************************************;
; Functional description of the main program
;	Inputs: 
;		There are no user inputs. The program utilizes 1 array named fibArray with 26 uninitialized DWORD elements.
;	Outputs: 
;		This program stores the first 26 values of the Fibonacci Sequence in the array named fibArray.
;	Registers used and associated purpose of each: 
;		The registers used are,
;		ESI - This is the extended source index, and it is used as a pointer to the current fibArray element.
;		ECX - This is the extended count, and it is used to limit how many times the loop named fib will run.
;		EAX - This is the extended accumulator, and it is used to store the value of the previous Fibonacci value in fibArray.
;		EBX - This is the extended base, and it is used to store the value of the current Fibonacci value in fibArray.
;		EDX - This is the extended data, and it is used to store the value of the next Fibonacci value in fibArray.
;		
;	Memory locations used and associated purpose of each: 
;		The memory locations are,
;		fibArray - this is an array of 26 DWORD elements, used to hold 26 Fibonacci values.
;	Functional details
;		This program first creates an array named fibArray. Then the first two elements of fibArray are set to 0 and 1 respectively.
;		Then, a loop is ran. This loop follows the structure such that next is set equal to previous plus current,
;		the next available element in fibArray is set equal to next, then previous is set equal to current and current is set equal
;		to next. This loop runs 24 times to make up for the remaining 24 undetermined values of the Fibonacci Sequence.
; **********************************************************************;

.code
main PROC

	mov eax, 0 ; let eax be the previous, fib(0) = 0
	mov ebx, 1 ; let ebx be the current, fib(1) = 1

	mov esi, OFFSET fibArray ; this finds the address of the first element of fibArray
	mov ecx, LENGTHOF fibArray - 2 ; this will allow the fib loop to run 24 times, since the first two elements are predetermined
	; it should be noted that every time a loop runs, ecx implicitly lowers by 1 with every iteration

	mov fibArray, eax ; initializes fibArray[0] with 0
	mov fibArray + TYPE fibArray, ebx ; initializes fibArray[1] with 1

	add esi, 2 * TYPE fibArray ; move to the address of fibArray[2].

	fib:
		; register to register is allowed
		mov edx, eax ; next = previous
		add edx, ebx ; next = next + current

		mov [esi], edx ; the element of fibArray pointed by esi is equal to next
		add esi, TYPE fibArray ; move to the next address in fibArray

		mov eax, ebx ; previous = current
		mov ebx, edx ; current = next

		loop fib ; this repeats the loop until ecx = 0

    INVOKE ExitProcess,0

main ENDP

END main