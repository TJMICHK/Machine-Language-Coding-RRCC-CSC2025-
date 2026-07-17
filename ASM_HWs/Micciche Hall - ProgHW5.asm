; **********************************************************************;
; Program Name: 16-Bit Integer Calculator
; Program Description: This program takes two 16-Bit signed integers, and performs 4 mathematical calculations, add,
; subtract, multiply, and divide. The results are outputted on the screen for the user to read.
; Author: Terrence Micciche Hall
; Creation Date: 06/20/26
; Revisions: 0
; Date Last Modified: 06/20/26
;***********************************************************************;

INCLUDE C:\Irvine\Irvine32.inc
INCLUDELIB C:\Irvine\Irvine32.lib

.data

    ;*************************************
    ; THE DATA BELOW ARE OUTPUT STRINGS. THESE STRINGS ARE USED FOR PROMPTING
    ; THE USER.
    ;*************************************
    promptIntStr BYTE "Please enter an integer value up to 16 bits in size: ", 0
    promptIntStr2 BYTE "Please enter another integer value up to 16 bits in size: ", 0

    promptMenuStr BYTE "    Please choose one of the menu options: ", 0

    addStr BYTE "           (1) Addition", 0
    minStr BYTE "           (2) Subtraction", 0 ; interestingly, when minStr was named subStr initially, the program would not run. my assumption is that
                                                ; subStr is a command of some sort.
    mulStr BYTE "           (3) Multiplication", 0
    divStr BYTE "           (4) Division", 0
    exiStr BYTE "           (5) Exit", 0

    compResStr BYTE "    Computation Result:",0
    
    andStr BYTE " and ", 0
    isStr BYTE " is ", 0
    minusStr BYTE " minus ", 0

    sumResStr BYTE "    The sum of ", 0
    subResStr BYTE "    The value of ", 0
    mulResStr BYTE "    The product of ", 0
    divResStr BYTE "    The result of ", 0
    divResStr2 BYTE " divided by ", 0
    divResStr3 BYTE " with a remainder of ", 0

    
    errorMessage BYTE "Please re-enter the value.  ", 0
    divError BYTE "Cannot divide by 0. Please re-enter your integers.", 0
    bitError BYTE "Inputted values must be 16-bits. Please re-enter your integers.", 0

    ;*************************************
    ; THE DATA BELOW ARE INPUT VARIABLES AND ARRAYS. THIS DATA IS USED FOR
    ; HOLDING USER INPUTTED DATA.
    ;*************************************

    intInp SDWORD ?
    intInp2 SDWORD ?

    answer DWORD ?

    result SDWORD ?
    remainder SDWORD ?
    

; **********************************************************************;
; Functional description of the main program
;   Inputs: The main program does not require any user inputs directly. The user may input values to answer any outputted prompts.
;	Outputs: The main program does not output anything directly. The main program displays prompts for the user.
;	Registers used and associated purpose of each:
;       EDX - This is the Extended Data register. This register is used to store the offset for strings.
;       EAX - This is the Extended Accumulator register. This register is used to store integers as well as any
;             calculations. This is also being used to store color values.
;	Memory locations use and associated purpose of each
;       promptIntStr - this is an initialized string of the BYTE data-type. this string is utilized for prompting the user to choose an initial 16-bit integer.
;       promtIntStr2 - this is an initialized string of the BYTE data-type. this string is utilized for prompting the user to choose a second 16-bit integer.
;       promptMenuStr - this is an initialized string of the BYTE data-type. this string is utilized for prompting the user to choose a menu option.
;       addStr - this is an initialized string of the BYTE data-type. this string is utilized for revealing the addition menu option to the user.
;       minStr - this is an initialized string of the BYTE data-type. this string is utilized for revealing the subtraction menu option to the user.
;       mulStr - this is an initialized string of the BYTE data-type. this string is utilized for revealing the multiplication menu option to the user.
;       divStr - this is an initialized string of the BYTE data-type. this string is utilized for revealing the division menu option to the user.
;       exiStr - this is an initialized string of the BYTE data-type. this string is utilized for revealing the exit menu option to the user.
;       compResStr - this is an initialized string of the BYTE data-type. this string is utilized for preparing to reveal the result of the chosen computation
;                    to the user
;       andStr - this is an initialized string of the BYTE data-type. this string is utilized for outputting the word, "and," in the middle of sentences.
;       isStr - this is an initialized string of the BYTE data-type. this string is utilized for outputting the word, "is," in the middle of sentences.
;       minusStr - this is an initialized string of the BYTE data-type. this string is utilized for outputting the word, "minus," in the middle of sentences.
;       sumResStr - this is an initialized string of the BYTE data-type. this string is utilized for preparing to reveal the result of an addition calculation to the user.
;       subResStr - this is an initialized string of the BYTE data-type. this string is utilized for preparing to reveal the result of a subtraction calculation to the user.
;       mulResStr - this is an initialized string of the BYTE data-type. this string is utilized for preparing to reveal the result of a product calculation to the user.
;       divResStr - this is an initialized string of the BYTE data-type. this string is utilized for preparing to reveal the result of a division calculation to the user.
;       divResStr2 - this is an initialized string of the BYTE data-type. this string is utilized as the second part of the division calculation string.
;       divResStr3 - this is an initialized string of the BYTE data-type. this string is utilized as the third part of the division calculation string.
;       errorMessage - this is an initialized string of the BYTE data-type. this string is utilized for prompting the user to re-enter a value.
;       divError - this is an initialized string of the BYTE data-type. this string is utilized for informing the user that an integer cannot be divided by 0, then
;                  prompting the user to re-enter their values.
;       bitError - this is an intitialized string of the BYTE data-type. this string is utilized for informing the user than the inputs must be 16-bits, then prompting
;                  the user to re-enter their values.
;       intInp - this is an uninitialized variable of the SDWORD data-type. this varaible is utilized for holding the first user-inputted 16-bit integer.
;       intInp2 - this is an uninitialized variable of the SDWORD data-type. this varaible is utilized for holding the second user-inputted 16-bit integer.
;       answer - this is an uninitialized variable of the DWORD data-type. this varaible is utilized for holding the user-inputted choice for a mathematical operation.
;       result - this is an uninitialized variable of the SDWORD data-type. this varaible is utilized for holding the result of the chosen mathematical operation.
;       remainder - this is an uninitialized variable of the SDWORD data-type. this varaible is utilized for holding remainder of the division mathematical operation.
;	Functional details: 
;       The main program calls the IntegerCalculator program, which handles and input and output for the program.
; **********************************************************************;

.code
;***********************************
; Description: This procedure prompts the user to input two 16-bit integers, then it asks the user which mathematical operation they'd like to complete.
;              Depending on the choice of the user, the result of the operation is diplayed on the screen in blue text. The user may quit the program by
;              selecting the quit option when prompted to choose an operation.
; Receives: This function does not directly recieve thing. During runtime, the user may input integers in order to perform the purpose of the function.
; Returns: This function does not directly return anything. However, result variable, as well as basic string, are outputted to the user during runtime.
; Requires: This procedure requires the Irvine32 library.
;***********************************
IntegerCalculator PROC

    ;**********
    ; THIS LABEL PROMPTS THE USER TO INPUT TWO 16-BIT INTEGERS, SHOWS THEM THEIR MATHEMATICAL OPERATIONS OPTIONS, 
    ; THEN PROMPTS THE USER TO CHOOSE AN OPTION.
    ;**********
    Intro:
        mov edx, OFFSET promptIntStr
        call WriteString

        call ReadInt
        jo InvalidInput ; if the user inputs a number greater than 32-bit, the overflow flag is set and the program jumps to the InvalidInput
                        ; label. while this program allows for operations using 16-bit, the integers are saved into 32-bit memory.
        mov intInp, eax
        .IF intInp > 32767 || intInp < -32768 ; if the input is greater or less than 16-bits, the program jumps to the InvalidInput label 
            jmp InvalidInput
        .ENDIF
        call Crlf

        mov edx, OFFSET promptIntStr2
        call WriteString

        call ReadInt
        jo InvalidInput
        mov intInp2, eax
        .IF intInp2 > 32767 || intInp2 < -32768
            jmp InvalidInput
        .ENDIF
        call Crlf

        mov edx, OFFSET addStr
        call WriteString
        call Crlf

        mov edx, OFFSET minStr
        call WriteString
        call Crlf

        mov edx, OFFSET mulStr
        call WriteString
        call Crlf

        mov edx, OFFSET divStr
        call WriteString
        call Crlf

        mov edx, OFFSET exiStr
        call WriteString
        call Crlf

        mov edx, OFFSET promptMenuStr
        call WriteString

    ;**********
    ; THIS LABEL ALLOWS THE USER TO INPUT A NUMBER BETWEEN 1 AND 5, INCLUSIVE OF EACH END, WHERE EACH NUMBER CAN
    ; CORRESPONDS TO EITHER A MATHEMATICAL OPERATION OR A "QUIT PROGRAM" OPTION.
    ;**********
    MenuOptions:
        call ReadInt
        mov answer, eax

        .IF answer >= 1 && answer <= 5
            .IF answer == 1
                call Crlf
                jmp Addition
            .ELSEIF answer == 2
                call Crlf
                jmp Subtraction    
            .ELSEIF answer == 3
                call Crlf
                jmp Multiplication 
            .ELSEIF answer == 4
                call Crlf
                jmp Division 
            .ELSEIF answer == 5
                ret 
            .ENDIF
        .ELSE
            call Crlf
            mov edx, OFFSET errorMessage
            call WriteString
            call Crlf
            jmp MenuOptions
        .ENDIF

    ;**********
    ; THIS LABEL PERFORMS ADDITION WITH THE TWO USER-INPUTTED 16-BIT INTEGERS. THE INTEGERS THEMSELVES, AS WELL AS
    ; THE RESULT, IS OUTPUTTED IN BLUE COLOR.
    ;**********
    Addition:
        mov eax, intInp
        add eax, intInp2
        mov result, eax

        mov edx, OFFSET compResStr
        call WriteString

        call Crlf

        mov edx, OFFSET sumResStr
        call WriteString

        ; when utilizing colors, consider the following formula:
        ; foreground_color + (background_color * 4_bits).
        ; where 4_bits is represented by 16, or 2^4.
        ; 4_bits is necessary because each color uses 4 bits.
        mov eax, lightBlue + (black * 16)
        call SetTextColor

        mov eax, intInp
        .IF intInp >= 0
            call WriteDec
        .ELSE
            call WriteInt
        .ENDIF

        mov eax, lightGray + (black * 16)
        call SetTextColor

        mov edx, OFFSET andStr
        call WriteString

        mov eax, lightBlue + (black * 16)
        call SetTextColor

        mov eax, intInp2
        .IF intInp2 >= 0
            call WriteDec
        .ELSE
            call WriteInt
        .ENDIF
        
        mov eax, lightGray + (black * 16)
        call SetTextColor

        mov edx, OFFSET isStr
        call WriteString

        mov eax, lightBlue + (black * 16)
        call SetTextColor

        ; this line determines if the result should be outputted
        ; as a decimal or integer, depending on if it is negative
        ; or not
        mov eax, result
        .IF result >= 0
            call WriteDec
        .ELSE
            call WriteInt
        .ENDIF

        mov eax, lightGray + (black * 16)
        call SetTextColor

        call Crlf
        call Crlf

        jmp Intro

    ;**********
    ; THIS LABEL PERFORMS SUBTRACTION WITH THE TWO USER-INPUTTED 16-BIT INTEGERS. THE INTEGERS THEMSELVES, AS WELL AS
    ; THE RESULT, IS OUTPUTTED IN BLUE COLOR.
    ;**********
    Subtraction:
        mov eax, intInp
        sub eax, intInp2
        mov result, eax

        mov edx, OFFSET compResStr
        call WriteString

        call Crlf

        mov edx, OFFSET subResStr
        call WriteString

        mov eax, lightBlue + (black * 16)
        call SetTextColor

        mov eax, intInp
        .IF intInp >= 0
            call WriteDec
        .ELSE
            call WriteInt
        .ENDIF

        mov eax, lightGray + (black * 16)
        call SetTextColor

        mov edx, OFFSET minusStr
        call WriteString

        mov eax, lightBlue + (black * 16)
        call SetTextColor

        mov eax, intInp2
        .IF intInp2 >= 0
            call WriteDec
        .ELSE
            call WriteInt
        .ENDIF

        mov eax, lightGray + (black * 16)
        call SetTextColor

        mov edx, OFFSET isStr
        call WriteString

        mov eax, lightBlue + (black * 16)
        call SetTextColor

        mov eax, result
        .IF result >= 0
            call WriteDec
        .ELSE
            call WriteInt
        .ENDIF

        mov eax, lightGray + (black * 16)
        call SetTextColor

        call Crlf
        call Crlf

        jmp Intro

    ;**********
    ; THIS LABEL PERFORMS MULTIPLICATION WITH THE TWO USER-INPUTTED 16-BIT INTEGERS. THE INTEGERS THEMSELVES, AS WELL AS
    ; THE RESULT, IS OUTPUTTED IN BLUE COLOR.
    ;**********
    Multiplication:

        ; this block of code utilizes imul.
        ; imul is signed multiplication. this command multiplies two signed integers.
        ; the result is stored in eax.
        mov eax, intInp
        imul eax, intInp2
        mov result, eax

        mov edx, OFFSET compResStr
        call WriteString

        call Crlf

        mov edx, OFFSET mulResStr
        call WriteString

        mov eax, lightBlue + (black * 16)
        call SetTextColor

        mov eax, intInp
        .IF intInp >= 0
            call WriteDec
        .ELSE
            call WriteInt
        .ENDIF

        mov eax, lightGray + (black * 16)
        call SetTextColor

        mov edx, OFFSET andStr
        call WriteString

        mov eax, lightBlue + (black * 16)
        call SetTextColor

        mov eax, intInp2
        .IF intInp2 >= 0
            call WriteDec
        .ELSE
            call WriteInt
        .ENDIF

        mov eax, lightGray + (black * 16)
        call SetTextColor

        mov edx, OFFSET isStr
        call WriteString

        mov eax, lightBlue + (black * 16)
        call SetTextColor

        mov eax, result
        .IF result >= 0
            call WriteDec
        .ELSE
            call WriteInt
        .ENDIF

        mov eax, lightGray + (black * 16)
        call SetTextColor

        call Crlf
        call Crlf

        jmp Intro

    ;**********
    ; THIS LABEL PERFORMS DIVISION WITH THE TWO USER-INPUTTED 16-BIT INTEGERS. THE INTEGERS THEMSELVES, AS WELL AS
    ; THE RESULT AND REMAINDER, IS OUTPUTTED IN BLUE COLOR.
    ;**********
    Division:

        ; this block determines if the user is attempting to divide an integer by zero.
        ; if so, the program jumps to the DivisionError label.
        cmp intInp2, 0
        je DivisionError

        ; this block of code utilizes idiv and cdq.
        ; idiv is signed division. this command requires its dividend to be sign-extended, which is called by the cdq command.
        ; the quotient is stored in eax and the remainder is stored in edx.
        ; note that the value in eax is divided by the parameter value of idiv.
        mov eax, intInp
        cdq
        idiv intInp2
        mov result, eax
        mov remainder, edx

        mov edx, OFFSET compResStr
        call WriteString

        call Crlf

        mov edx, OFFSET divResStr
        call WriteString

        mov eax, lightBlue + (black * 16)
        call SetTextColor

        mov eax, intInp
        .IF intInp >= 0
            call WriteDec
        .ELSE
            call WriteInt
        .ENDIF

        mov eax, lightGray + (black * 16)
        call SetTextColor

        mov edx, OFFSET divResStr2
        call WriteString

        mov eax, lightBlue + (black * 16)
        call SetTextColor

        mov eax, intInp2
        .IF intInp2 >= 0
            call WriteDec
        .ELSE
            call WriteInt
        .ENDIF

        mov eax, lightGray + (black * 16)
        call SetTextColor

        mov edx, OFFSET isStr
        call WriteString

        mov eax, lightBlue + (black * 16)
        call SetTextColor

        mov eax, result
        .IF result >= 0
            call WriteDec
        .ELSE
            call WriteInt
        .ENDIF

        mov eax, lightGray + (black * 16)
        call SetTextColor

        mov edx, OFFSET divResStr3
        call WriteString

        mov eax, lightBlue + (black * 16)
        call SetTextColor

        mov eax, remainder
        .IF remainder >= 0
            call WriteDec
        .ELSE
            call WriteInt
        .ENDIF

        mov eax, lightGray + (black * 16)
        call SetTextColor

        call Crlf
        call Crlf

        jmp Intro

    ;**********
    ; THIS LABEL PROTECTS THE PROGRAM FROM CRASHING IF THE USER ATTEMPTS TO DIVIDE AN INTEGER
    ; BY 0. THIS IS DONE BY PROMPTING THE USER TO RE-ENTER THEIR VALUES, THEN JUMPING TO THE INTRO
    ; LABEL
    ;**********
    DivisionError:
        mov edx, OFFSET divError
        call WriteString
        call Crlf
        call Crlf
        jmp Intro

    ;**********
    ; THIS LABEL INFORMS THE USER THAT THEIR INPUTS MUST BE 16-BIT, THEN IT JUMPS TO THE INTRO LABEL
    ; WHERE THE USER MUST RE-INPUT BOTH INTEGER VALUES FOR OPERATION.
    ;**********
    InvalidInput:
        call Crlf
        mov edx, OFFSET bitError
        call WriteString
        call Crlf
        call Crlf
        jmp Intro
        

    ret
IntegerCalculator ENDP

main PROC

    call IntegerCalculator ; run the IntegerCalculator program.

    INVOKE ExitProcess,0

main ENDP

END main
