; **********************************************************************;
; Program Name: Guess The Number Game
; Program Description: This program generates a random number between 1 and 50, prompts the user to guess what the number is, then
; advises the user whether their guess is too high, too low, or correct. The user only has 10 guesses to correctly determine
; the programs random number.
; Author: Terrence Micciche Hall
; Creation Date: 06/11/26
; Revisions:0
; Date Last Modified: 06/12/26
;***********************************************************************;

INCLUDE C:\Irvine\Irvine32.inc
INCLUDELIB C:\Irvine\Irvine32.lib

.data
    
    outOfGuessesStr BYTE "You were not able to guess the right number in 10 guesses... The correct number was ",0 ; this is the first part of a two part fail state string
    outOfGuessesStr2 BYTE "Maybe you should practice more?", 0 ; this is the second part of a two part fail state string.

    winningGuessStr BYTE "You won in ", 0 ; this is the first part of a two part win state string.
    winningGuessStr2 BYTE " guesses.", 0 ; this is the second part of a two part win state string.
    
    congratsStr BYTE "Congratulations! You have guessed the right number. ", 0 ; creates a congratulation string. this string preceeds the
                                                                               ; win state string.

    tooHighStr BYTE "The number you guessed is too high. ", 0 ; creates a string which advises the user that their guess is too high
    
    guessesLeftStr BYTE "You now have ", 0 ; this is the first part of a two part advisary string that tells the user
                                           ; how many guesses they have left
    guessesLeftStr2 BYTE " guesses left.", 0 ; this is the first part of a two part advisary string that tells the user
                                             ; how many guesses they have left

    tooLowStr BYTE "The number you guessed is too low. ", 0 ; creates a string which advises the user that their guess is too low
    
    randomNumber DWORD ? ; this is an uninitialized variable of the DWORD data-type that is used to hold the programs randomly
                         ; generated number

    promptGuessStr BYTE "Please guess the random number between 1 to 50:  ", 0 ; creates a request for the user to guess a
                                                                            ; random number

    errorMessage BYTE "Please re-enter the value.  ", 0 ; creates a request to re-enter a value string

    tryAgainStr BYTE "Would you like to play again? (y/n)? ", 0 ; creates a request to run the program again string

    answer BYTE 2 DUP(0) ; creates an array to hold the response to tryAgainStr. this includes the null terminator



; **********************************************************************;
; Functional description of the main program
;   Inputs: The main program does not require any user inputs directly. The user may input values to answer any outputted promps.
;	Outputs: The main program does not output anything directly. The main program displays prompts for the user.
;	Registers used and associated purpose of each:
;       EDX - This is the Extended Data register. This register is used to store the offset for strings.
;       EAX - This is the Extended Accumulator register. This register is used to store integers as well as any
;       calculations.
;       AL - This is the Accumulator Low register. This register is used to store characters.
;       ECX - This is the Extended Count register. This register is used to keep track of the amount of guesses the user has left. 
;	Memory locations use and associated purpose of each
;       outOfGuessesStr - This is an initialized string of the BYTE data-type. This is used as the first half of a string that tells the user that they
;       are out of guesses. This string also participates in telling the user what the correct number was.
;       outOfGuessesStr2 - This is an initialized string of the BYTE data-type. This is used as the second half of a string that tells the user that they
;       are out of guesses. This string also participates in telling the user what the correct number was.
;       winningGuessStr - This is an initialized string of the BYTE data-type. This is used as the first half of a string that tells the user how many
;       guesses it took for them to win.
;       winningGuessStr2 - This is an initialized string of the BYTE data-type. This is used as the second half of a string that tells the user how many
;       guesses it took for them to win.
;       congratsStr - This is an initialized string of the BYTE data-type. This is used to congratulate the user on getting the right number.
;       tooHighstr - This is an initialized string of the BYTE data-type. This is used to inform the user that their guess is higher than the generated number.
;       guessesLeftStr - This is an initialized string of the BYTE data-type. This is used as the first half of a string that tells th euser how many
;       guesses they have left.
;       guessesLeftStr2 - This is an initialized string of the BYTE data-type. This is used as the second half of a string that tells the user how many guesses
;       they have left.
;       tooLowStr - This is an initialized string of the BYTE data-type. This is used to inform the user that their guess is lower than the generated number.
;       randomNumber - This is an uninitialized variable of the DWORD data type. This is used to hold the randomNumber that is generated by the program.
;       promptGuessStr - This is an initialized string of the BYTE data-type. This is used to prompt the user to guess a number between 1 and 50.
;       errorMessage - This is an initialized string of the BYTE data-type. This is used to prompt the user to re-enter a value. This string is
;       particularly used whenever an integer or character that the program is not expecting is inputted.
;       tryAgainStr - This is an initialized string of the BYTE data-type. This is used to prompt the user to either continue the program or to
;       end the program.
;       answer - This is an initialized array of all zeros of the data-type BYTE. This is used to hold both the user-inputted response to the
;       string tryAgainStr as well as the null terminator. The answer variable was created as a string as to perfectly match the example given
;       in part one of the CSC2025X40 Programming Homework for week three.
;	Functional details: This main program calls the NumberGuesser procedure, which handles all outputting, inputting, as well as register
;   management.
; **********************************************************************;

.code

;***********************************
; Description: This procedure reads an integer input, then displays an error message if the input is not an integer.
; The procedure does not end until an integer is inputted. In addition to this, the procedure decreases the number
; of guesses for every bad input and then tells the user how many guesses they have left.
; Recieves: This procedure recieves nothing.
; Returns: This procedure returns a valid integer in the eax register.
; Requires: This procedure requires the Irvine32 library.
;***********************************
GetValidInt PROC
    Read: ; this label reads the input
        .IF ecx == 0 ; if the user is out of guesses
            ret ; end the call
        .ENDIF

        call ReadInt ; reads an integer. note that ReadInt saves the input in the eax register
        jo BadInput ; if an overflow flag is thrown, such that the input of the ReadInt is not an integer, then the program
                    ; jumps to the BadInput label.
        .IF eax < 1 || eax > 50 ; if the user guessed a value that is less than zero or greater than fifty
            jmp BadInput ; then jump to the BadInput label
        .ENDIF

        ret ; this ends the call
    
    BadInput: ; this label acts accordingly if the input is not an integer
        dec ecx ; decreases the number of guesses left

        .IF ecx == 0 ; if the user is out of guesses
            ret ; end the call
        .ENDIF

        call Crlf ; new line
        mov edx, OFFSET errorMessage ; prepares errorMessage to be displayed. note that strings are 'saved' in
                                     ; the edx register
        call WriteString ; calls errorMessage from edx
        mov edx, OFFSET guessesLeftStr ; prepares a string to be displayed
        call WriteString ; displays the guessesLeftStr
        mov eax, ecx ; prepares an int to be displayed
        call WriteDec ; displays the amount of guesses
        mov edx, OFFSET guessesLeftStr2 ; prepares a string to be displayed
        call WriteString ; displays the string guessesLeftStr2

        jmp Read ; this jumps to the Read label
GetValidInt ENDP

;***********************************
; Description: This procedute first generates a random number between 1 to 50, then it prompts the user to
; guess the number. Once the user makes a guess, the program informs the user whether or not the number is
; correct, too high, or too low. If the number is too high or too low, the program prompts the user to try
; again. The user is allowed to use up to 10 guesses. If the user enters a value less than 1, greater than 50,
; or a non-numeric value for any entry, then an error message is displayed and a guess is spent. If the correct
; value is reached, a congratulatory message is provided and the user is offered to play again. If 10 tries
; are utilized without a correct answer, then a message indicating that the user has lost is displayed. The
; user is then made aware of what the random number was. A play again option is displayed in both of the conditions
; that the user wins or loses.
; Recieves: This procedure indirectly recieves a user inputted integer to serve as their guess. There are no
; parameters for this procedure.
; Returns: This procedure does not directly return anything.
; Requires: This procedure requires the procedure GetValidInt as well as the Irvine32 library.
;***********************************
NumberGuesser PROC

    GenerateNumber: ; this label generates a random number
        call Randomize ; seeds the random number generator
        mov ecx, 10 ; sets the number of guesses at 10
        
        mov eax, 50 ; sets the limit for the RandomRange procedure
        call RandomRange ; generates a number from 0 to 49
        inc eax ; ensures the random number is between 1 to 50
        mov randomNumber, eax ; saves the random number in memory
        
        jmp GuessTheNumber ; jump to the PromptGuess label
        
    GuessTheNumber: ; this label runs the par tof the program that asks the user to guess a number, then checks if the number is
                    ; correct, too high, or too low.
        mov edx, OFFSET promptGuessStr ; prepares a string to be displayed
        call WriteString ; displays the string promptGuessStr
        call GetValidInt ; calls the GetValidInt procedure

        call Crlf ; new line

        jmp FailState ; jumps to the FailState label

        FailState: ; this label is the fail state
            .IF ecx == 0 ; if the amount of guesses is 0
                call Crlf ; new line. this second new line ensures convienence of reading
                mov edx, OFFSET outOfGuessesStr ; prepares a string to be displayed
                call WriteString ; displays the string outOfGuessesStr
                mov eax, randomNumber ; prepares the variable randomNumber to be displayed
                call WriteDec ; displays the variable randomNumber
                mov al, '.' ; prepares the char '.' to be displayed
                call WriteChar ; displays the char '.'
                call Crlf ; new line
                mov edx, OFFSET outOfGuessesStr2 ; prepares a string to be displayed
                call WriteString ; displays the string outOfGuessesStr
                call Crlf ; new line
                jmp TryAgain ; jump to the TryAgain label
            .ELSE
                jmp IfConditions ; jumps to the IfConditions label
            .ENDIF

        IfConditions: ; this label determines the whether the guessed number is correct, too high, or too low.
            .IF eax < randomNumber ; if the user guessed lower than the random number
                dec ecx ; decrease the number of guesses
                mov edx, OFFSET tooLowStr ; prepares a string to be displayed
                call WriteString ; displays the string tooLowStr
                .IF ecx == 0 ; if the user is out of guesses
                    call Crlf ; new line
                    jmp FailState ; jumps to the FailState label
                .ENDIF
                mov edx, OFFSET guessesLeftStr ; prepares a string to be displayed
                call WriteString ; displays the string guessesLeftStr
                mov eax, ecx ; prepares an int to be displayed
                call WriteDec ; displays the amount of guesses left
                mov edx, OFFSET guessesLeftStr2 ; prepares a string to be displayed
                call WriteString ; displays the string guessesLeftStr2

            .ELSEIF eax > randomNumber ; if the user guessed higher than the random number
                dec ecx ; decrease the number of guesses
                mov edx, OFFSET tooHighStr ; prepares a string to be displayed
                call WriteString ; displays the string tooHighStr
                .IF ecx == 0 ; if the user is out of guesses
                    call Crlf ; new line
                    jmp FailState ; jumps to the fail state label
                .ENDIF
                mov edx, OFFSET guessesLeftStr ; prepares a string to be displayed
                call WriteString ; display the string guessesLeftStr
                mov eax, ecx ; prepares an int to be displayed
                call WriteDec ; displays the amount of guesses left
                mov edx, OFFSET guessesLeftStr2 ; prepares a string to be displayed
                call WriteString ; displays the string guessesLeftStr2

            .ELSEIF eax == randomNumber ; if the user guessed the random number
                dec ecx ; decrease the number of guesses
                mov edx, OFFSET congratsStr ; prepares a string to be displayed
                call WriteString ; displays the string congratsStr
                mov edx, OFFSET winningGuessStr ; prepares a string to be displayed
                call WriteString ; displays the string winningGuessStr
                mov eax, 10 ; moves the starting number of guesses into the eax register
                sub eax, ecx ; subtracts the number of guesses left from the eax register
                call WriteDec ; the result displayed by this function is how many guesses it took the user to guess
                              ; the correct number
                mov edx, OFFSET winningGuessStr2 ; prepares a string to be displayed
                call WriteString ; displays the string winningGuessStr2
                jmp TryAgain ; jump to the TryAgain lavel

            .ENDIF

        call Crlf ; new line
        jnz GuessTheNumber ; this is jump if not zero. if the ecx register is not zero, then jump to the GuessTheNumber
                           ; label. note that jnz does not automatically decrease the ecx register. the ecx register
                           ; must explicitly be decreased in the code.

    TryAgain: ; this label prompts the user to decide whether they'd like to continue the program or not
        call Crlf ; new line
        mov edx, OFFSET tryAgainStr ; prepares the string tryAgainStr to be displayed
        call WriteString ; this displays a string from edx
            
        mov edx, OFFSET answer ; this selects the array answer to be filled with a string
        mov ecx, SIZEOF answer ; this sets the size of the answer to 2. this includes the character y or n, as well as the
                               ; null terminator
        call ReadString ; this reads a string then saves the input in the edx offset

        .IF answer == 'y' || answer == 'Y' ; if the answer is yes
            call Crlf ; new line 
            jmp GenerateNumber ; jump to the GenerateNumber label
        .ELSEIF answer == 'n' || answer == 'N' ; if the answer is no
            ret ; end the program
        .ELSE ; if the answer is not yes or no
            call Crlf ; new line 
            mov edx, OFFSET errorMessage ; prepares the string errorMessage to be displayed
            call WriteString ; displays a string from the edx offset
            jmp TryAgain ; jump to the TryAgain label
        .ENDIF ; end the if statements

    ret
NumberGuesser ENDP

main PROC

    call NumberGuesser ; this starts the Guess the Number Game

    INVOKE ExitProcess,0

main ENDP

END main