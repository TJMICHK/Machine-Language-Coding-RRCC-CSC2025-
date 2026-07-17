; **********************************************************************;
; Program Name: Initializing Data and Operations Practice
; Program Description: The goal of this program is to practice initializing data and performing operations with them.
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
	varA DWORD 2 ; initializing varA with data type DWORD and value 2

	varB DWORD 6 ; initializing varB with data type DWORD and value 6

	varC DWORD 5 ; initializing varC with data type DWORD and value 5

	varD DWORD 1 ; initializing varD with data type DWORD and value 1

	result DWORD 0  ; initializing result with data type DWORD and value 0



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

	; this block of code evaluates the equation result = (varA + varB) - (varC + varD)
	mov eax, varA ; copies varA into the eax register
	add eax, varB ; adds varB to the eax register
	sub eax, varC ; subtracts varC from the eax register
	sub eax, varD ; subtracts varD from the eax register
	mov result, eax ; puts the eax register's value into the result variable

	; please note that memory to memory data arithmetic is not allowed.
	; to view the data inside the result variable, open the Watch 1 window and search for 'result' to view.

    INVOKE ExitProcess,0

main ENDP

END main