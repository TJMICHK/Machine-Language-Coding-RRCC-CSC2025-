; **********************************************************************;
; Program Name: Hangman Game
; Program Description: 
; Author: Terrence Micciche Hall
; Course: CSC2025X40
; Creation Date: 07/20/26
; Revisions: 0
; Date Last Modified: 07/20/26
; Test Cases:
;
; Notable Bugs:
;
;***********************************************************************;

INCLUDE C:\Irvine\Irvine32.inc
INCLUDELIB C:\Irvine\Irvine32.lib

.data

    ;*************************************
    ; THE DATA BELOW ARE OUTPUT STRINGS. THESE STRINGS ARE USED FOR PROMPTING
    ; THE USER.
    ;*************************************

    word1 BYTE "Argentina", 0 ; this declares the first word to be guessed in the hangman game.
    word2 BYTE "Columbia", 0 ; this declares the second word to be guessed in the hangman game.
    word3 BYTE "Brazil", 0 ; this declares the third word to be guessed in the hangman game.
    word4 BYTE "Venezuela", 0 ; this declares the fourth word to be guessed in the hangman game.
    word5 BYTE "Bolivia", 0 ; this declares the fifth word to be guessed in the hangman game.
    word6 BYTE "Ecuador", 0 ; this declares the sixth word to be guessed in the hangman game.
    word7 BYTE "Paraguay", 0 ; this declares the seventh word to be guessed in the hangman game.
    word8 BYTE "Uruguay", 0 ; this declares the eighth word to be guessed in the hangman game.
    word9 BYTE "Guyana", 0 ; this declares the ninth word to be guessed in the hangman game.
    word10 BYTE "Suriname", 0 ; this declares the tenth word to be guessed in the hangman game.

    promptStartGame BYTE "Hello! Welcome to the Hangman Game (South America Edition). Would you like to play? (y/n)? ", 0 ; this prompt the user to decide whether they'd like to play the game or not.

    displayRightGuessChar BYTE "You have guessed a correct letter!", 0

    displayWrongGuessChar BYTE "You have guessed an incorrect letter!", 0

    promptEnterChar BYTE "Please enter a letter to guess: ", 0

    promptGuessWord BYTE "Would you like to guess the word? (y/n)? ", 0

    promptEnterWord BYTE "Please enter the word to guess: ", 0

    displayRightGuessWord BYTE "You have guessed the correct word!", 0

    displayWrongGuessWord BYTE "You have guessed the incorrect word!", 0

    displayWonGame BYTE "Congratulations! You have won the game!", 0

    displayLostGame BYTE "Welp... you lost! Better luck next time.", 0

    promptTryAgain BYTE "Would you like to try again? (y/n)? ", 0 ; this prompt the user to decide whether they'd like to continue the program or not.
    promptErrorResp BYTE "You have entered an invalid response. Please check your response and try again", 0 ; this declares that the user entered an invalid response, then it prompts
                                                                                                            ; the user to try again
    ;*************************************
    ; THE DATA BELOW ARE INPUT VARIABLES AND ARRAYS. THIS DATA IS USED FOR
    ; HOLDING USER INPUTTED DATA.
    ;*************************************

    wordBankOffsets DWORD OFFSET word1, OFFSET word2, OFFSET word3, OFFSET word4, OFFSET word5, OFFSET word6, OFFSET word7, OFFSET word8, OFFSET word9, OFFSET word10 ; this is an initialized array of DWORD elements.
                                                                                                                                                                      ; the elements are initialized to the offsets of the 
                                                                                                                                                                      ; strings titled word1-word10. this array is used to
                                                                                                                                                                      ; hold the offsets of the 10 words that are used in the hangman game.

    wordBankMax DWORD 10 ; this is an initialized DWORD variable. this is used to determine the maximum number of words that can be randomly selected from the wordBankOffsets array.

    userGuessChar BYTE 2 DUP(0) ; this is an initialized array of BYTE elements. the elements are initialized to 0. this string are used to hold the user's guess of a character.

    userGuessWord BYTE 17 DUP(0) ; this is an initialized array of BYTE elements. the elements are initialized to 0. this string are used to hold the user's guess of the word.

    userGuessWordLength DWORD ? ; this is an uninitialized DWORD variable. this variable is used to hold the length of the user's guess of the word.

    chosenWordOffset DWORD 0 ; this is an initialized DWORD variable. this variable is used to hold the offset of the randomly selected word from the wordBankOffsets array.

    chosenWordLength DWORD ? 

    guessesMax DWORD ?

    boolGameWon DWORD ? ; this is an initialized DWORD variable. this variable is used to determine whether the user has won the game or not. 1 is true and 0 is false.

    alphabet DWORD 26 DUP(0) ; this is an initialized array of BYTE elements. the elements are initialized to 0. this array is used to hold the alphabet letters that have been guessed by the user.

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
;	Memory locations use and associated purpose of each:
;       promptTryAgain - This is a string used to prompt the user to make the decision of whether or not they'd like to run the program again.
;       promptErrorTry - This is a string used to inform the user that their response to the TryAgain label is invalid. It then prompts the user to re-enter their response.
;       answer - This is an array that is used to hold the user's response to the TryAgain label.
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
MainProgram PROC

    StartGame:
        mov edx, OFFSET promptStartGame ; prepares the string promptStartGame to be displayed
        call WriteString ; this displays the string promptStartGame


        mov edx, OFFSET answer ; this selects the array answer to be filled with a string
        mov ecx, SIZEOF answer ; this sets the size of the answer to 2. this includes the character y or n, as well as the
                               ; null terminator

        mov eax, lightBlue + (black * 16) ; this sets the color of the text to light blue and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        call ReadString ; this reads a string then saves the input in the edx offset

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        AnswerCheckStart:
            .IF answer[0] == 'y' || answer[0] == 'Y' ; if the answer is yes
                call Crlf ; new line 

                jmp PlayGame ; jump to the PlayGame label
            .ELSEIF answer[0] == 'n' || answer[0] == 'N' ; if the answer is no
                jmp EndProgram
            .ELSE ; if the answer is not yes or no
                call Crlf ; new line 

                mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
                call SetTextColor ; this sets the text color to the value in eax
            
                mov edx, OFFSET promptErrorResp ; prepares the string promptErrorResp to be displayed
                call WriteString ; displays a string from the edx offset

                mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                call Crlf ; new line 
                jmp AnswerCheckStart ; jump to the AnswerCheckStart label
            .ENDIF ; end the if statements

    PlayGame:
        mov guessesMax, 4 ; this sets the maximum number of guesses to 4
        mov boolGameWon, 0 ; this sets the variable boolGameWon to false

        SeedRandom:
            call Randomize ; this seeds the random number generator with the current time
            mov eax, wordBankMax

            call RandomRange ; this generates a random number between 0 and the value in eax. the random number is stored in eax

        ChosenWord:
            mov ebx, wordBankOffsets[eax * 4] ; this moves the offset of the randomly selected word from the wordBankOffsets array into ebx

            mov chosenWordOffset, ebx ; this stores the offset of the randomly selected word in the chosenWordOffset variable.

            mov eax, 0

            mov esi, chosenWordOffset

            .WHILE BYTE PTR [esi + eax] != 0
                inc eax ; increase eax by 1
            .ENDW
                
            mov chosenWordLength, eax ; this stores the length of the randomly selected word in the chosenWordLength variable.

        GuessWordOrChar:
            mov edx, OFFSET promptGuessWord ; prepares the string promptGuessWord to be displayed
            call WriteString ; this displays the string promptGuessWord

            mov edx, OFFSET answer ; this selects the array answer to be filled with a string
            mov ecx, SIZEOF answer ; this sets the size of the answer to 2. this includes the character y or n, as well as the
                                   ; null terminator

            mov eax, lightBlue + (black * 16) ; this sets the color of the text to light blue and the background to black
            call SetTextColor ; this sets the text color to the value in eax

            call ReadString ; this reads a string then saves the input in the edx offset

            mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
            call SetTextColor ; this sets the text color to the value in eax

            .IF answer[0] == 'y' || answer[0] == 'Y' ; if the answer is yes
                call Crlf ; new line 

                jmp GuessWord ; jump to the GuessWord label
            .ELSEIF answer[0] == 'n' || answer[0] == 'N' ; if the answer is no
                call Crlf ; new line 

                jmp GuessChar ; jump to the GuessChar label
            .ELSE ; if the answer is not yes or no
                call Crlf ; new line 

                mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
                call SetTextColor ; this sets the text color to the value in eax
            
                mov edx, OFFSET promptErrorResp ; prepares the string promptErrorResp to be displayed
                call WriteString ; displays a string from the edx offset

                mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                call Crlf ; new line 
                jmp GuessWordOrChar ; jump to the GuessWordOrChar label
            .ENDIF ; end the if statements

        GuessWord:
            mov edx, OFFSET promptEnterWord ; prepares the string promptEnterWord to be displayed
            call WriteString ; this displays the string promptEnterWord

            mov edx, OFFSET userGuessWord ; this selects the array userGuessWord to be filled with a string
            mov ecx, SIZEOF userGuessWord ; this sets the size of the userGuessWord to 17. this includes the word guessed, as well as the
                                          ; null terminator

            mov eax, lightBlue + (black * 16) ; this sets the color of the text to light blue and the background to black
            call SetTextColor ; this sets the text color to the value in eax

            call ReadString ; this reads a string then saves the input in the edx offset

            mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
            call SetTextColor ; this sets the text color to the value in eax

            call Crlf ; new line

            mov esi, chosenWordOffset
            mov edi, OFFSET userGuessWord

            call Str_compare
            je TrueWord
            jne FalseWord

            TrueWord:
                mov edx, OFFSET displayRightGuessWord ; prepares the string displayRightGuessWord to be displayed
                call WriteString ; this displays the string displayRightGuessWord

                inc boolGameWon ; set the variable boolGameWon to true

                call Crlf ; new line
                call Crlf ; new line

                jmp EndGame ; jump to the EndGame label
            FalseWord:
                mov edx, OFFSET displayWrongGuessWord ; prepares the string displayWrongGuessWord to be displayed
                call WriteString ; this displays the string displayWrongGuessWord

                call Crlf ; new line
                call Crlf ; new line

                jmp EndGame ; jump to the EndGame label
                

        GuessChar:
            cmp guessesMax, 0
            je EndGame

            mov edx, OFFSET promptEnterChar ; prepares the string promptEnterChar to be displayed
            call WriteString ; this displays the string promptEnterChar
        
            mov edx, OFFSET userGuessChar ; this selects the array userGuessChar to be filled with a string
            mov ecx, SIZEOF userGuessChar ; this sets the size of the userGuessChar to 2. this includes the character guessed, as well as the
                                          ; null terminator

            mov eax, lightBlue + (black * 16) ; this sets the color of the text to light blue and the background to black
            call SetTextColor ; this sets the text color to the value in eax

            call ReadString ; this reads a string then saves the input in the edx offset

            mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
            call SetTextColor ; this sets the text color to the value in eax

            call Crlf ; new line

            mov al, userGuessChar[0] ; this moves the guessed character into al

            CheckChar:
                .IF al < 'A' || al > 'Z' && al < 'a' || al > 'z' 
                    ; error state
                .ENDIF

            ConvertChar:
                or al, 00100000b ; this converts any letter into its lower-case equivalent

                mov bl, al

                sub al, 'a' ; this converts that letter into its corresponding number in the alphabet (0-25)

                movzx eax, al ; this moves the value in al into eax and zero-extends it to 32 bits

                cmp alphabet[eax], 1
                ; jump if equal to error state of char already guessed

                inc alphabet[eax*4] ; this increments the value in the alphabet array at the index of the guessed character by 1

            SearchWord:
                mov ecx, 0
                
                mov esi, chosenWordOffset

                .WHILE ecx < chosenWordLength
                    mov al, [esi + ecx]

                    cmp al, bl
                    je TrueChar

                    sub bl, 20h ; this converts the guessed character into its upper-case equivalent

                    cmp al, bl ; 
                    je TrueChar

                    inc ecx
                .ENDW

                jmp FalseChar

            TrueChar:
                mov eax, lightGreen + (black * 16) ; this sets the color of the text to light green and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov edx, OFFSET displayRightGuessChar ; prepares the string displayRightGuessChar to be displayed
                call WriteString ; this displays the string displayRightGuessChar

                mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                call Crlf ; new line
                call Crlf ; new line

                dec guessesMax
                
                jmp GuessWordOrChar

            FalseChar:
                mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov edx, OFFSET displayWrongGuessChar ; prepares the string displayWrongGuessChar to be displayed
                call WriteString ; this displays the string displayWrongGuessChar

                mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                call Crlf ; new line
                call Crlf ; new line

                dec guessesMax

                jmp GuessWordOrChar

    EndGame:
        cmp boolGameWon, 1
        je WonGame

        LostGame:
            mov edx, OFFSET displayLostGame ; prepares the string displayLostGame to be displayed
            call WriteString ; this displays the string displayLostGame

            call Crlf ; new line

            jmp TryAgain ; jump to the TryAgain label

        WonGame: 
            mov edx, OFFSET displayWonGame ; prepares the string displayWonGame to be displayed
            call WriteString ; this displays the string displayWonGame

            call Crlf ; new line

            jmp TryAgain ; jump to the TryAgain label

    TryAgain: ; this label prompts the user to decide whether they'd like to continue the program or not
        call Crlf ; new line

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

            jmp PlayGame ; jump to the EnterDecimal label
        .ELSEIF answer[0] == 'n' || answer[0] == 'N' ; if the answer is no
            jmp EndProgram
        .ELSE ; if the answer is not yes or no
            call Crlf ; new line 

            mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
            call SetTextColor ; this sets the text color to the value in eax
            
            mov edx, OFFSET promptErrorResp ; prepares the string promptErrorResp to be displayed
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
