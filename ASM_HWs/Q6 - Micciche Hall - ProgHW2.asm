; **********************************************************************;
; Program Name: Array Even Pair Index Swapper
; Program Description: This program takes an array of even element count, then swaps every element
; of even count. For example, indices i and i+1 will be swapped, as well as i+2 and i+3, and
; i+4 and i+5.
; Author:	Terrence Micciche Hall
; Class and Course Section: CSC2025X40
; Creation Date: 06/05/26
; Revisions: 	0
; Date Last Modified:	06/05/26
;***********************************************************************;

.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

.data

    progArray DWORD 1,2,5,9,10,15,17,23,25,25 ; initialize the array with DWORD integers


; **********************************************************************;
; Functional description of the main program
;	Inputs: 
;		There are no user inputs. The program utilizes an array named progArray. This array is of the data-type DWORD, and is
;       initialized with 10 integer elements.
;	Outputs: 
;       There is no functional output of this program. By the end of the program, progArray will have all of its indices
;       swapped into a different position.
;	Registers used and associated purpose of each: 
;		The registers used are,
;		ESI - This is the extended source index, and it is used as an index to the first element in the current pair.
;       EAX - This is the extended accumulator, and it is used as an index to the second element in the current pair.
;		ECX - This is the extended count, and it is used to limit how many times the loop named L1 will run.
;       EBX - This is the extended base, and it is used to save the first element.
;       EDX - This is the extended data, and it is used to save the second element.
;	Memory locations used and associated purpose of each: 
;		The memory locations are,
;       progArray - This is an array of the data-type DWORD. For this specific program, it is initialized with 10 integers,
;       the user has freedom to change the array to any array of even element-count without changing the code. The purpose
;       of this array is to hold the data pairs that will be swapped.
;	Functional details
;       This program creates a loop which saves the pair to be swapped, then swaps the position of the two data, then finds
;       the next pair to be swapped. This loop is repeated up to as many times as one half of the length of the array.
;
; **********************************************************************;

.code
main PROC
    mov esi, 0 ; the offset of the first element in the current pair
    mov eax, TYPE progArray ; this is the offset of the second element in the current pair
    mov ecx, LENGTHOF progArray/2 ; this is the loop counter. in other words, this is the number
                                  ; of pairs to swap

    L1:
        mov ebx, progArray[esi] ; save first element in register
        mov edx, progArray[eax] ; save second element in register

        mov progArray[esi], edx ; swap the first element with the second
        mov progArray[eax], ebx ; swap the second element with the first

        add esi, TYPE progArray*2 ; find the next first element
        add eax, TYPE progArray*2 ; find the next second element

        loop L1 ; repeat the loop up to as many times as one half the length
                ; of the array

    INVOKE ExitProcess,0

main ENDP

END main