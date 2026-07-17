; **********************************************************************;
; Program Name: String Compressor
; Program Description: This program takes a string of 100 characters, then removes any characters that are not letters. Afterwards, the
; compressed string is outputted.
; Author: Terrence Micciche Hall
; Creation Date: 06/17/26
; Revisions: 0
; Date Last Modified: 06/18/26
;***********************************************************************;

INCLUDE C:\Irvine\Irvine32.inc
INCLUDELIB C:\Irvine\Irvine32.lib

.data
    
    promptEnterStr BYTE "Please enter a string of 100 characters or less:", 0 ; initializes a string to promp the user to enter a one-line string

    enterString BYTE 101 DUP(?) ; create an array of 100 + 1 uninitialized characters, accounting for the null terminator. This array holds the
                                ; string that the user enters.

    copiedString BYTE 101 DUP(?) ; creates an array of 100 + 1 uninitialized characters, accountinng for the null terminator. This array holds a
                                 ; copy of the enterString.

    originalStr BYTE "Original String: ", 0 ; creates a string to be displayed before the original string is displayed

    compressedStr BYTE "Compressed String: ", 0 ; creates a string to be displayed before the compressed string is displayed

    errorMessage BYTE "Please re-enter the value.  ", 0 ; creates a request to re-enter a value string

    tryAgainStr BYTE "Would you like to enter a new string? (y/n)? ", 0 ; creates a request to run the program again string

    answer BYTE 2 DUP(0) ; creates an array to hold the response to tryAgainStr. this includes the null terminator

; **********************************************************************;
; Functional description of the main program
;   Inputs: The main program does not require any user inputs directly. The user may input values to answer any outputted prompts.
;	Outputs: The main program does not output anything directly. The main program displays prompts for the user.
;	Registers used and associated purpose of each:
;       ESI - This is the Extended Source Index. This register is used to keep track of iteration through strings and arrays.
;       EDX - This is the Extended Data register. This register is used to store the offset for strings.
;       EAX - This is the Extended Accumulator register. This register is used to store integers as well as any
;             calculations. This is also being used to store color values.
;       AL - This is the Accumulator Low register. This register is used to store characters.
;       ECX - This is the Extended Count register. This register is used to keep track of the amount of iterations left in a loop.
;             it is also used to store how sizes of arrays for procedures such as WriteString.
;       EDI - This is the Extended Destination Index. This register is used for iterating through strings while another string
;             is already being iterated.
;	Memory locations use and associated purpose of each
;       promptEnterStr - This is a string of the BYTE data type, which is used to prompt the user to enter a string of 100 characters or less.
;       enterString - This is an array of 101 unitialized values, each of the BYTE data type, which is used to hold a user-inputted 100 character string.
;       copiedString - This an array if 101 uninitialized values, each of the BYTE data type, which is used to hold a copy of the enterString string.
;       originalStr - This is a string of the BYTE data type, which is used to inform the user that the next string they will read is the original string.
;       compressedStr - This is a string of the BYTE data type, which is used to inform the user that the next string they will read is compressed.
;       errorMessage - This is a string of the BYTE data type, which prompts the user to re-enter a value. 
;       tryAgainStr - This is a string of the BYTE data type, which prompts the user to determine whether they'd like to run the program again. 
;       answer - This is an array of 2 values, initialized as 0, of the BYTE data type. This array is used to store the response to the tryAgainStr.
;	Functional details: The main program calls the StringCompression procedure, which handles any outputs and inputs.
; **********************************************************************;

.code

;***********************************
; Description: This procedure prompts the user to enter a string of 100 characters or less, then it compresses that string
;              by removing any characters that are not letters. Next, it outputs the original and and compressed string. Finally, 
;              the procedure asks the user if they would like to try the program again.
; Receives: This procedure does not directly recieve anything. However, the user must input strings and characters for the
;           procedure to utilize.
; Returns: This procedure does not directly return anything. However, there are strings that are outputted to the console.
; Requires: This procedure requires the Irvine32 library.
;***********************************
StringCompression PROC
    Prompting: ; this label prompts the user to enter a 100 character string.
        mov edx, OFFSET promptEnterStr ; the index offset of the string promptEnterStr
        call WriteString ; this displays a string from the edx offset
        call Crlf ; new line
        mov edx, OFFSET enterString ; the index offset of the string enterString
        mov ecx, SIZEOF enterString ; the maximum number of characters that can be stored
        call ReadString ; read a string from input and save it into enterString

        ; the below line was suggested by California State University Dominguez Hills
        ; the source is: https://csc.csudh.edu/mmccullough/asm/help/source/irvinelib/str_copy.htm
        ; the INVOKE is a easier way to call a procedure with parameters.
        ; the ADDR is a safer way to get the offset of a variable when using INVOKE.
        ; the general format is: invoke procedureName, source, target
        INVOKE Str_copy, ADDR enterString, ADDR copiedString

        call Crlf ; new line

        jmp RemoveNonChar ; jump to the RemoveNonChar label

    RemoveNonChar: ; this label removes any characters that are not alphabetical
       mov esi, 0 ; start at the first character in the string

       L1:
            mov al, enterString[esi] ; set al with the current character in the string

            cmp al, 0 ; set a flag if al is the null terminator
            je Finish ; if the zero flag is set, jump to the Finish label
            
            .IF (al >= 'A' && al <= 'Z') || (al >= 'a' && al <= 'z') ; if al is an alphabetical character
                inc esi ; move to the next character

            .ELSE ; if al is not an alphabetical character
                mov edi, esi ; set edi to the current index of the string

                ShiftLeft: ; this labal shifts the entire string to the left whenever a character is removed
                    mov al, enterString[edi+1] ; take the index after current
                    mov enterString[edi], al ; set the current with the index after current
                    inc edi ; move to the next index
                    cmp al, 0 ; set a flag if the character that was just moved was the null terminator
                    jne ShiftLeft ; if the flag was not thrown, then restart the ShiftLeft label
            .ENDIF

            jmp L1 ; using jmp instead of loop because a condition, je Finish, is being used within L1

    Finish: ; this label displays the original string, the compressed string, and prompts the user to enter another string
        mov edx, OFFSET originalStr ; this prepares the string originalStr to be displayed
        call WriteString ; this displays a string from the edx offset

        mov eax, lightBlue + (black * 16) ; this sets the color of the text to blue and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        mov edx, OFFSET copiedString ; this prepares the string copiedString to be displayed
        call WriteString ; this displays a string from the edx offset
        call Crlf ; new line

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        mov edx, OFFSET compressedStr ; this prepares the string compressedStr to be displayed
        call WriteString ; this displays a string from the edx offset

        mov eax, lightBlue + (black * 16) ; this sets the color of the text to blue and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        mov edx, OFFSET enterString ; this prepares the string enterString to be displayed
        call WriteString ; this displays a string from the edx offset
        call Crlf ; new line

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax
        
        jmp TryAgain ; this jumps to the TryAgain label

    TryAgain: ; this label prompts the user to decide whether they'd like to continue the program or not
        call Crlf ; new line
        mov edx, OFFSET tryAgainStr ; prepares the string tryAgainStr to be displayed
        call WriteString ; this displays a string from edx
            
        mov edx, OFFSET answer ; this selects the array answer to be filled with a string
        mov ecx, SIZEOF answer ; this sets the size of the answer to 2. this includes the character y or n, as well as the
                               ; null terminator
        call ReadString ; this reads a string then saves the input in the edx offset

        .IF answer[0] == 'y' || answer[0] == 'Y' ; if the answer is yes
            call Crlf ; new line 
            jmp Prompting ; jump to the prompting label
        .ELSEIF answer[0] == 'n' || answer[0] == 'N' ; if the answer is no
            ret ; end the program
        .ELSE ; if the answer is not yes or no
            mov edx, OFFSET errorMessage ; prepares the string errorMessage to be displayed
            call WriteString ; displays a string from the edx offset
            call Crlf ; new line 
            jmp TryAgain ; jump to the TryAgain label
        .ENDIF ; end the if statements

    ret

StringCompression ENDP

main PROC

    call StringCompression ; calls the StringCompression procedure

    INVOKE ExitProcess,0

main ENDP

END main