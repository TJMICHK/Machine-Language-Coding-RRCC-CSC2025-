; **********************************************************************;
; Program Name: Array Sequential Difference Calculator
; Program Description: This program takes an array of 10 elements, then calculates the difference between each neighboring
; values, and sums all the differences into one memory location.
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

    progArray DWORD 0,2,5,9,10,15,17,23,25,25 ; this initializes an array named progArray with 10 DWORD elements in non-descending order
    differenceSum DWORD 0 ; this initializes a variable named differenceSum with the data-type DWORD


; **********************************************************************;
; Functional description of the main program
;	Inputs: 
;		There are no user inputs. The program utilizes 1 array named progArray with 10 initialized DWORD elements and 1 variable named
;       differenceSum with the data-type DWORD.
;	Outputs: 
;		This program stores the sum of the differences of all neighboring values of the array named progArray in the variable named differenceSum.
;	Registers used and associated purpose of each: 
;		The registers used are,
;		ESI - This is the extended source index, and it is used as a pointer to the current progArray element.
;		ECX - This is the extended count, and it is used to limit how many times the loop named L1 will run.
;		EAX - This is the extended accumulator, and it is used to store the value of the initial element of progArray.
;		EBX - This is the extended base, and it is used to store the value of the final element of progArray.
;		
;	Memory locations used and associated purpose of each: 
;		The memory locations are,
;		progArray - This is an array of 10 DWORD elements. This array is initialized with 10 values.
;       differenceSum - This is a variable with the data-type DWORD. It is initialized to the value 0.
;	Functional details
;       This program creates a loop which takes the array named progArray and sets the first available element to be the initial element
;       then the second available element to be the final element. The positive difference between the two elements is found, and then
;       are added to the running sum of the variable differenceSum. The initial element then is redefined to be the final element, then
;       the final element is redefined to be the next avaiable element in the array. This loop iterates a total of 9 times.
; **********************************************************************;

.code
main PROC

    mov ecx, LENGTHOF progArray - 1 ; This is the amount of times the loop L1 will repeat. The value 9 is chosen because there are a total of 9
                                    ; possible differences in an array of 10 elements.
    mov esi, OFFSET progArray ; This finds the address of the first element in progArray

    L1: ; using L1 can reduce confusion
        mov eax, [esi] ; this sets eax to the value of the address determined by the pointer esi
        add esi, TYPE progArray ; this moves the pointer esi to the value of the next address in progArray
        mov ebx, [esi] ; this sets ebx to the new value determined by pointer esi

        sub ebx, eax ; this finds the difference between the elements

        add differenceSum, ebx ; this adds that difference to the memory location differenceSum
        
        loop L1 ; this iterates the loop as many times as one minus the length of progArray
    

    INVOKE ExitProcess,0

main ENDP

END main