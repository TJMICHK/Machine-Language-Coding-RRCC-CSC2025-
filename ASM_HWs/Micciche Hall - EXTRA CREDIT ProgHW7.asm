; **********************************************************************;
; Program Name: MASM Float Value Precision Manipulator (EXTRA CREDIT)
; Program Description: This program allows for the precision of a user-inputted value with decimalsto be manipulated.
; Author: Terrence Micciche Hall
; Course: CSC2025X40
; Creation Date: 07/17/26
; Revisions: 0
; Date Last Modified: 07/18/26
; Test Cases:
;   dec 12.34567, prec 1, expected 12.3 - PASS
;   dec 12.36789, prec 2, expected 12.37 - PASS
;   dec 12.34567, prec 3, expected 12.346 - PASS
;   dec 12.34565, prec 4, expected 12.3457 - PASS
;   dec 0.99995, prec 4, expected 1.0000 - PASS
;   dec 9.99995, prec 4, expected 10.0000 - PASS
;   dec 99.99995, prec 4, expected 100.0000 - PASS
;   dec .12345, prec 2, expected 0.12 - PASS
;   dec .99995, prec 4, expected 1.0000 - PASS
;   dec 0.00004, prec 4, expected 0.0000 - PASS
;   dec 999999.99995, prec 4, expected 1000000.0000 - PASS
; Notable Bugs:
;   1. When typing a decimal value with no whole integers, such as .12345 or .98765,
;      there is unexpected new line behavior.
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
    promptErrorDecimal BYTE "You have entered an invalid decimal value. Please re-enter your decimal value.", 0 ; this declares that the user entered an invalid decimal, then it prompts
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

    inputDecVal BYTE 64 DUP(0) ; this is an array of the BYTE data type meant to hold the user-inputted decimal value. this array is initialized with all 0s.
    
    manipulatedDecVal BYTE 64 DUP(0) ; this is an array of the BYTE data type meant to hold the manipulated decimal value. this array is initialized with all 0s.


    inputPrecVal DWORD 1 ; this is a variable of the DWORD data type used for storing integer precision values

    decimalPlace DWORD ? ; this is a variable of the DWORD data type used to save the position of the decimal ('.') in the user-inputted decimal value
    inputLength DWORD ? ; this is a variable of the DWORD data type used to save the length of the user-inputted decimal value

    carryBool DWORD 0 ; this is a variable of the DWORD data type used to account for rounding whole numbers

    answer BYTE 2 DUP(0) ; this is an initialized array of DWORD elements. the elements are initialized to 0, and they are used to keep track
                         ; of the response to the TryAgain label as well as the null terminator.

; **********************************************************************;
; Functional description of the main program
;   
;   Inputs: The user will input values for the program to manipulate.
;
;   Outputs: The program will display any manipulated user-inputted values.
;
;	Registers used and associated purpose of each:
;       ESI - This is the Extended Source Index register. This register is used as a pointer to the source of string operations and for string
;             iteration.
;       EBX - This is the Extended Base register. This register is used for basic arithmetic.
;       BL - This is the Base Low register. This register is used for holding characters.
;       AL - This is the Accumulator Low register. This register is used for holding characters.
;       ECX - This is the Extended Count register. This register is used as a pointer to the source of string operations and for string
;             iteration.
;       CL - This is the Count Low register. This register is used for holding characters.
;       EAX - Ths is the Extended Accumulator register. This register is used for basic arithmetic.
;       EDX - This is the Extended Data register. This register is used for storing the offset of strings to be displayed and for string
;             iteration.
;	Memory locations use and associated purpose of each:
;       promptEnter - This is a string used for prompting the user to enter a decimal number with atleast 5 decimal places.
;       promptPrecision - This is a string used for prompting the user to enter a precision value between 1 and 4
;       displayChosenDec - This is a string used to display the user-inputted decimal value.
;       displayChosenPrec - This is a string used to display the user-inputted precision value.
;       displayDecimal - This is a string used to display the user-inputted decimal value.
;       displayPrecision - this is a string used to display the user-inputted precsion value.
;       promptTryAgain - This is a string used to prompt the user to make the decision of whether or not they'd like to run the program again.
;       promptErrorDecimal - This is a stirng used to inform the user that the decimal value they entered is invalid. It then prompts the user to re-enter their value.
;       promptErrorPrecision - This is a string used to inform the user that the precision value they entered is invalid. It then prompts the user to re-enter their value.
;       promptErrorTry - This is a string used to inform the user that their response to the TryAgain label is invalid. It then prompts the user to re-enter their response.
;       inputDecVal - This is an array meant to hold the user-inputted decimal value.
;       manipulatedDecVal - This is an array meant to hold the manipulated decimal value.
;       inputPrecVal - This is a variable used for storing the user-inputted precision value.
;       decimalPlace - This is a variable used for holding the position of the decimal ('.') within the user-inputted decimal value.
;       inputLength - This is a variable used for holding the length of the user-inputted decimal value.
;       carryBool - This is a variable used as a the equivalent of a C++ "bool" with the purpose of remembering if a whole value needs to be rounded.
;       answer - This is an array that is used to hold the user's response to the TryAgain label.
;	Functional details: 
;       This program prompts the user for a value with equal to or greater than 5 decimal places as well as a the precision value. 
;       Then, this procedure checks to ensure that the inputted values are valid. If not, an error is displayed to the screen and
;       the user is prompted to restart. These values are then displayed. After this, the procedure PrecManip is utilized to handle
;       rounding and input manipulation. Next, the manipulated value is displayed for the screen. Finally, the user is prompted to
;       determine whether they'd like to restart the program or not.
; **********************************************************************;

.code

;***********************************
; Description: This procedure handles all of the rounding, whether fractional or whole, of the user-inputted value.
;              In addition to this, this label handles the manipulation of the user-inputted value for later display.
; Receives: This procedure recieves the array inputDecVal, the variable carryBool, the variable decimalPlace, and
;           the variable inputPrecVal.
; Returns: This procedure returns the array manipulatedDecVal.
; Requires: This prodedure requires the Irvine32 library.
;***********************************
PrecManip PROC
    mov esi, decimalPlace ; set esi equal to the variable decimalPlace

    add esi, inputPrecVal ; add the value of the variable inputPrecVal to esi

    inc esi ; increase esi by 1
    
    mov ebx, 0 ; set ebx equal to 0

    mov bl, '0' ; set bl equal to the char '0'
    mov al, '.' ; set al equal to the char '.'

    mov ecx, 0 ; set ecx equal to 0

    mov cl, inputDecVal[esi] ; set cl equal to the first char in inputDecVal
    sub cl, bl ; convert the first char to an integer

    RoundingUp: ; this label is used to determine whether or not rounding will occur with the user-inputted value
        .IF cl >= 5 ; if cl is greater than or equal to 5
            dec esi ; decrease esi by 1
            jmp RoundingUp2 ; jump to the RoundingUp2 label
        .ELSE ; otherwise
            jmp MoveArray ; jump to the MoveArray label
        .ENDIF

    RoundingUp2: ; this label is used to round values in the user-inputted value
        cmp inputDecVal[esi], al ; compare the value before the rounded value to '.'
        je DecimalRound ; jump to the DecimalRound label if they are equal

        mov cl, inputDecVal[esi] ; set cl equal to the value before the rounded value
        sub cl, bl ; convert cl to an integer

        inc cl ; increase the value of cl by 1

        .IF cl > 9 ; if cl is greater than 9
            mov inputDecVal[esi], bl ; set the value equal to 0
            dec esi ; decrease esi by 1
            jmp RoundingUp2 ; loop the RoundingUp2 label
        .ELSEIF cl >= 0 && cl <=9 ; otherwise, if cl is between 0 and 9
            add cl, bl ; convert cl to a char
            mov inputDecVal[esi], cl ; set the value equal to the char
            jmp MoveArray ; jump to the MoveArray label
        .ENDIF

    DecimalRound: ; this label is used for rounding the whole numbers
        mov esi, decimalPlace ; set esi equal to the position of the decimal ('.') in the user-inputted value
        dec esi ; decrease esi by 1

        DecimalRound2: ; this label is used for looping for extended rounding
            mov cl, inputDecVal[esi] ; set cl equal to the value within inputDecVal at the position of esi
            sub cl, bl ; convert cl to an integer 
        
            .IF cl >= 9 && esi == 0 ; if cl is greater than 9 and this is the first value of the string
                inc carryBool ; activate the carryBool condition
                jmp MoveArray ; jump to the MoveArray lavel
            .ELSEIF cl >= 9 ; else if cl is greater than or equal to 9
                mov inputDecVal[esi], bl ; set the value within inputDecVal at the position of esi equal to 0
                dec esi ; decrease esi by 1
                jmp DecimalRound2 ; loop the DecimalRound2 label
            .ELSEIF cl >= 0 && cl < 9 ; if cl is between 0 and 9
                inc cl ; increase cl 
                add cl, bl ; convert cl to a char
                mov inputDecVal[esi], cl ; set the value within inputDecVal at the position of esi equal to cl
                jmp MoveArray ; jump to the MoveArray label
            .ENDIF
            
    MoveArray: ; this label is used for creating the manipulatedDecVal array for displaying

        mov ebx, 0 ; set ebx equal to 0
        inc ebx ; account for decimal. increase ebx by 1
        add ebx, decimalPlace ; add the value of the variable decimalPlace to ebx
        add ebx, inputPrecVal ; add the value of the variable inputPrecVal to ebx

        mov al, '0' ; set al equal to the '0' char

        mov esi, 0 ; set esi equal to 0
        
        .IF carryBool == 1 ; if the carryBool is true
            mov inputDecVal[esi], al ; set the value within inputDecVal at the position of esi equal to '0'
            jmp CarryArray ; jump to the CarryArray label
        .ENDIF

        .WHILE esi < ebx ; while the value of position given by the value of esi is less than the total amount of chars to
                         ; be copied given by the value of ebx
            mov cl, inputDecVal[esi] ; set cl equal to the value within inputDecVal at the position of esi
            mov manipulatedDecVal[esi], cl ; set the value within manipulatedDecVal at the position of esi equal to cl
            inc esi ; increase esi by 1
        .ENDW

        ret

        CarryArray: ; this label is used for the case where a whole number needs to be rounded
            dec carryBool ; set carryBool to false 

            mov al, '1' ; set al equal to the char '1'
            mov manipulatedDecVal[esi], al ; carry the 1. put the '1' in the first position of the string

            inc esi ; increases the manipulatedDecVal position pointer by 1

            mov edx, 0 ; set edx counter to 0
            mov eax, 0 ; set inputDecVal positon pointer to 0

            .WHILE eax < ebx ; while the inputDecVval position pointer eax is less than the manipulatedDecVal position pointer ebx
                mov cl, inputDecVal[eax] ; set cl equal to the value within inputDecVal at the position eax
                mov manipulatedDecVal[esi], cl ; set the value within manipulatedDecVal at the position esi equal to cl

                inc eax ; increase eax by 1
                inc esi ; increase esi by 1
            .ENDW

            ret


PrecManip ENDP

;***********************************
; Description: This procedure handles the entire program, from input to display.
; Receives: This procedure does not directly recieve anything
; Returns: This procedure does not directly return anything.
; Requires: This procedure requires the Irvine32 library and the PrecManip procedure.
;***********************************
MainProgram PROC
    
    EnterDecimal: ; this prompts the user to enter a decimal value of up to 5 decimal placed value. it then saves that value
        mov edx, OFFSET promptEnter ; this prepares the string promptEnter to be displayed
        call WriteString ; this displays the string promptEnter
        
        mov eax, lightBlue + (black * 16) ; this sets the color of the text to light blue and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        mov edx, OFFSET inputDecVal ; prepare the string inputDecVal to be inputted into
        mov ecx, SIZEOF inputDecVal ; set how any characters can be inputted into the string inputDecVal

        call ReadString ; input a string into inputDecVal

        mov inputLength, eax ; save the length of the user-inputted value
        
        CheckDecimal: ; this label is used to check the user-inputted value for any errors
            mov ecx, 0 ; set ecx equal to 0
            mov esi, 0 ; set esi equal to 0

            mov eax, inputLength ; set eax equal to the variable inputLength

            .WHILE ecx < eax ; while ecx is less than eax
                .IF (inputDecVal[ecx] < '0' || inputDecVal[ecx] > '9') && inputDecVal[ecx] != '.' ; is the value within inputDecVal at the 
                                                                                                  ; position ecx is not between 0 and 9, and is
                                                                                                  ; not a decimal
                    jmp DecimalError ; jump to the DecimalError label
                .ENDIF

                inc ecx ; increase ecx by 1
            .ENDW

            mov ecx, 0 ; set ecx equal to 0

            cmp inputDecVal[esi], '.' ; if the first value is a decimal
            je FirstValueIsDecimal ; jump to the FirstValueIsDecimal

            CheckDecimal2: ; this label is used to find a decimal in the user-inputted value
                mov al, '.' ; set al equal to the char '.'

                mov ecx, 0 ; set ecx equal to 0
                mov esi, 0 ; set esi equal to 0
                mov edx, 0 ; set edx equal to 0
                
                .WHILE esi < inputLength ; while esi is less than the variable inputLength
                    .IF inputDecVal[esi] == al ; if the value within inputDecVal is equal to al
                        inc edx ; increase edx by 1
                    .ENDIF

                    inc esi
                .ENDW
                
                cmp edx, 1 ; compare edx to 1
                jg DecimalError ; jump to the DecimalError label is edx is greater than 1

                mov ecx, 0 ; set ecx equal to 0
                mov esi, 0 ; set esi equal to 0
                mov edx, 0 ; set edx equal to 0

                .WHILE ecx < inputLength ; while ecx is less than the variable inputLength
                    cmp inputDecVal[esi], '.' ; compare the value within inputDecVal at the position esi to the char '.'
                    je DecimalFound ; if the two values are equal, jump to the DecimalFound label

                    cmp inputDecVal[esi], 0 ; compare the value within inputDecVal at the position esi to the null terminator
                    je DecimalError ; if the null terminator is found before a decimal is found, jump to the DecimalError label

                    inc ecx ; increase ecx by 1
                    inc esi ; increase esi by 1
                .ENDW

            DecimalFound: ; this label is used for saving the position of the decimal ('.') and then counting how many fractional values are in
                          ; the user-inputted value
                mov decimalPlace, esi ; set the variable decimalPlace equal to esi
                inc esi ; increase esi by 1

                mov eax, inputLength ; set eax equal to the variable inputLength

                sub eax, esi ; subtract esi from esi

                mov ecx, 0 ; set ecx equal to 0

                .WHILE ecx < eax ; while ecx is less than eax
                    cmp inputDecVal[esi], 0 ; compare the value within inputDecVal at the position esi to the null terminator
                    je EndOfString ; if the null terminator is found, jump to the EndOfString label

                    inc ecx ; increase ecx by 1
                    inc esi ; increase esi by 1
                .ENDW

            EndOfString: ; this string is used to detemrine if the fractional values in the user-inputted value is less than 5
                cmp ecx, 5 ; compare ecx to 5
                jl DecimalError ; if ecx is less than 5, jump to the DecimalError value

                call Crlf ; new line

                jmp DisplayChosenDecimal ; jump to the DisplayChosenDecimal label


            DecimalError: ; this label is used to inform the user that the decimal value they entered is invalid
                call Crlf ; new line

                mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov edx, OFFSET promptErrorDecimal ; this prepares the string promptErrorDecimal to be displayed
                call WriteString ; this displays the string promptErrorDecimal

                mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                call Crlf ; new line
                call Crlf ; new line

                jmp EnterDecimal ; this jumps to the EnterDecimal label

            FirstValueIsDecimal: ; this label is used to deal with the case that the first value of the user-inputted value is a decimal '.'
                inc inputLength ; increase inputLength by 1

                mov esi, 0 ; set esi equal to 0

                mov al, '0' ; set al equal to the char '0'
                mov bl, inputDecVal[esi] ; set bl equal to the value within inputDecVal at the position esi

                mov inputDecVal[esi], al ; set the value witihn inputDecVal at the position esi equal to al

                inc esi ; increase esi by 1

                .WHILE esi < inputLength ; while esi is less than the varaible inputLength. this loop shifts every character in the array inputDecVal
                                         ; one to the right, then adds a zero to the beginning of the array.
                    
                    mov cl, inputDecVal[esi] ; set cl equal to the value within inputDecVal at the position esi
                    mov inputDecVal[esi], bl ; set the value within inputDecVal at the position esi equal to bl
                    mov bl, cl ; set bl equal to cl

                    inc esi ; increase esi by 1
                .ENDW
                
                jmp CheckDecimal2 ; jump to the CheckDecimal2 label

    DisplayChosenDecimal: ; this label displays the float value from the previous label
        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        mov edx, OFFSET displayChosenDec ; this prepares the string displayChosenDec to be displayed
        call WriteString ; this displays the string displayChosenDec

        mov eax, lightBlue + (black * 16) ; this sets the color of the text to light blue and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        mov edx, OFFSET inputDecVal ; prepare the string inputDecVal to be displayed
        call WriteString ; display the string inputDecVal

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        call Crlf ; new line
        call Crlf ; new line

    EnterPrecision: ; this label prompts the user to enter a decimal value, then saves that decimal value
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

    DisplayChosenPrecision: ; this label displays the decimal value from the previous label
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

        mov edx, OFFSET inputDecVal ; prepare the string inputDecVal to be displayed
        call WriteString ; display the string inputDecVal

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

        call PrecManip ; this calls the procedure PrecManip

        mov eax, lightBlue + (black * 16) ; this sets the color of the text to light blue and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        mov edx, OFFSET manipulatedDecVal ; prepare the string manipulatedDecVal to be displayed
        call WriteString ; display the string manipulatedDecVal

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

        mov edx, OFFSET promptTryAgain ; prepares the string promptTryAgain to be displayed
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

            jmp ClearArrays ; jump to the ClearArrays label
        .ELSEIF answer[0] == 'n' || answer[0] == 'N' ; if the answer is no
            jmp EndProgram ; jump to the EndProgram label
        .ELSE ; if the answer is not yes or no
            call Crlf ; new line 

            mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
            call SetTextColor ; this sets the text color to the value in eax
            
            mov edx, OFFSET promptErrorTry ; prepares the string promptErrorTry to be displayed
            call WriteString ; displays a string from the edx offset

            mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
            call SetTextColor ; this sets the text color to the value in eax

            call Crlf ; new line 
            jmp TryAgain ; jump to the TryAgain label
        .ENDIF ; end the if statements

    ClearArrays: ; this label is used to clear the arrays inputDecVal and manipulatedDecVal
        mov ecx, 0 ; set ecx equal to 0
        mov esi, 0 ; set esi equal to 0
        mov al, 0 ; set al equal to 0

        .WHILE ecx < LENGTHOF inputDecVal ; while ecx is less than the length of inputDecVal
            mov inputDecVal[ecx], al ; set the value within inputDecVal at the position ecx equal to al
            mov manipulatedDecVal[ecx], al ; set the value within inputDecVal at the position ecx equal to al

            inc ecx ; increase ecx by 1
        .ENDW

        jmp EnterDecimal

    EndProgram:
        ret ; end the MainProgram procedure and return to the main procedure

MainProgram ENDP

main PROC

    call MainProgram ; run the MainProgram procedure.

    INVOKE ExitProcess,0

main ENDP

END main
