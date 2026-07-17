; **********************************************************************;
; Program Name: MASM Float Value Precision Manipulator
; Program Description: This program allows for the precision of a user-inputted float value to be manipulated.
; Author: Terrence Micciche Hall
; Course: CSC2025X40
; Creation Date: 07/16/26
; Revisions: 0
; Date Last Modified: 07/16/26
; Test Cases:
;
; Notable Bugs:
;   1. The Irvine32 ReadFloat procedure treats Backspace as an input termination
;   rather than deleting the previous character.
;
;   2. 
;***********************************************************************;

INCLUDE C:\Irvine\Irvine32.inc
INCLUDELIB C:\Irvine\Irvine32.lib

.data

    ;*************************************
    ; THE DATA BELOW ARE OUTPUT STRINGS. THESE STRINGS ARE USED FOR PROMPTING
    ; THE USER.
    ;*************************************

    promptEnter BYTE "Please enter a decimal number with at least 5 decimal places: ", 0 ; this prompts the user to enter a decimal number with atleast 5 decimal places
    promptPrecision BYTE "Please enter a precision value between 1 and 4: ", 0 ; this prompts the user to enter a precision value between 1 and 4

    displayChosenDec BYTE "The number you entered was ", 0 ; this is used to display the users decimal number
    displayChosenPrec BYTE "The selected precision was ", 0 ; this is used to display the users precision value

    displayDecimal BYTE "Original Number: ", 0 ; this is used to display the users decimal number more concisely
    displayPrecision BYTE "Precision - ", 0 ; this is used to display th eusers precision 
    
    promptTryAgain BYTE "Would you like to try again? (y/n)? ", 0 ; this prompt the user to decide whether they'd like to continue the program or not.
    promptErrorDecimal BYTE " You have entered an invalid decimal value. Please re-enter your decimal value.", 0 ; this declares that the user entered an invalid decimal, then it prompts
                                                                                                                 ; the user to re-enter their value
    promptErrorPrecision BYTE "You have entered a precision value that is not 1, 2, 3, or 4. Please re-enter your precision value", 0 ; this declares that the user entered an invalid
                                                                                                                                      ; precision value, then it prompts the user to 
                                                                                                                                      ; re-enter their value
    promptErrorTry BYTE "You have entered an invalid response. Please check your response and try again", 0 ; this declares that the user entered an invalid response, then it prompts
                                                                                                            ; the user to try again

    ;*************************************
    ; THE DATA BELOW ARE INPUT VARIABLES AND ARRAYS. THIS DATA IS USED FOR
    ; HOLDING USER INPUTTED DATA.
    ;*************************************

    inputDecVal REAL8 ? ; this is a variable of the REAL8 data type used for storing float values from input
    manipulatedDecVal REAL8 ? ; this is a variable of the REAL8 data type used for storing float values that have been manipulated
    floatToInt SDWORD ? ; this is a variable of the SDWORD data type used for storing values converted from float to integer

    inputPrecVal DWORD 1 ; this is a variable of the DWORD data type used for storing integer precision values

    defaultVal DWORD 1 ; this is a variable of the DWORD data type used to avoid the use of "magic numbers." the integer 1 is stored
                       ; in this variable
    powerVal DWORD 10 ; this is a variable of the DWORD data type used to avoid the use of "magic numbers." the interger 10 is stored
                      ; in this variable
    scaleVal DWORD ? ; this is a variable of the DWORD data type used to hold a scaled value of 10

    answer BYTE 2 DUP(0) ; this is an initialized array of DWORD elements. the elements are initialized to 0, and they are used to keep track
                         ; of the response to the TryAgain label as well as the null terminator.

; **********************************************************************;
; Functional description of the main program
;   
;   Inputs: 
;
;   Outputs: 
;
;	Registers used and associated purpose of each:
;
;       
;	Memory locations use and associated purpose of each
;
;	Functional details: 
;
; **********************************************************************;

.code

;***********************************
; Description: 
; Receives: 
; Returns: 
; Requires: 
;***********************************
PrecisionManipulator PROC
    fld inputDecVal ; this pushes the float value in inputDecVal onto the stack at position ST(0)

    mov eax, defaultVal ; this sets eax equal to the value in defaultVal
    mov ebx, powerVal ; this sets ebx equal to the value in powerVal
    mov edx, 0 ; this sets edx equal to 0

    mov ecx, inputPrecVal ; this sets ecx equal to the value in inputPrecVal

    .WHILE ecx > 0 ; whle ecx is greater than 0
        mul ebx ; multiply eax by ebx (equivalent to 10^n)
        dec ecx ; decrease ecx
    .ENDW

    mov scaleVal, eax ; save the scaled value from the eax register in the scaleVal variable

    fimul scaleVal ; this allows for mulitplication between ST(0) and the integer scaleVal

    fistp floatToInt ; this converts ST(0) into an integer and stores it in floatToInt

    fild floatToInt ; this converts an integer and converts it to a floating-point value, storing it in ST(0)

    fidiv scaleVal ; this divides the floating-point value in ST(0) by the integer scaleVal

    fstp manipulatedDecVal ; this stores the flaoting-point value in ST(0) in memory

    ret
PrecisionManipulator ENDP

;***********************************
; Description: 
; Receives: 
; Returns: 
; Requires: 
;***********************************
MainProgram PROC
    
    EnterDecimal: ; this prompts the user to enter a float value, then saves that float value
        mov edx, OFFSET promptEnter ; this prepares the string promptEnter to be displayed
        call WriteString ; this displays the string promptEnter
        
        mov eax, lightBlue + (black * 16) ; this sets the color of the text to light blue and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        call ReadFloat ; this allows for a float value to be read from input. this is saved on the stack at ST(0)
                
        fstp inputDecVal ; this stores the read float value from the stack in the variable inputDecVal then pops the stack

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        call Crlf ; new line

    DisplayChosenDecimal: this label displays the float value from the previous label
        mov edx, OFFSET displayChosenDec ; this prepares the string displayChosenDec to be displayed
        call WriteString ; this displays the string displayChosenDec

        mov eax, lightBlue + (black * 16) ; this sets the color of the text to light blue and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        fld inputDecVal ; this loads the float value in inputDecValue onto the stack at ST(0)
        call WriteFloat ; this displays the float value at the top of the stack at ST(0)
        fstp st(0) ; this pops the top of the stack at ST(0) to avoid unexpected stack behavior

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        call Crlf ; new line
        call Crlf ; new line

    EnterPrecision: this label prompts the user to enter a decimal value, then saves that decimal value
        mov edx, OFFSET promptPrecision ; this prepares the string promptPrecision to be displayed
        call WriteString ; this displays promptPrecision

        mov eax, lightBlue + (black * 16) ; this sets the color of the text to light blue and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        call ReadDec ; this reads a decimal value from input and stores it in eax
        
        CheckPrecision: ; this label checks if the decimal entered is between 1 and 4
            jo ErrorInvalidPrecision ; jump if overflow to the ErrorInvalidPrecision label

            cmp eax, 1 ; compare eax to 1
            jl ErrorInvalidPrecision ; jump to the ErrorInvalidPrecision label is eax is less than 1

            cmp eax, 4 ; compare eax to 4
            jg ErrorInvalidPrecision ; jump to the ErrorInvalidPrecision if eax is greater than 4


        mov inputPrecVal, eax ; this saves the value within eax in the variable inputPrecVal

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        call Crlf ; new line

    DisplayChosenPrecision: this label displays the decimal value from the previous label
        mov edx, OFFSET displayChosenPrec ; this prepares the string displayChosenPrec to be displayed
        call WriteString ; this displays the string displayChosenPrec

        mov eax, lightBlue + (black * 16) ; this sets the color of the text to light blue and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        mov eax, inputPrecVal ; this sets eax equal to the value in inputPrecVal

        call WriteDec ; this displays the value in eax

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        call Crlf ; new line
        call Crlf ; new line

    DisplayResults: ; this label displays the results of the precision manipulation
        mov edx, OFFSET displayDecimal ; this prepares the string displayDecimal to be displayed
        call WriteString ; this displays the string displayDecimal

        mov eax, lightBlue + (black * 16) ; this sets the color of the text to light blue and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        fld inputDecVal ; this loads the float value in inputDecValue onto the stack at ST(0)
        call WriteFloat ; this displays the float value at the top of the stack at ST(0)
        fstp st(0) ; this pops the top of the stack at ST(0) to avoid unexpected stack behavior

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        call Crlf ; new line
        call Crlf ; new line

        mov edx, OFFSET displayPrecision ; this prepares the string displayPrecision to be displayed
        call WriteString ; this displays the string displayPrecision

        mov eax, inputPrecVal ; this sets eax equal to the value of the variable inputPrecVal
        call WriteDec ; this displays the value in eax

        mov al, ':' ; this prepares the character ':' to be displayed
        call WriteChar ; this displays the character ':'

        mov al, ' ' ; this prepares the character ' ' to be displayed
        call WriteChar ; this displays the character ' '

        call PrecisionManipulator ; this calls the procedure PrecisionManipulator

        mov eax, lightBlue + (black * 16) ; this sets the color of the text to light blue and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        fld manipulatedDecVal ; this loads the float value in manipulatedDecVal onto the stack at ST(0)
        call WriteFloat ; this displays the float value at the top of the stack at ST(0)
        fstp st(0) ; this pops the top of the stack at ST(0) to avoid unexpected stack behavior

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        call Crlf ; new line

        jmp TryAgain ; jump to the TryAgain label

    ErrorInvalidPrecision: ; this label is ran when the user enters an invalid precision value
        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        call Crlf ; new line

        mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        mov edx, OFFSET promptErrorPrecision ; this prepares the string promptErrorPrecision to be displayed
        call WriteString ; this displays the string promptErrorPrecision

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        call Crlf ; new line
        call Crlf ; new line

        jmp EnterPrecision ; this jumps to the EnterPrecision label

    TryAgain: ; this label prompts the user to decide whether they'd like to continue the program or not
        call Crlf

        mov edx, OFFSET promptTryAgain ; prepares the string tryAgainStr to be displayed
        call WriteString ; this displays a string from edx
            
        mov edx, OFFSET answer ; this selects the array answer to be filled with a string
        mov ecx, SIZEOF answer ; this sets the size of the answer to 2. this includes the character y or n, as well as the
                               ; null terminator
        mov eax, lightBlue + (black * 16) ; this sets the color of the text to blue and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        call ReadString ; this reads a string then saves the input in the edx offset

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        .IF answer[0] == 'y' || answer[0] == 'Y' ; if the answer is yes
            call Crlf ; new line 
            call Crlf ; new line

            jmp EnterDecimal ; jump to the ProvideMenuOptions label
        .ELSEIF answer[0] == 'n' || answer[0] == 'N' ; if the answer is no
            jmp EndProgram
        .ELSE ; if the answer is not yes or no
            call Crlf ; new line 

            mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
            call SetTextColor ; this sets the text color to the value in eax
            
            mov edx, OFFSET promptErrorTry ; prepares the string errorMessage to be displayed
            call WriteString ; displays a string from the edx offset

            mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
            call SetTextColor ; this sets the text color to the value in eax

            call Crlf ; new line 
            jmp TryAgain ; jump to the TryAgain label
        .ENDIF ; end the if statements

    EndProgram:
        ret ; end the MainProgram procedure and return to the main procedure

MainProgram ENDP

main PROC

    call MainProgram ; run the MainProgram procedure.

    INVOKE ExitProcess,0

main ENDP

END main
