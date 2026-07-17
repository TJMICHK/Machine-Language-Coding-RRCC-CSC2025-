; **********************************************************************;
; Program Name: String Character Reverser
; Program Description: This program takes a string, then reverses it and saves it into an array.
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

    source BYTE "This is the source string", 0 ; initializes the source string. note that the 0 is the null terminator
    target BYTE SIZEOF source DUP('#') ; initializes an array named target of BYTE data-type and as many elements as there are characters
                                       ; in the source string

; **********************************************************************;
; Functional description of the main program
;	Inputs: 
;		There are no user inputs. The program utilizes a variable named source of the data-type BYTE which is initialized with a string,
;       and 1 array named target with as many elements as there are characters in the variable named source. The array includes an extra
;       element for the null terminator.
;	Outputs: 
;		This program takes a string, reverses it, then saves it into an array.
;	Registers used and associated purpose of each: 
;		The registers used are,
;		ESI - This is the extended source index, and it is used as an index to the current element of source.
;       EAX - This is the extended accumulator, and it is used as an index to the second to final element of target.
;		ECX - This is the extended count, and it is used to limit how many times the loop named L1 will run.
;       BL - This is the base low, and it is used to store character data
;	Memory locations used and associated purpose of each: 
;		The memory locations are,
;		target - This is an array of as many elements as there are characters in the source string, including the null terminator. 
;                it is of the data-type BYTE. This array is used to hold the reversed characters of the source string.
;       source - This is a variable initialized with a string. It is of the data-type BYTE. This variable is used to hold the
;                string that is intended to be reversed.
;	Functional details
;       This program creates a loop that takes the first element of the string named source, then places it in the second to last element
;       of the array named target. After that, the loop then takes the second element of the string and then places it in the third to last
;       element of the array named target. This loop is repeated until the string is copied entirely in reverse into the array.
; **********************************************************************;

.code
main PROC

    mov esi, 0 ; this is the initial array index.

    mov ecx, SIZEOF source-1 ; this is the loop counter. it includes -1 as to ignore the null terminator.
    mov eax, SIZEOF target-2 ; this is the final array index. it points to the second to last element in the array.
    ; the above code ensures that the null terminator does not get placed at the beginning of the string. that would
    ; imply to anything reading the string that it is empty.

    L1:

        mov bl, source[esi] ; this retrieves a character from source. bl is chosen because it is exactly 1 byte
        mov target[eax], bl ; this stores the character in the target array

        ; please note that bl is the lowest 8 bits of ebx and bh is the next lowest 8 bits of ebx

        inc esi ; moves to the index of the next character in source
        dec eax ; moves to the previous address of the array

        loop L1 ; this loops the above code up as many times as one minus the size of the source string.

    mov target[SIZEOF target-1], 0 ; this places the null terminator in the final spot of the array.

    INVOKE ExitProcess,0

main ENDP

END main