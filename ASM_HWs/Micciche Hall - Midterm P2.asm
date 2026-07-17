; **********************************************************************;
; Program Name: Array Sorter - Midterm Project
; Program Description: This program takes a user-inputted array of 25 non-negative integers,
;                      then determines the minimum value and maximum value of the array and
;                      displays them. Then the value of the average of the array is determined
;                      and outputted. After that the even values of the array are determined
;                      and placed into their own array, named evens, and the odd values of the
;                      array are also determined and placed into their own array, named odds.
;                      Finally, the program asks if the user would like to retry the program.
; Author: Terrence Micciche Hall
; Course: CSC2025X40
; Creation Date: 06/29/26
; Revisions: 1
; Date Last Modified: 07/02/26
; Test Cases:
;   All Evens: PASSED                   ; this tests the case of all even inputs
;   All Odds: PASSED                    ; this tests the case of all odd inputs
;   25 Entered Values: PASSED           ; this tests the case of 25 inputted values
;   Only Enter -1: PASSED               ; this tests the case of no intputted values
;   12 Entered Values: PASSED           ; this tests the case of only 12 inputted values
;   Only Enter 0: PASSED                ; this tests the case of all zero inputs
;   Half 0s: PASSED                     ; this test the case of 12 inputted zeros
;   Duplicates: PASSED                  ; this tests the case of five 1s, five 2s, five 3s, five 4s, and five 5s
;   1-25 In Order: PASSED               ; this tests the case of the sequence 1 to 25 in order
;   1-25 Reverse: PASSED                ; this tests the case of the sequence 1 to 25 in reverse
;   Sum Overflow (Average): PASSED      ; this tests the case of the sum of all the integers being greater than the 32 bit limit
;***********************************************************************;

INCLUDE C:\Irvine\Irvine32.inc
INCLUDELIB C:\Irvine\Irvine32.lib

.data

    ;*************************************
    ; THE DATA BELOW ARE OUTPUT STRINGS. THESE STRINGS ARE USED FOR PROMPTING
    ; THE USER.
    ;*************************************
    promptIntStr BYTE "Please enter 25 non-negative integers (one per line).", 0 ; this creates a string which prompts the user to enter 25 non-negative
                                                                                 ; integers.
    intFinishedStr BYTE "When you are finished, please enter '-1'.", 0 ; this creates a string to prompt the user to press '-1' when they are finished
                                                                       ; inputting values.

    arrayStr BYTE "Your array is: ", 0 ; this creates a string to let the user know what their array is.

    minIntStr BYTE "The minimum integer in the array is: ", 0 ; this creates a string to let the user know what the minimum value
                                                              ; in the array is.
    maxIntStr BYTE "The maximum integer in the array is: ", 0 ; this creates a string to let the user know what the maximum value
                                                              ; in the array is.

    avgValStr BYTE "The average value of the array is: ", 0 ; this creates a string to let the user know what the average value of the
                                                            ; array.

    oddsArrayStr BYTE "The odd values of the array are: ", 0 ; this creates a string to let the user know what the odd values of the array are.
    evensArrayStr BYTE "The even values of the array are: ", 0 ; this creates a string to let the user know what the even values of the array are.

    tryAgainStr BYTE "Would you like to try again? (y/n)? ", 0 ; this creates a string to prompt the user to press 'y' or 'n' if they'd like to
                                                               ; run the program again.

    errorMessage BYTE "This is an invalid integer. Please re-enter the value.", 0 ; this creates a string to let the user know that the integer
                                                                                  ; they inputted is invalid. it then prompts the user to re-enter
                                                                                  ; their value.
    errorMessage2 BYTE "This is an invalid response. Please re-enter your response.", 0 ; this creates a string to let the user know that the response
                                                                                        ; they inputted is invalid. it then prompts the user to re-enter
                                                                                        ; their response.
    errorMessage3 BYTE "The average value could not be calculated because the sum is too large. The average will default to 0.", 0 ; this creates a string
                                                                                                                                  ; to let the user know that the average
                                                                                                                                  ; value could not be calculated.

    integerStr BYTE "Integer ", 0 ; this creates a string to let the user know which integer they are inputting.

    noValsStr BYTE "[There are no available values]", 0 ; this creates a string to let the user know that there are no available values.
                                                        ; this is utilized within the context of outputting the odd arrays and the even arrays.

    ;*************************************
    ; THE DATA BELOW ARE INPUT VARIABLES AND ARRAYS. THIS DATA IS USED FOR
    ; HOLDING USER INPUTTED DATA.
    ;*************************************

    intArray DWORD 25 DUP(?) ; this is the array utilizied to hold 25 non-negative integers. this array is uninitialized and is of the
                             ; DWORD data type.

    odds DWORD 25 DUP(?) ; this is the array utilized to hold the odd integers. this array is unitialized and is of the DWORD data type.
    evens DWORD 25 DUP(?) ; this is the array utilized to hold the even integers. this array is uninitialized and is of the DWORD data type.

    minVal DWORD ? ; this is an initialized variable of the DWORD data type. this variable holds the minimum value of the array.  
    maxVal DWORD ? ; this is an initialized variable of the DWORD data type. this variable holds the maximum value of the array.

    averageVal DWORD ? ; this is an uninitialized variable of the DWORD data type. this variable holds the value of the average of
                       ; the array

    oddsCounter DWORD 0 ; this is an initialized variable of the DWORD data type. this variable is initialized to 0, and is used to keep
                        ; track of how many odd values are in the array.
    evensCounter DWORD 0 ; this is an initialized variable of the DWORD data type. this variable is initialized to 0, and is used to keep
                         ; track of how many even values are in the array.

    answer BYTE 2 DUP(0) ; this is an initialized array of DWORD elements. the elements are initialized to 0, and they are used to keep track
                         ; of the response to the TryAgain label as well as the null terminator.

; **********************************************************************;
; Functional description of the main program
;   Inputs: The main program does not require any user inputs directly. The user may input values to answer any outputted prompts.
;	Outputs: The main program does not output anything directly. The main program displays prompts for the user.
;	Registers used and associated purpose of each:
;       EDX - This is the Extended Data register. This register is used to store the offset for strings.
;       EAX - This is the Extended Accumulator register. This register is used to store integers as well as any
;             calculations. This is also being used to store color values.
;       ECX - This is the Extended Count register. This register is used to keep track of the iterations of WHILE loops and loop
;             instructions.
;       EBX - This is the Extended Base register. This register is used throughout this program as an assistant to EAX for calculations
;             and storing integers.
;       EDI - This is the Extended Data Index. This register is used as an index counter.
;       ESI - This is the Extended Source Index. This register is used an index counter.
;       AL - This is the Accumulator Low register. This register is used to store the offset for characters.
;       ESP - This is the Extended Stack Pointer. This register is used when using the push command to store the values of other registers,
;             such as EAX, EBX, or ECX.
;	Memory locations use and associated purpose of each
;       promptIntStr - This is an output string. This string is used to prompt the user to enter 25 non-negative integers. It also
;                      informs the user to enter one integer per line.
;       intFinishedStr - This is an output string. This string is used to inform the user to enter "-1" when they are finished
;                        entering integers
;       arrayStr - This is an output string. This string is used to inform the user what the inputted array is.
;       minIntStr - This is a output string. This string is used to inform the user what the minimum value of the array is.
;       maxIntStr - This is an output string. This string is used to inform the user what the maximum value of the array is.
;       avgValStr - This is an output string. This string is used to inform the user what the value of the average of the array is.
;       oddsArrayStr - This is an output string. This string is used to inform the user what the odd values of the array is.
;       evensArrayStr - This is a output string. This string is used to inform the user what the even values of the array is.
;       tryAgainStr - This is an output string. This string is used to prompt the user to enter 'y' or 'n' to continue the program.
;       errorMessage - This is an output string. This is a string used to inform the user that the entered integer is invalid. It then
;                      prompts the user to re-enter the integer.
;       errorMessage2 - This is an output string. This is a string used to inform the user that the entered response is invalid. It then
;                       promps the user to re-enter the response.
;       errorMessage3 - This is an output string. This is a string used to inform the the average of the array cannot be calculated. It then moves forward. 
;       integerStr - This is an output string. This is a string used to inform what element that are entering into the array.
;       intArray - This is an input array. This array is meant to hold 25 non-negative elements.
;       odds - This is an input array. This array is meant to hold the odd elements of the array intArray in ascending order.
;       evens - This is an input array. This array is meant to hold the even elements of the array intArray in ascending order.
;       minVal - This is an input variable. This variable is meant to hold the minimum value of the array intArray.
;       maxVal - This is an input variable. This variable is meant to hold the maximum value of the array intArray.
;       averageVal - This is an input variable. This variable is meant to hold the value of the average of the array intArray.
;       oddsCounter - This is an input variable. This variable is meant to keep track of the amount of odd elements in the
;                     array intArray.
;       evensCounter - This is an input variable. This variable is meant to keep track of the amount of even elements in the
;                      array intArray.
;       answer - This is an input array. This array is meant to hold the user's response to the label TryAgain.
;	Functional details: 
;       This program asks the user to enter 25 non-negative integers, then puts those integers into an array intArray.
;       Afterward, the maximum and minimum value of the array is found and outputted. Then, the value of the average of
;       the array is found and outputted. After that, the odd values of the array is placed into their own separate array
;       named odds and the even values of the array is placed into their own separate array named evens. Those arrays are
;       then outputted. Afterwards, the program asks if the user would like to restart the program. 
; **********************************************************************;

.code

;***********************************
; Description: This procedure iterates through the array intArray and saves the maximum and minimum values into their own
;              respective variables.
; Receives: This procedure recieves the array intArray.
; Returns: This procedure returns the variables minVal and maxVal.
; Requires: This procedure requires the Irvine32 library and the array intArray.
;***********************************
ArrayMinMaxFinder PROC
    mov ecx, 1 ; sets ecx to 1

    mov eax, intArray[0] ; sets the register eax with the first element of intArray
    mov minVal, eax ; sets the variable minVal with the register eax
    mov maxVal, eax ; sets the variable maxVal with the register eax

    .WHILE ecx < LENGTHOF intArray ; while the ecx register is less than the number of elements in intArray
        mov eax, intArray[ecx*TYPE intArray] ; set the register eax equal to the index equal to the value of ecx in the intArray array
        .IF minVal > eax ; if the variable minVal is greater than eax
            mov minVal, eax ; set the variable minVal equal to the value of the eax register
        .ELSEIF maxVal < eax ; if the variable maxVal is less that eax
            mov maxVal, eax ; set the variable max val equal to the value of the eax register
        .ENDIF

        inc ecx ; increase ecx by 1
    .ENDW

    ret ; end the procedure
ArrayMinMaxFinder ENDP

;***********************************
; Description: This procedure iterates through the array intArray, finding the sum of all of the
;              elements then dividing by the amount of elements in the intArray. This is the
;              equivalent of finding the average of the array.
; Receives: This procedure recieves the array intArray.
; Returns: This procedure returns the variable averageVal
; Requires: This procedure requires the Irvine32 library and the array intArray.
;***********************************
ArrayAverageFinder PROC
    mov ecx, 0 ; set ecx equal to zero
    mov eax, 0 ; set eax equal to zero 

    .WHILE ecx < LENGTHOF intArray ; while ecx is less than the number of elements in the array intArray
        add eax, intArray[ecx*TYPE intArray] ; add the element of the index equal to the value of ecx in the intArray array to eax
        jc SumOverflow
        inc ecx ; increase ecx by 1
    .ENDW

    mov ebx, LENGTHOF intArray ; set the ebx register equal to the number of elements in the array intArray
    mov edx, 0 ; set the edx register to 0

    div ebx ; divide eax by ebx

    mov averageVal, eax ; store the value of the eax register in the variable averageVal
    
    ret

    SumOverflow: ; this label runs in the case that the sum of the integers in the array is greater than the 32 bit unsigned limit

        call Crlf ; new line

        mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
        call SetTextColor ; this sets the text color to the value in eax
        
        mov edx, OFFSET errorMessage3 ; this prepares the string errorMessage3 to be outputted
        call WriteString ; outputs the string errorMessage3

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        call Crlf ; new line

        mov averageVal, 0 ; sets the variable averageVal to 0

        ret
ArrayAverageFinder ENDP

;***********************************
; Description: This procedure iterates through the array intArray, finding all of the odd and even values, then
;              places them into their own respective arrays, named odds and evens. Those arrays are then sorted
;              into ascending order using a BubbleSort equivalent algorithm.
; Receives: This procedure recieves the array intArray.
; Returns: This procedure returns the array evens, the array odds, the variable oddsCounter, and the variable evensCounter.
; Requires: This procedure requires the Irvine32 library and the array intArray.
;***********************************
ArrayOddsEvensSorter PROC
    mov ecx, 0 ; sets ecx equal to 0
    mov edi, 0 ; sets edi equal to 0
    mov esi, 0 ; sets esi equal to 0

    .WHILE ecx < LENGTHOF intArray ; while ecx is less than the number of elements in intArray
        mov eax, intArray[ecx*TYPE intArray] ; set eax equal to the index equal to the value of ecx in the intArray array
        mov ebx, 2 ; set ebx equal to 2
        mov edx, 0 ; set edx equal to 0 
        
        div ebx ; divide eax by ebx

        mov eax, intArray[ecx*TYPE intArray] ; set eax equal to the index equal to the value of ecx
        .IF edx == 1 ; if edx equals one
            mov odds[edi*TYPE odds], eax ; set the index of the value of edi in the odds array equal to the value of the eax register
            inc edi ; increase the value of the edi register by 1
            inc ecx ; increase the value of the ecx register by 1
            inc oddsCounter ; increase the variable oddsCounter by 1
        .ELSE
            mov evens[esi*TYPE evens], eax ; set the index of the value of edi in the evens array equal to the value of the eax register 
            inc esi ; increase the value of the esi register by 1
            inc ecx ; increase the value of the ecx register by 1 
            inc evensCounter ; increase the variable evensCounter by 1
        .ENDIF
    .ENDW

    BubbleSortOdds: ; THIS LABEL IS THE EQUIVALENT OF THE BUBBLESORT ALGORITHM ON THE ODDS ARRAY
        mov ecx, oddsCounter ; the loop L1 runs many times as the value of oddsCounter
        cmp ecx, 0 ; if there are no odd values
        je NoOdds ; then jump to the NoOdds label

        mov edi, 0 ; this is an index counter
        mov edx, 0 ; this is the offset for determining the loop counter of L2.
                   ; EDX is used here to count how many times L1 ran
    
        L1: ; this is the outer loop.
            push ecx ; this saves ecx on the stack

            mov ecx, oddsCounter ; this sets ecx with the oddsCounter value
            sub ecx, edx ; this subtracts edx from ecx. this makes the loop counter
                         ; for L2 equal to the amount of values in the odds array
                         ; minus the amount of times the loop L1 has ran.

            dec ecx ; this decreases ecx by one. this prevents any unexpected stack behavior. without
                     ; this, the loop L2 to run one extra time. this allows the immediate pop after L2
                     ; to be called. as a result, the first pop of the label BubbleSortEvans pops a
                     ; value that is not meant to be popped.
            mov edi, 0 ; set edi equal to zero

            L2: ; this is the inner loop.
                cmp ecx, 0 ; compare the value of ecx to zero
                je BubbleSortEvens ; if ecx equals zero, jump to the BubbleSortEvens label. this means
                                   ; if there are no odd values within the array intArray, sort the evens
                                   ; array instead.

                mov eax, odds[edi*TYPE odds] ; set eax equal to the index equal to the value of edi in the oddsa rray
                inc edi ; increase the edi register by 1
                .IF eax > odds[edi*TYPE odds] ; if eax is greater than the index equal to the value of ecx in the odds array
                    mov ebx, odds[edi*TYPE odds] ; set ebx equal to the index equal to the value of edi in the odds array
                    dec edi ; decrease the edi register by 1
                    mov odds[edi*TYPE odds], ebx ; set the index equal to the value of edi in the odds array equal to the ebx register
                    inc edi ; increase the edi register by 1
                    mov odds[edi*TYPE odds], eax ; set the index equal to the value of edi in the odds array equal to the eax register
                .ENDIF
                loop L2 ; this loops L2

            inc edx ; this increases to count that L1 has ran a full iteration
            pop ecx ; this retrieves ecx from the stack

            inc esi ; this increases the L1 pointer ESI
            loop L1 ; this loops L1

    BubbleSortEvens: ; THIS LABEL IS THE EQUIVALENT OF THE BUBBLESORT ALGORITHM ON THE EVENS ARRAY
        pop ecx ; this is to avoid unexpected behavior with the 'ret' command later.

        mov ecx, evensCounter ; the loop L3 runs many times as the value of oddsCounter

        cmp ecx, 0 ; compare ecx to zero
        je NoEvens ; jump to the NoEvens label if ecx is equal to zero

        mov edi, 0 ; this is an index counter
        mov edx, 0 ; this is the offset for determining the loop counter of L4.
                   ; EDX is used here to count how many times L3 ran
    
        L3: ; this is the outer loop.
            push ecx ; this saves ecx on the stack

            mov ecx, evensCounter ; this sets ecx with the oddsCounter value
            sub ecx, edx ; this subtracts edx from ecx. this makes the L4
                         ; loop counter have a difference of edx from 
                         ; the value of oddCounter

            dec ecx ; decrease the ecx register by 1
            mov edi, 0 ; set the edi register equal to 0

            L4: ; this is the inner loop.
                cmp ecx, 0 ; compare ecx to zero
                je Done ; jump to the Done label if ecx is equal to zero

                mov eax, evens[edi*TYPE evens] ; set eax equal to the index equal to the value of edi in the evens array
                inc edi ; increase the edi register by 1
                .IF eax > evens[edi*TYPE evens] ; if the value of the eax register is greater than the index equal to the value of edi in the evens array
                    mov ebx, evens[edi*TYPE evens] ; set ebx equal to the index equal to the value of edi in the evens array
                    dec edi ; decrease edi by 1
                    mov evens[edi*TYPE evens], ebx ; set the index equal to the value of edi in the odds array equal to the ebx register
                    inc edi ; increase edi by 1
                    mov evens[edi*TYPE evens], eax ; set the index equal to the value of edi in the odds array equal to the eax register
                .ENDIF
                loop L4 ; this loops L4

            inc edx ; this increases to count that L3 has ran a full iteration
            pop ecx ; this retrieves ecx from the stack

            inc esi ; this increases the L3 pointer ESI
            loop L3 ; this loops L3

    Done:
        pop ecx ; pull the top value in the stack and set ecx equal to it
        ret ; end the procedure

    NoEvens:
        push ecx ; put the value of ecx into the stack
        jmp Done ; jump to the Done label

    NoOdds:
        push ecx ; put the value of ecx into the stack
        jmp BubbleSortEvens ; jump to the BubbleSortEvens label

ArrayOddsEvensSorter ENDP

;***********************************
; Description: The main program prompts the user to enter an array of twenty-five non-negative integers, filling any unentered
;              elements with the sequential list of one through twenty-five, then it fills an uninitialized array with either the
;              user-inputted values or the sequantial list. Next, The array is outputted. After that, the main program calls 
;              ArrayMinMaxFinder and displays the minimum and maximum values of the array. Then, the main program calls ArrayAverageFinder
;              and displays the average value of the array. Next, ArrayOddsEvensSorter is called and the main program displays
;              the odd and even values of the array in ascending order. Afterwards, the user is asked if they would like
;              to try the program again.
;
;              Any important values, such as the user-inputted integers or the program's calculations, are outputted in blue. The
;              sequential list of one through twenty-five will be outputed in red. This is to differentiate between what values
;              were generated by default and which weren't.
; Receives: This procedure does not recieve anything. However, the user may input values to answer any outputted prompts.
; Returns: This procedure does not return anything. However, it output prompts.
; Requires: This procedure requires the Irvine32 library, the ArrayOddsEvensSorter prodecure, the ArrayAverageFinder procedure, 
;           and the ArrayMinMaxFinder procedure.
;***********************************
MainProgram PROC

    Prompt: ; this label is used to promp the user to enter 25 non-negative integers
        mov edx,  OFFSET promptIntStr ; prepares the string promptIntStr to be outputted
        call WriteString ; outputs the prepared string promptIntStr
        call Crlf ; new line
        mov edx, OFFSET intFinishedStr ; prepares the string intFinishedStr to be outputted
        call WriteString ; outputs the prepared string intFinishedStr
        call Crlf ; new line
        call Crlf ; new line, for formatting

    FillArraySetup: ; this label is used to set up the next label, FillArray
        mov ecx, 0 ; set ecx equal to 0
        mov eax, 1 ; set eax equal to 1

    FillArray: ; this label takes the non-negative user inputted integers and puts them into the array intArray
        .WHILE ecx < LENGTHOF intArray ; while the ecx register is less than the number of elements in the array intArray
            mov edx, OFFSET integerStr ; prepare integerStr to be outputted
            call WriteString ; output integerStr

            call WriteDec ; output the the value of eax. this specifically keeps track of how many integers the user
                          ; inputs

            push eax ; this pushes the iteration of the while loop

            mov al, ':' ; prepares the character ':' to be outputted
            call WriteChar ; outputs ':'

            mov al, ' ' ; prepares the character ' ' to be outputted
            call WriteChar ; outputs ':'

            mov eax, lightBlue + (black * 16) ; this sets the color of the text to blue and the background to black
            call SetTextColor ; this sets the text color to the value in eax

            call ReadInt ; this reads an input from the user

            jo InvalidInput ; jump to the InvalidInput label if the overflow flag is set

            push eax ; this pushes the user inputted integer

            mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
            call SetTextColor ; this sets the text color to the value in eax

            pop eax ; this pops the user inputted integer

            cmp eax, -1 ; compare eax to -1
            je FillEmptyArray ; if eax is equal to -1 jump to the FillEmptyArray label
            cmp eax, 0 ; compare eax to 0
            jl InvalidInput ; if eax is lower than 0, jump to the InvalidInput label

            mov intArray[ecx*TYPE intArray], eax ; set the index equal to the value of ecx in the intArray array equal to the eax register

            pop eax ; this pops the iteration of the while loop

            inc ecx ; this increases the loop counter ecx
            inc eax ; this increases the iteration of the while loop

        .ENDW

        dec eax ; this decreases the iteration of the while loop, to account for the extra
                ; "inc eax" at the end of the while loop
        push eax ; this pushes the iteration of the while loop

        jmp DisplayArray ; this jumps to the label Display Array

    FillEmptyArray: ; this label is ran if the user does not input 25 non-negative integers. this label fills the array with the sequential
                    ; values of 1 to 25. 
        mov eax, 1 ; set eax equal to 1
        .WHILE ecx < LENGTHOF intArray ; while ecx is less than the number of elements in intArray
            mov intArray[ecx*TYPE intArray], eax ; set the index equal to the value of ecx in the odds array equal to the eax register
            inc ecx ; increase the ecx register by 1
            inc eax ; increase the eax reguster by 1
        .ENDW

    DisplayArray: ; this label displays the array that will be iterated
        call Crlf ; new line

        mov edx, OFFSET arrayStr ; prepares the string arrayStr to be outputted
        call WriteString ; outputs the string arrayStr

        mov eax, lightBlue + (black * 16) ; this sets the color of the text to blue and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        pop eax ; this pops the iteration of the while loop from the FillArray label
        mov ebx, eax ; this sets ebx equal to the value of the popped eax
        .IF ebx != 25 ; if ebx is not equal to 25
            dec ebx ; then decrease ebx. this is necrssary for formatting the red font on the default-generated
                    ; array values
        .ENDIF

        mov ecx, 0 ; sets ecx equal to 0

        .WHILE ecx < ebx ; while the value of the ecx register is less than the value of the ebx register
            mov eax, intArray[ecx*TYPE intArray] ; set eax equal to the index equal to the value of ecx in the intArray array
            call WriteDec ; output eax
              
            mov al, ' ' ; prepare the character ' ' to be outputted
            call WriteChar ; outout ' '

            inc ecx ; increase ecx by 1
        .ENDW

        mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        .WHILE ecx < LENGTHOF intArray ; while ecx is less than the number of elements in intArray
            mov eax, intArray[ecx*TYPE intArray] ; set eax equal to the index equal to the value of ecx in the intArray array
            call WriteDec ; output the value in eax
              
            mov al, ' ' ; prepare ' ' to be outputted
            call WriteChar ; output ' '

            inc ecx ; increase ecx by 1
        .ENDW


        call Crlf ; new line

    FindMinMax:
        call ArrayMinMaxFinder ; this runs the ArrayMinMaxFinder procedure

        call Crlf ; new line

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        mov edx, OFFSET minIntStr ; this prepares the string minIntStr
        call WriteString ; output the string minIntStr

        mov eax, lightBlue + (black * 16) ; this sets the color of the text to blue and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        mov eax, minVal ; prepare the variable minVal to be outputted
        call WriteDec ; output the variable minVal

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        call Crlf ; new line
        call Crlf ; new line

        mov edx, OFFSET maxIntStr ; prepares the string maxIntStr to be outputted
        call WriteString ; outputs the string maxIntStr

        mov eax, lightBlue + (black * 16) ; this sets the color of the text to blue and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        mov eax, maxVal ; prepares the variable maxVal to be outputted
        call WriteDec ; outputs the variable maxVal

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax
        
        call Crlf ; new line

    FindAverage:
        call ArrayAverageFinder ; this runs the ArrayAverageFinder procedure

        call Crlf ; new line

        mov edx, OFFSET avgValStr ; this prepares the string avgValStr to be outputted
        call WriteString ; this outputs the avgValStr

        mov eax, lightBlue + (black * 16) ; this sets the color of the text to blue and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        mov eax, averageVal ; this prepares the variable averageVal to be outputted
        call WriteDec ; this outputs the variable averageVal

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax
        
        call Crlf ; new line

    FindEvensAndOdds:

        call ArrayOddsEvensSorter ; this calls the ArrayOddsEvensSorter procedure

        call Crlf ; new line

        mov edx, OFFSET oddsArrayStr ; this prepares the string oddsArrayStr to be outputted
        call WriteString ; this outputs the string oddsArrayStr

        mov ecx, 0 ; set ecx equal to 0

        mov eax, lightBlue + (black * 16) ; this sets the color of the text to blue and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        .IF oddsCounter == 0 ; if the variable oddsCounter is equal to 0
            mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
            call SetTextColor ; this sets the text color to the value in eax

            mov edx, OFFSET noValsStr ; prepare the string noValsStr to be outputted
            call WriteString ; output he string noValsStr
        .ENDIF

        .WHILE ecx < oddsCounter ; while ecx is less than the variable oddsCounter
            mov eax, odds[ecx*TYPE odds] ; set eax equal to the index equal to the value of ecx in the odds array
            call WriteDec ; this outputs eax
            mov al, ' ' ; this prepares ' ' to be outputted
            call WriteChar ; this outputs ' '
            inc ecx ; increase ecx by 1
        .ENDW

        call Crlf ; new line
        call Crlf ; new line

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        mov edx, OFFSET evensArrayStr ; prepare the string evensArrayStr to be outputted
        call WriteString ; output the string evensArrayStr

        mov ecx, 0 ; set ecx equal to 0

        mov eax, lightBlue + (black * 16) ; this sets the color of the text to blue and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        .IF evensCounter == 0 ; if the variable evensCounter is equal to 0
            mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
            call SetTextColor ; this sets the text color to the value in eax

            mov edx, OFFSET noValsStr ; prepare the string noValsStr to be outputted
            call WriteString ; output thhe string noValsStr
        .ENDIF

        .WHILE ecx < evensCounter ; while ecx is less than the variable evensCounter 
            mov eax, evens[ecx*TYPE evens] ; set eax equal to the index equal to the value of ecx in the evens array
            call WriteDec ; output eax
            mov al, ' ' ; prepare ' ' to be outputted
            call WriteChar ; output ' '
            inc ecx ; increase ecx by 1
        .ENDW

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        call Crlf ; new line
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
            jmp ClearArrays ; jump to the ClearArrays label
        .ELSEIF answer[0] == 'n' || answer[0] == 'N' ; if the answer is no
            ret ; end the program
        .ELSE ; if the answer is not yes or no
            mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
            call SetTextColor ; this sets the text color to the value in eax
            
            mov edx, OFFSET errorMessage2 ; prepares the string errorMessage to be displayed
            call WriteString ; displays a string from the edx offset

            mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
            call SetTextColor ; this sets the text color to the value in eax

            call Crlf ; new line 
            jmp TryAgain ; jump to the TryAgain label
        .ENDIF ; end the if statements

    ClearArrays:
        mov ecx, 0 ; set ecx equal to 0
        mov eax, 0 ; set eax equal to 0

        .WHILE ecx < oddsCounter ; while ecx is less than the variable of oddsCounter 
            mov odds[ecx*TYPE odds], eax ; set the index equal to the value of ecx in the odds array equal to the eax register
            inc ecx ; increase ecx by 1 
        .ENDW

        mov ecx, 0 ; set ecx equal to 0

        .WHILE ecx < evensCounter ; while ecx is less than the variable evensCounter
            mov evens[ecx*TYPE evens], eax ; set the index equal to the value of ecx in the evens array equal to the eax register
            inc ecx ; increase ecx by 1
        .ENDW

        mov oddsCounter, 0 ; reset the oddsCounter
        mov evensCounter, 0 ; reset the evensCounter 
        mov ecx, 0 ; set ecx equal to 0
        mov eax, 0 ; set eax equal to 0

        .WHILE ecx < LENGTHOF intArray ; while ecx is less than the number of elements in the array intArray 
            mov intArray[ecx*TYPE intArray], eax ; set the index equal to the value of ecx in the intArray array equal to the eax register
            inc ecx ; increase ecx by 1
        .ENDW

        jmp Prompt ; jump to the prompt label.

    InvalidInput:
        mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
        call SetTextColor ; this sets the text color to the value in eax
        
        pop eax ; pull a value from the top of the stack and place it into the eax register. this is done to avoid
                ; any unexpected stack behavior

        call Crlf ; new line

        mov edx, OFFSET errorMessage ; prepare errorMessage to be outputted
        call WriteString ; output the errorMessage string

        push eax ; puts eax on the top of the stack

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        pop eax ; pull a value from the top of the stack and place it into the eax register.

        call Crlf ; new line
        call Crlf ; new line

        jmp FillArray ; jump to the FillArray label

    ret
MainProgram ENDP

main PROC

    call MainProgram ; run the MainProgram program.

    INVOKE ExitProcess,0

main ENDP

END main
