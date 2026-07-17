; **********************************************************************;
; Program Name: Array Element Reverser
; Program Description: This program reverses the initialized array, progArray.
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

    progArray DWORD 0,2,5,9,10,15,17,23,25,25 ; initializes an array of 10 DWORD elements

; **********************************************************************;
; Functional description of the main program
;	Inputs: 
;		There are no user inputs. The program utilizes 1 array named progArray with 10 initialized DWORD elements.
;	Outputs: 
;		This reverses all of the elements of progArray in memory.
;	Registers used and associated purpose of each: 
;		The registers used are,
;		ESI - This is the extended source index, and it is used as a pointer to the initial element of progArray.
;		ECX - This is the extended count, and it is used to limit how many times the loop named L1 will run.
;		EAX - This is the extended accumulator, and it is used to store the value of the initial element of progArray.
;		EBX - This is the extended base, and it is used to store the value of the final element of progArray.
;       EDX - This is the extended data, and it is used as a pointer to the final element of progArray.
;	Memory locations used and associated purpose of each: 
;		The memory locations are,
;		progArray - This is an array of 10 DWORD elements. This array is initialized with 10 values.
;	Functional details
;       This program creates a loop which takes the array named progArray and reverses it by swapping the two first-most outer elements,
;       then swapping the two second-most outer elements, and so on until the entire array is reversed.
; **********************************************************************;

.code
main PROC
    
    mov ecx, LENGTHOF progArray / 2 ; the amount of times loop L1 will run.
    mov esi, OFFSET progArray ; esi is set as a pointer to progArray's first element
    mov edx, esi ; edx is set as a pointer to the progArray's first element
    add edx, SIZEOF progArray ; edx is set as a pointer to one past progArray's last element
    sub edx, TYPE progArray ; edx is set as a pointer to progArray's last element

    L1:
        mov eax, [esi] ; saves the initial element in a register
        mov ebx, [edx] ; saves the final element in a register

        mov [esi], ebx ; replace the initial element with the final element
        mov [edx], eax ; replace the final element with the initial element
        
        add esi, TYPE progArray ; iterates one element through the array
        sub edx, TYPE progArray ; iterates one element in reverse through the array

        loop L1 ; repeats the loop as many times as half the length of progArray

    INVOKE ExitProcess,0

main ENDP

END main