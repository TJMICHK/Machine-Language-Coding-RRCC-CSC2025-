; **********************************************************************;
; Program Name: 32-Bit Value Converter
; Program Description: A program that converts 32-bit values into decimal, hexadecimal, and binary.
; Author: Terrence Micciche Hall
; Course: CSC2025X40
; Creation Date: 07/09/26
; Revisions: 0
; Date Last Modified: 07/11/26
; Test Cases:
;       hex, FFFFFFFF - PASS
;       hex, 10000000 - PASS
;       hex, 00100100 - PASS
;       hex, 0000 - PASS
;       hex, 1111 - PASS
;       hex, ABCDEF12 - PASS
;       hex, 1 - PASS
;       hex, 0 - PASS
;       hex, more than 8 1s - FAIL, NO ERROR THROWN (WITH SPACES)
;       bin, all 1 - PASS
;       bin, middle 1s - PASS
;       bin, edge 1s - PASS
;       bin, 8 bytes of 1s - PASS
;       bin, 1 byte of 1 - PASS
;       bin, 1 byte of 0 - PASS
;       bin, more than 32 1s - PASS
;       dec, 1 - PASS
;       dec, max val - PASS
;       dec, 0 - PASS
;       dec, negative 1 - PASS
;       dec, negative max - PASS
; Notable Bugs:
;       The known bug of this program is the procedure's inability to throw
;       an error when the user inputs more than the necessary amount of characters
;       for a 32-bit hex or binary value (when including spaces). If no spaces are used,
;       then the error state is achieved.
;
;       This bug does not effect the correctness of the procedure however, as it comes 
;       from a basic limitation of static strings in MASM. Because the ReadInt call needs
;       a value to specify how many characters will be stored in it, the program doesn't
;       really "know" if the user entered more values or not. The extra values are simply
;       not considered.
;
;       This bug can be fixed by allowing for a greater maximum of characters to enter
;       any of the strings, however because this bug does not effect the functionality
;       of the program whatsoever, it will not be implemented.
;   
;       Please note that this bug is only apparent when including spaces to separate
;       hexadecimal or binary values. In addition to this, there are some cases when this
;       error is not apparent.


;***********************************************************************;

INCLUDE C:\Irvine\Irvine32.inc
INCLUDELIB C:\Irvine\Irvine32.lib

.data

    ;*************************************
    ; THE DATA BELOW ARE OUTPUT STRINGS. THESE STRINGS ARE USED FOR PROMPTING
    ; THE USER.
    ;*************************************

    decimalStr BYTE "           (1) Decimal", 0 ; this creates a string to let the user know that they can select the decimal option.
    hexadecimalStr BYTE "           (2) Hexadecimal", 0 ; this creates a string to let the user know that they can select the hexadecimal option.
    binaryStr BYTE "           (3) Binary", 0 ; this creates a string to let the user know that they can select the binary option.
    exitStr BYTE "           (4) Exit", 0 ; this creates a string to let the user know that they can select the exit option.

    titleStr BYTE "32-Bit Value Converter:", 0 ; this is a string to display the title of the program to the user.

    menuOptStr BYTE "Please choose one of the menu options: ", 0 ; this creates a string to prompt the user to choose one of the menu options.

    enterDecStr BYTE "Please enter a 32-bit Decimal Integer: ", 0 ; this creates a string to prompt the user to enter a 32-bit decimal integer. 
    enterHexStr BYTE "Please enter a 32-bit Hexadecimal Value: ", 0 ; this creates a string to prompt the user to enter a 32-bit hexadecimal integer.
    enterBinStr BYTE "Please enter a 32-bit Binary Value: ", 0 ; this creates a string to prompt the user to enter a 32-bit binary integer.

    conversionStr BYTE "Conversion Results:", 0 ; this creates a string to let the user know that the following outputs are the conversion results.

    decimalValStr BYTE "    Decimal Value: ", 0 ; this creates a string to let the user know what the decimal value is.
    hexValStr BYTE "    Hexadecimal Value: ", 0 ; this creates a string to let the user know what the hexadecimal value is.
    binValStr BYTE "    Binary Value: ", 0 ; this creates a string to let the user know what the binary value is.
    
    tooBigStr BYTE "The number you entered is too big. Please try again.", 0 ; this creates a string to let the user know that the number they entered is too big and to try again.

    errorValMessage BYTE "You have entered an invalid value. Please check your value and try again.", 0 ; this is a string to inform the user that they entered an invalid value.
                                                                                                        ; the user is then prompted to re-enter their value.

    tryAgainStr BYTE "Would you like to try again? (y/n)? ", 0 ; this creates a string to prompt the user to decide whether they'd like to continue the program or not.

    ;*************************************
    ; THE DATA BELOW ARE INPUT VARIABLES AND ARRAYS. THIS DATA IS USED FOR
    ; HOLDING USER INPUTTED DATA.
    ;*************************************

    inputHexArray BYTE 10 DUP(0) ; this is an initialized array of BYTE elements. the elements are initialized to 0, and they are used to hold the 
                                 ; hexadecimal input from the user. there is extra space for spaces and the null terminator.

    inputBinArray BYTE 40 DUP(0) ; this is an initialized array of BYTE elements. the elements are initialized to 0, and they are used to hold the 
                                 ; binary input from the user. there is extra space for spaces and the null terminator.

    binArray BYTE 33 DUP(0) ; this is an initialized array of BYTE elements. the elements are initialized to 0, and they are used to hold the adjusted
                            ; binary input from the user. there is an extra space for the null terminator.

    hexArray BYTE 9 DUP(0) ; this is an initialized array of BYTE elements. the elements are initialized to 0, and they are used to hold the adjusted
                           ; hexadecimal input from the user. there is an extra space for the null terminator.


    answer BYTE 2 DUP(0) ; this is an initialized array of DWORD elements. the elements are initialized to 0, and they are used to keep track
                         ; of the response to the TryAgain label as well as the null terminator.

    decValue DWORD ? ; this is an uninitialized DWORD variable that is used to hold a decimal value.
    
    hexValue DWORD ? ; this is an uninitialized DWORD variable that is used to hold a hexadecimal value.

    binValue DWORD ? ; this is an uninitialized DWORD variable that is used to hold a binary value.

    lowerToUpper BYTE 32 ; this is an initialized BYTE variable that is used to convert lower case letters to upper case.



; **********************************************************************;
; Functional description of the main program
;   
;   Inputs: The user will be able to input 32-bit values to be converted.
;
;   Outputs: The user will be prompted to input 32-bit values to be converted.
;
;	Registers used and associated purpose of each:
;       EDX - This is the Extended Data register. This register is used to store the offset for strings and sometimes used as a pointer and a counter.
;	    EAX - This is the Extended Accumulator register. This register is used to store the result of mathematical operations and sometimes used as a pointer and a counter.
;       ESP - This is the Extended Stack Pointer register. This register is used to point to the top of the stack. While not directly used in this function, push
;             and pop instructions will modify this register.
;       ECX - This is the Extended Counter register. This register is used as a loop counter and for string operations.
;       ESI - This is the Extended Source Index register. This register is used as a pointer to the source of string operations.
;       BL - This is the Base Low of EBX register. This register is used for storing characters and byte-level operations
;       AL - This is the Bottom Byte of EAX register. This register is used for storing characters and byte-level operations.
;       EBX - This is the Extended Base register. This is used to store the result of mathematical operations.
;       EDI - This is the Extended Destination Index register. This is used to store the length of arrays.
;       
;	Memory locations use and associated purpose of each
;       decimalStr - this is a string that is used to display the decimal option to the user.
;       hexadecimalStr - this is a string that is used to display the hexadecimal option to the user.
;       binaryStr - this is a string that is used to display the binary option to the user.
;       exitStr - this is a string that is used to display the exit option to the user.
;       titleStr - this is a string that is used to display the title of the program to the user.
;       menuOptStr - this is a string that is used to inform the user to choose one of the options.
;       enterDecStr - this is a string that is used to tell the user to enter a 32-bit decimal integer.
;       enterHexStr - this is a string that is used to tell the user to enter a 32-bit hexadecimal integer.
;       enterBinStr - this is a string that is used to tell the user to enter a 32-bit binary integer.
;       conversionStr - this is a string that is used to display the conversion results.
;       decimalValStr - this is a string that is used to display the decimal value.
;       hexValStr - this is a string that is used to display the hexadecimal value.
;       binValStr - this is a string that is used to display the binary value.
;       tooBigStr - this is a string that is used to inform the user that the entered value is too large.
;       errorValMessage - this is a string that is used to display an error message for invalid input.
;       tryAgainStr - this is a string that is used to prompt the user to try again.
;       inputHexArray - this is an array that is used to hold the hexadecimal input from the user.
;       inputBinArray - this is an array that is used to hold the binary input from the user.
;       binArray - this is an array that is used to hold the parsed binary input from the user.
;       hexArray - this is an array that is used to hold the parsed hexadecimal input from the user.
;       answer - this is an array that is used to hold the user's response to the TryAgain prompt.
;       decValue - this is a variable that is used to hold a decimal value.
;       hexValue - this is a variable that is used to hold a hexadecimal value.
;       binValue - this is a variable that is used to hold a binary value.
;       lowerToUpper - this is a varaible that is used to convert lower case characters into upper case characters.
;	Functional details: 
;       The main program is a 32-bit value converter which allows the user to input a 32-bit value in either
;       decimal, hexadecimal, or binary. The program then converts the entered value into the other two forms.
;       The results are then displayed to the user. Finally, the user is prompted to try the program again
;       or to instead exit.
;
; **********************************************************************;

.code

;***********************************
; Description: This procedure informs the user of the menu options, allows the user to choose an option and to input
;              a value, and then that value is converted to the other two options. Finally, the results of the conversion
;              are then displayed to the user. The user is then prompted to try the program again or to exit.
;
;              As a note, there are error messages that are displayed if the user enters an invalid value. Also,
;              The hexadecimal or binary input are able to be entered with or without spaces. The program will be able
;              to utilize them regardless.
; Receives: This procedure does not directly receive anything. However, the user will be able to input values during runtime.
; Returns: This procedure does not directly return anything. However, the user will be prompted to input values during runtime.
; Requires: This procedure requires the Irvine32 library.
;***********************************
MainProgram PROC
    ProvideMenuOptions: ; this is a label that is used to provide the user with the menu options.

        mov edx, OFFSET titleStr ; load the address of the titleStr into edx
        call WriteString ; call the WriteString procedure to display the titleStr
        call Crlf ; new line
        call Crlf ; new line
        
        mov edx, OFFSET decimalStr ; load the address of the decimalStr into edx
        call WriteString ; call the WriteString procedure to display the decimalStr
        call Crlf ; new line

        mov edx, OFFSET hexadecimalStr ; load the address of the hexadecimalStr into edx
        call WriteString ; call the WriteString procedure to display the hexadecimalStr
        call Crlf ; new line

        mov edx, OFFSET binaryStr ; load the address of the binaryStr into edx
        call WriteString ; call the WriteString procedure to display the binaryStr
        call Crlf ; new line

        mov edx, OFFSET exitStr ; load the address of the exitStr into edx
        call WriteString ; call the WriteString procedure to display the exitStr
        call Crlf ; new line

    InputChoice:
        
        call Crlf ; new line

        mov edx, OFFSET menuOptStr ; load the address of the menuOptStr into edx
        call WriteString ; call the WriteString procedure to display the menuOptStr

        mov eax, lightBlue + (black * 16) ; this sets the color of the text to blue and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        call readInt ; read the user's input and store it in eax
        jo InvalidInputChoice ; if the user's input is invalid, jump to the InvalidInputChoice label

        push eax ; push the user's input onto the stack

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        pop eax ; pop the user's input from the stack into eax

        cmp eax, 1 ; compare the user's input to 1
        je DecimalInput ; if the user's input is 1, jump to the DecimalInput label
        
        cmp eax, 2 ; compare the user's input to 2
        je HexInput ; if the user's input is 2, jump to the HexInput label

        cmp eax, 3 ; compare the user's input to 3
        je BinInput ; if the user's input is 3, jump to the BinInput label

        cmp eax, 4 ; compare the user's input to 4
        je EndProgram ; if the user's input is 4, jump to the EndProgram label

    InvalidInputChoice:
        mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        call Crlf ; new line

        mov edx, OFFSET errorValMessage ; load the address of the errorValMessage into edx
        call WriteString ; call the WriteString procedure to display the errorValMessage

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        call Crlf ; new line
        call Crlf ; new line
        
        jmp InputChoice ; jump to the InputChoice label

    DecimalInput:
        call Crlf ; new line
        
        mov edx, OFFSET enterDecStr ; load the address of the enterDecStr into edx
        call WriteString ; call the WriteString procedure to display the enterDecStr

        mov eax, lightBlue + (black * 16) ; this sets the color of the text to blue and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        call readInt ; read the user's input and store it in eax
        jo InvalidDec ; if the user's input is invalid, jump to the InvalidDec label

        push eax ; push the user's input onto the stack

        jmp DisplayResults ; jump to the DisplayResults label

        InvalidDec:
            mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
            call SetTextColor ; this sets the text color to the value in eax

            call Crlf ; new line

            mov edx, OFFSET errorValMessage ; load the address of the errorValMessage into edx
            call WriteString ; call the WriteString procedure to display the errorValMessage

            mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
            call SetTextColor ; this sets the text color to the value in eax

            call Crlf ; new line
        
            jmp DecimalInput ; jump to the InputChoice label

    HexInput:
        call Crlf ; new line
        
        mov edx, OFFSET enterHexStr ; load the address of the enterHexStr into edx
        call WriteString ; call the WriteString procedure to display the enterHexStr

        mov eax, lightBlue + (black * 16) ; this sets the color of the text to blue and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        mov edx, OFFSET inputHexArray ; load the address of the inputHexArray into edx
        push edx ; push the address of the inputHexArray onto the stack

        mov ecx, SIZEOF inputHexArray ; load the size of the inputHexArray into ecx

        call readString ; read the user's input and store it in eax

        mov ebx, eax ; move the number of user's characters into ebx
        
        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        ParseHexInput:

            mov ecx, 0 ; initialize ecx to 0
            mov esi, 0 ; initialize esi to 0
            mov edx, 0 ; initialize edx to 0
            mov al, ' ' ; initialize al to ' '

            .WHILE ecx < ebx ; while the current index is less than the user's character count
                .IF inputHexArray[ecx*TYPE hexArray] == al ; if the character at the current index of the readString is a space
                    inc esi ; increase esi by 1
                .ELSE
                    inc edx
                .ENDIF

                inc ecx ; increase ecx by 1
            .ENDW

            cmp edx, LENGTHOF hexArray ; compare the value in edx to the total length of the array hexArray
            jge InvalidHex ; if the value in edx is greater than or equal to the total length of the array
                           ; hexArray, jump to the InvalidHex label

            mov eax, LENGTHOF hexArray ; move the length of the hexArray into eax
            dec eax ; decrease eax by 1 to account for the null terminator

            sub eax, ebx ; subtract the number of user's characters from the length of the hexArray
            add eax, esi ; add the number of spaces to the result

            mov edx, eax ; move the result into edx

            mov ecx, 0 ; initialize ecx to 0
            mov esi, 0 ; initialize esi to 0

            mov al, '0' ; initialize al to '0'

            .WHILE ecx < edx ; while the current index is less than the number of leading zeros needed
                mov hexArray[esi*TYPE hexArray], al ; move the character in al into the hexArray at the current index
                inc esi ; increase esi by 1
                inc ecx ; increase ecx by 1
            .ENDW

            mov ecx, 0 ; initialize ecx to 0

            pop edx ; pop the address of the inputHexArray from the stack into edx

            .WHILE ecx < ebx ; while the current index is less than the user's character count
                mov al, [edx] ; move the character at the current index of the readString into al

                .IF al >= '0' && al <= '9' || al >= 'A' && al <= 'F' ; if the character is a hex character
                    mov hexArray[esi*TYPE hexArray], al ; move the character in al into the hexArray at the current index    
                    inc edx ; increase edx by 1
                    inc esi ; increase esi by 1

                .ELSEIF al >= 'a' && al <= 'f' ; if the character is a lowercase hex character
                    sub al, lowerToUpper ; convert the lowercase letter to uppercase
                    mov hexArray[esi*TYPE hexArray], al ; move the character in al into the hexArray at the current index

                    inc edx ; increase edx by 1 
                    inc esi ; increase esi by 1
                .ELSEIF al == ' ' ; if the character is a space
                    inc edx ; increase edx by 1
                .ELSE ; if the character is not a hex character or space
                    jmp InvalidHex ; jump to the InvalidHex label
                .ENDIF

                inc ecx ; increase ecx by 1
            .ENDW

            mov eax, LENGTHOF hexArray ; move the length of the hexArray into eax
            dec eax ; decrease eax by 1 to account for the null terminator

            cmp esi, eax ; compare the value in esi to the value in eax
            jg InvalidHex ; if the value in esi is greater than the value in eax
                          ; jump to the InvalidHex label

            .IF esi < eax ; if the current index is less than the length of the hexArray
                .WHILE esi < eax ; while the current index is less than the length of the hexArray
                    mov hexArray[esi*TYPE hexArray], '0' ; move the character '0' into the hexArray at the current index
                    inc esi ; increase esi by 1
                .ENDW
            .ENDIF

        ConversionHex: ; this label is used to convert the hexArray into a decimal value.
            
            mov esi, OFFSET hexArray ; move the address of the hexArray into esi
            mov eax, 0 ; initialize eax to 0
            mov ecx, 0 ; initialize ecx to 0
            mov ebx, 0 ; initialize ebx to 0

            mov edi, LENGTHOF hexArray ; move the length of the hexArray into edi
            dec edi ; decrease edi by 1 to account for the null terminator

            .WHILE ecx < edi ; while the current index is less than the length of the hexArray
                mov bl, [esi] ; move the character at the current index of the hexArray into bl

                .IF bl >= '0' && bl <= '9' ; if the character is a decimal character
                    sub bl, '0' ; convert the character to its decimal value
                .ELSE
                    sub bl, 'A' ; convert the character to its decimal value
                    add bl, 10 ; add 10 to the decimal value
                .ENDIF
                
                shl eax, 4 ; multiply the current value in eax by 16 (shift left by 4 bits)

                movzx ebx, bl ; move the decimal value of the current character into ebx
                add eax, ebx ; add the decimal value of the current character to eax

                inc ecx ; increase ecx by 1
                inc esi ; increase esi by 1
            .ENDW

                push eax ; push the user's input onto the stack
                jmp DisplayResults ; jump to the DisplayResults label

        InvalidHex: ; this label is used to handle invalid hex input from the user.
            mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
            call SetTextColor ; this sets the text color to the value in eax

            call Crlf ; new line

            mov edx, OFFSET errorValMessage ; load the address of the errorValMessage into edx
            call WriteString ; call the WriteString procedure to display the errorValMessage

            mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
            call SetTextColor ; this sets the text color to the value in eax

            call Crlf ; new line
        
            jmp HexInput ; jump to the HexInput label

    BinInput: ; this label is used to handle binary input from the user.
        ClearBin:
            mov edx, LENGTHOF inputBinArray
            dec edx

            mov al, '0'

            .WHILE ecx < edx
                mov inputBinArray[ecx*TYPE inputBinArray], al
                inc ecx
            .ENDW
       
        call Crlf ; new line
        
        mov edx, OFFSET enterBinStr ; load the address of the enterBinStr into edx
        call WriteString ; call the WriteString procedure to display the enterBinStr

        mov eax, lightBlue + (black * 16) ; this sets the color of the text to blue and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        mov edx, OFFSET inputBinArray ; load the address of the inputBinArray into edx
        push edx ; push the address of the inputBinArray onto the stack

        mov ecx, SIZEOF inputBinArray ; load the size of the inputBinArray into ecx

        call readString ; read the user's input and store it in eax

        mov ebx, eax ; move the number of user's characters into ebx

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        ParseBinInput: ; this label is used to parse the binary input from the user.
            mov ecx, 0 ; initialize ecx to 0
            mov esi, 0 ; initialize esi to 0
            mov al, ' ' ; initialize al to ' '

            mov edx, LENGTHOF binArray ; move the length of the binArray into eax
            dec edx ; decrease eax by 1 to account for the null terminator

            .WHILE ecx < ebx ; while the current index is less than the user's character count
                .IF inputBinArray[ecx*TYPE binArray] == al ; if the character at the current index of the readString is a space
                    inc esi ; increase esi by 1
                .ENDIF
                
                inc ecx ; increase ecx by 1
            .ENDW

            sub ecx, esi

            cmp ecx, edx ; compare the value in ecx to the value in edx
            jg InvalidBin ; if the value in ecx is greater than the value in edx, jump to the
                          ; InvalidBin label

            mov eax, LENGTHOF binArray ; move the length of the binArray into eax
            dec eax ; decrease eax by 1 to account for the null terminator

            sub eax, ebx ; subtract the number of user's characters from the length of the binArray
            add eax, esi ; add the number of spaces to the result

            mov edx, eax ; move the result into edx

            mov ecx, 0 ; initialize ecx to 0
            mov esi, 0 ; initialize esi to 0
            
            mov al, '0' ; initialize al to '0'

            .WHILE ecx < edx ; while the current index is less than the number of leading zeros needed
                mov binArray[esi*TYPE binArray], al ; move the character in al into the binArray at the current index
                inc esi ; increase esi by 1
                inc ecx ; increase ecx by 1
            .ENDW

            mov ecx, 0 ; initialize ecx to 0

            pop edx ; pop the address of the inputBinArray from the stack into edx

            .WHILE ecx < ebx ; while the current index is less than the user's character count
                mov al, [edx] ; move the character at the current index of the readString into al

                .IF al == '0' || al == '1' ; if the character is a binary character
                    mov binArray[esi*TYPE binArray], al ; move the character in al into the binArray at the current index    
                    inc edx ; increase edx by 1
                    inc esi ; increase esi by 1
                .ELSEIF al == ' ' ; if the character is a space
                    inc edx ; increase edx by 1
                .ELSE ; if the character is not a binary character
                    jmp InvalidBin ; if the character is not a binary character, jump to the InvalidBin label
                .ENDIF

                inc ecx ; increase ecx by 1
            .ENDW

            mov eax, LENGTHOF binArray ; move the length of the binArray into eax
            dec eax ; decrease eax by 1 to account for the null terminator

            .IF esi < eax ; if the current index is less than the length of the binArray
                .WHILE esi < eax ; while the current index is less than the length of the binArray
                    mov binArray[esi*TYPE binArray], '0' ; move the character '0' into the binArray at the current index
                    inc esi ; increase esi by 1
                .ENDW
            .ENDIF
            
        ConversionBin: ; this label is used to convert the binArray into a decimal value.
            
            mov esi, OFFSET binArray ; move the address of the binArray into esi
            mov eax, 0 ; initialize eax to 0
            mov ecx, 0 ; initialize ecx to 0
            mov ebx, 0 ; initialize ebx to 0

            mov edi, LENGTHOF binArray ; move the length of the binArray into edi
            dec edi ; decrease edi by 1 to account for the null terminator

            .WHILE ecx < edi ; while the current index is less than the length of the binArray
                mov bl, [esi] ; move the character at the current index of the binArray into bl

                .IF bl == '0' || bl == '1' ; if the character is a binary character
                    sub bl, '0' ; convert the character to its decimal value
                .ENDIF
                
                shl eax, 1 ; multiply the current value in eax by 2 (shift left by 1 bit)

                movzx ebx, bl ; move the decimal value of the current character into ebx
                add eax, ebx ; add the decimal value of the current character to eax

                inc ecx ; increase ecx by 1
                inc esi ; increase esi by 1
            .ENDW

                push eax ; push the user's input onto the stack

            jmp DisplayResults ; jump to the DisplayResults label

        InvalidBin: ; this label is used to handle invalid binary input from the user.
            mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
            call SetTextColor ; this sets the text color to the value in eax

            call Crlf ; new line

            mov edx, OFFSET errorValMessage ; load the address of the errorValMessage into edx
            call WriteString ; call the WriteString procedure to display the errorValMessage

            mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
            call SetTextColor ; this sets the text color to the value in eax

            call Crlf ; new line
        
            jmp BinInput ; jump to the BinInput label

    DisplayResults: ; this label is used to display the results of the conversion.

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        call Crlf ; new line

        mov edx, OFFSET conversionStr ; load the address of the conversionStr into edx
        call WriteString ; call the WriteString procedure to display the conversionStr

        call Crlf ; new line

        mov edx, OFFSET decimalValStr ; load the address of the decimalValStr into edx
        call WriteString ; call the WriteString procedure to display the decimalValStr

        mov eax, lightBlue + (black * 16) ; this sets the color of the text to blue and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        pop eax ; pop the user's input from the stack into eax

        cmp eax, 0 ; compare the value in eax to 0
        jge PositiveOrZeroDecimal ; jump to the PositiveOrZeroDecimal label is the value in eax is positve

        call WriteInt ; call the WriteInt procedure to display the decimal value of the decimal input
        jmp DisplayResults2 ; jump to the DisplayResults2 label

        PositiveOrZeroDecimal:
            call WriteDec ; call the WriteDec procedure to display the decimal value of the decimal input

    DisplayResults2:

        push eax ; push the user's input onto the stack

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        call Crlf ; new line
        call Crlf ; new line

        mov edx, OFFSET hexValStr ; load the address of the hexValStr into edx
        call WriteString ; call the WriteString procedure to display the hexValStr

        mov eax, lightBlue + (black * 16) ; this sets the color of the text to blue and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        pop eax ; pop the user's input from the stack into eax

        call WriteHex ; call the WriteHex procedure to display the hexadecimal value of the decimal input

        push eax ; push the user's input onto the stack

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        call Crlf ; new line
        call Crlf ; new line

        mov edx, OFFSET binValStr ; load the address of the binValStr into edx
        call WriteString ; call the WriteString procedure to display the binValStr

        mov eax, lightBlue + (black * 16) ; this sets the color of the text to blue and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        pop eax ; pop the user's input from the stack into eax

        call WriteBin ; call the WriteBin procedure to display the binary value of the decimal input

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        call Crlf ; new line

    TryAgain: ; this label prompts the user to decide whether they'd like to continue the program or not
        call Crlf ; new line
        mov edx, OFFSET tryAgainStr ; prepares the string tryAgainStr to be displayed
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

            jmp ProvideMenuOptions ; jump to the ProvideMenuOptions label
        .ELSEIF answer[0] == 'n' || answer[0] == 'N' ; if the answer is no
            jmp EndProgram
        .ELSE ; if the answer is not yes or no
            mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
            call SetTextColor ; this sets the text color to the value in eax
            
            mov edx, OFFSET errorValMessage ; prepares the string errorMessage to be displayed
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
