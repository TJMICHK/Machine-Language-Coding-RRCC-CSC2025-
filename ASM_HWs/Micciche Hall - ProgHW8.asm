; **********************************************************************;
; Program Name: Hangman Game EXTRA CREDIT
; Program Description: This program is a hangman game that allows the user to guess a word from a list of 10 words.
;                      The user can choose to guess a letter or the entire word. The user has a maximum of 6 wrong
;                      guesses before losing the game. The program will display the hangman and the hidden word with
;					   underscores for each letter. The program will also display the letters that the user has already 
;                      guessed. If the wrong word is guessed, then the user will lose the game. If the correct word is
;                      guessed, then the user will win the game. If the user guesses all the letters in the word, then 
;                      the user will win the game.
; Author: Terrence Micciche Hall
; Course: CSC2025X40
; Creation Date: 07/20/26
; Revisions: 0
; Date Last Modified: 07/21/26
; Test Cases:
;       1, expected error - PASS
;       !, expected error - PASS
;       space character, expected error - PASS 
;       multiple characters, expected only first character used - PASS
;       previously guessed character, expected error - PASS
;       same letter guessed with different case, expected error - PASS
;       Guess Every Letter Correctly Without Error - PASS
;       Lose by Repeatedly Guessing Valid but Incorrect Letters - PASS
;       Guess A Correct Letter That Appears Multiple Times - PASS
;       Guess the Same Incorrect Letter Twice - PASS
;       Guess the Entire Word Immediately - PASS
;       Enter Several Invalid Characters, Then Enter A Valid Guess - PASS
; Notable Bugs:
;   NO KNOWN NOTABLE BUGS
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

    displayRightGuessChar BYTE "You have guessed a correct letter!", 0 ; this displays a message to the user that they have guessed a correct letter.

    displayWrongGuessChar BYTE "You have guessed an incorrect letter!", 0 ; this displays a message to the user that they have guessed an incorrect letter.

    promptEnterChar BYTE "Please enter a letter to guess: ", 0 ; this prompts the user to enter a letter to guess.

    promptGuessWord BYTE "Would you like to guess the word? (y/n)? ", 0 ; this prompts the user to decide whether they'd like to guess the word or not.

    promptEnterWord BYTE "Please enter the word to guess: ", 0 ; this prompts the user to enter the word to guess.

    displayRightGuessWord BYTE "You have guessed the correct word!", 0 ; this displays a message to the user that they have guessed the correct word.

    displayWrongGuessWord BYTE "You have guessed the incorrect word!", 0 ; this displays a message to the user that they have guessed the incorrect word.

    displayWonGame BYTE "Congratulations! You have won the game!", 0 ; this displays a message to the user that they have won the game.

    displayLostGame BYTE "Welp... you lost! Better luck next time.", 0 ; this displays a message to the user that they have lost the game.

    dispayCharRepeat BYTE "You have already guessed that letter. Please try again.", 0 ; this displays a message to the user that they have already guessed a letter.

    displayCharError BYTE "You have entered an invalid character. Please try again.", 0 ; this displays a message to the user that they have entered an invalid character.

    displayWordStr BYTE "The word was: ", 0 ; this displays a message to the user that tells them what the word was.

    hangmanTop BYTE     "	--------- ", 0 ; this declares the first line of the hangman. this is used to display the hangman to the user.
    hangmanTop2 BYTE    "	|       | ", 0 ; this declares the second line of the hangman. this is used to display the hangman to the user
    hangmanWrong1 BYTE  "	|       O ", 0 ; this declares the third line of the hangman. this is used to display the hangman to the user
    hangmanWrong2 BYTE  "	|       | ", 0 ; this declares the fourth line of the hangman. this is used to display the hangman to the user
    hangmanWrong3 BYTE "	|      /| ", 0 ; this declares the fourth line with an addition of an arm of the hangman. this is used to display the hangman to the user
    hangmanWrong4 BYTE "	|      /|\ ", 0 ; this declares the fourth line with an addition of both arms of the hangman. this is used to display the hangman to the user
    hangmanWrong5 BYTE "	|      /   ", 0 ; this declares the fifth line with an addition of a leg of the hangman. this is used to display the hangman to the user
    hangmanWrong6 BYTE "	|      / \ ", 0 ; this declares the fifth line with an addition of both legs of the hangman. this is used to display the hangman to the user
    hangmanBottom1 BYTE "	|         ", 0 ; this declares the sixth line of the hangman. this is used to display the hangman to the user
    hangmanBottom2 BYTE "	-----      ", 0 ; this declares the seventh line of the hangman. this is used to display the hangman to the user

    displayHiddenWord BYTE "The hidden word is: ", 0 ; this displays a message to the user that tells them what the hidden word is.

    displayGuessedChars BYTE "The letters you have already guessed are: ", 0 ; this displays a message to the user that tells them what letters they have already guessed.

    displayWordError BYTE "You have entered an invalid word. Please try again.", 0 ; this displays a message to the user that tells them they have entered an invalid word.

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

    chosenWordLength DWORD ? ; this is an uninitialized DWORD variable. this variable is used to hold the length of the randomly selected word from the wordBankOffsets array.

    guessesWrongMax DWORD ? ; this is an uninitialized DWORD variable. this variable is used to hold the maximum number of wrong guesses that the user can make before losing the game.

    arrayWordDisplay BYTE 17 DUP(0) ; this is an initialized array of BYTE elements. the elements are initialized to 0. this string is used to hold the word that the user is trying to guess.

    charsFound DWORD 0 ; this is an initialized DWORD variable. this variable is used to hold the number of characters that the user has found in the randomly selected word.

    charGuesses BYTE 36 DUP(0) ; this is an initialized array of BYTE elements. the elements are initialized to 0. this string is used to hold the letters that the user has guessed.

    charGuessesIndex DWORD 0 ; this is an initialized DWORD variable. this variable is used to hold the index of the charGuesses array.

    boolGameWon DWORD ? ; this is an initialized DWORD variable. this variable is used to determine whether the user has won the game or not. 1 is true and 0 is false.

    alphabet DWORD 26 DUP(0) ; this is an initialized array of BYTE elements. the elements are initialized to 0. this array is used to hold the alphabet letters that have been guessed by the user.

    answer BYTE 2 DUP(0) ; this is an initialized array of DWORD elements. the elements are initialized to 0, and they are used to keep track
                         ; of the response to the TryAgain label as well as the null terminator.

; **********************************************************************;
; Functional description of the main program
;   
;   Inputs: This program does not take any direct inputs. The user will have a chance however to input characters and words.
;
;   Outputs: This program does not have any direct outputs. The program will however display output strings.
;
;	Registers used and associated purpose of each:
;       EAX - This is the Extended Accumulator register. This register is used for basic arithmetic operations, storing
;             the return value of functions, and serving as the input for functions.
;       EBX - This is the Extended Base register. This register is used for holding offsets for string.
;	    ECX - This is the Extended Count register. This register is used for loops and sometimes serving as a pointer for strings.
;       EDX - This is the Extended Data register. This register is used for storing the offset of strings
;       ESI - This is the Extended Source Index register. This register is used as a pointer for strings.
;       AL - This is the Accumulator Low register. This register is used for storing characters.
;       BL - This is the Base Low register. This register is used for storing characters.
;       EDI - This is the Extended Destination Index register. This register is used as a register for strings.
;
;	Memory locations use and associated purpose of each:
;       word1 - This is a string that is used as the first word to be guessed in the hangman game.
;       word2 - This is a string that is used as the second word to be guessed in the hangman game.
;       word3 - This is a string that is used as the third word to be guessed in the hangman game.
;       word4 - This is a string that is used as the fourth word to be guessed in the hangman game.
;       word5 - This is a string that is used as the fifth word to be guessed in the hangman game.
;       word6 - This is a string that is used as the sixth word to be guessed in the hangman game.
;       word7 - This is a string that is used as the seventh word to be guessed in the hangman game.
;       word8 - This is a string that is used as the eighth word to be guessed in the hangman game.
;	    word9 - This is a string that is used as the ninth word to be guessed in the hangman game.
;       word10 - This is a string that is used as the tenth word to be guessed in the hangman game.
;       promptStartGame - This is a string used to prompt the user to make the decision of whether or not they'd like to play the hangman game.
;       displayRightGuessChar - This is a string used to inform the user that their guess of a character was correct.
;       displayWrongGuessChar - This is a string used to inform the user that their guess of a character was incorrect.
;       promptEnterChar - This is a string used to prompt the user to enter a character to guess.
;       promptGuessWord - This is a string used to prompt the user to make the decision of whether or not they'd like to guess the word.
;	    promptEnterWord - This is a string used to prompt the user to enter a word to guess.
;	    displayRightGuessWord - This is a string used to inform the user that their guess of a word was correct.
;	    displayWrongGuessWord - This is a string used to inform the user that their guess of a word was incorrect.
;       displayWonGame - This is a string used to inform the user that they have won the game.
;       displayLostGame - This is a string used to inform the user that they have lost the game.
;       dispayCharRepeat - This is a string used to inform the user that they have already guessed a character.
;       displayCharError - This is a string used to inform the user that they have entered an invalid character.
;	    displayWordStr - This is a string used to inform the user what the word was.
; 	    hangmanTop - This is a string used to display the top of the hangman.
;       hangmanTop2 - This is a string used to display the second line of the hangman.
;       hangmanWrong1 - This is a string used to display the third line of the hangman.
;       hangmanWrong2 - This is a string used to display the fourth line of the hangman.
;       hangmanWrong3 - This is a string used to display the fourth line of the hangman with an addition of an arm.
;       hangmanWrong4 - This is a string used to display the fourth line of the hangman with an addition of both arms.
;       hangmanWrong5 - This is a string used to display the fifth line of the hangman with an addition of a leg.
;       hangmanWrong6 - This is a string used to display the fifth line of the hangman with an addition of both legs.
;       hangmanBottom1 - This is a string used to display the sixth line of the hangman.
;       hangmanBottom2 - This is a string used to display the seventh line of the hangman.
;       displayHiddenWord - This is a string used to inform the user what the hidden word is.
;       displayGuessedChars - This is a string used to inform the user what letters they have already guessed.
;	    displayWordError - This is a string used to inform the user that they have entered an invalid word.
;       promptTryAgain - This is a string used to prompt the user to make the decision of whether or not they'd like to run the program again.
;       promptErrorTry - This is a string used to inform the user that their response to the TryAgain label is invalid. It then prompts the user to re-enter their response.
;       wordBankOffsets - This is an array that is used to hold the offsets of the words that are used in the hangman game.
;       userGuessChar - This is an array that is used to hold the user's guess of a character.
;       userGuessWord - This is an array that is used to hold the user's guess of a word.
;       userGuessWordLength - This is a variable that is used to hold the length of the user's guess of a word.
;       chosenWordOffset - This is a variable that is used to hold the offset of the randomly selected word from the wordBankOffsets array.
;       chosenWordLength - This is a variable that is used to hold the length of the randomly selected word from the wordBankOffsets array.
;       guessesWrongMax - This is a variable that is used to hold the maximum number of wrong guesses that the user can make before losing the game.
;       arrayWordDisplay - This is an array that is used to hold the word that the user is trying to guess.
;       charsFound - This is a variable that is used to hold the number of characters that the user has found in the randomly selected word.
;	    charGuesses - This is an array that is used to hold the letters that the user has guessed.
;       charGuessesIndex - This is a variable that is used to hold the index of the charGuesses array.
;       boolGameWon - This is a variable that is used to determine whether the user has won the game or not. 1 is true and 0 is false.
;       alphabet - This is an array that is used to hold the alphabet letters that have been guessed by the user.
;       answer - This is an array that is used to hold the user's response to the TryAgain label.
;	Functional details: 
;       This program first asks is the user would like to play the hangman game. If no, then the program ends. If yes, then the seed is randomized
;       and a word from the word bank is chosen randomly. The user then has 6 guesses to determine what the word is. With each guess, the user
;       may input a character. There are precautions in place to ensure invalid characters are not accepted. If the user is able to guess a correct
;       letter, they face no penalties. If the user guesses incorrectly, then the the user loses a guess. In the case that the user does not correctly
;       guess the entire word, they lose the game. In the case that the user does correctly guess the entire word, then the user wins the game. The user
;       also has the opportunity to guess the entire word. There are precautions in place to ensure invalid words are not accepted. If the user guesses
;       the right word, then the user wins the game. If the user guesses the wrong word, then they lose the game regardless of how many guesses they have
;       left. In addition to this basic functionality, with every correct letter guessed, the respective letter in the word will be displayed. All the other
;       characters that have not been guessed will remain as underscores. This program also displays all of the letters that the user guessed.
; **********************************************************************;

.code

;***********************************
; Description: This procedure handles the entire program.
; Receives: This procedure does not directly recieve anything.
; Returns: This procedure does not directly return anything.
; Requires: This procedure requires the Irvine32 library as well as every single memory variable in the .data section.
;***********************************
MainProgram PROC

    StartGame: ; this label is used to determine if the user would like to play the hangman game or not
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

    PlayGame: ; this label is used to run the hangman game
        SeedRandom: ; this label is used to randomize the seez
            call Randomize ; this seeds the random number generator with the current time
            mov eax, wordBankMax ; set eax with the value of the variable wordBankMax.

            call RandomRange ; this generates a random number between 0 and the value in eax. the random number is stored in eax

        ChosenWord: ; this label is used to determine the word chosen for the hangman game
            mov ebx, wordBankOffsets[eax * 4] ; this moves the offset of the randomly selected word from the wordBankOffsets array into ebx

            mov chosenWordOffset, ebx ; this stores the offset of the randomly selected word in the chosenWordOffset variable.

            mov eax, 0 ; set eax to 0

            mov esi, chosenWordOffset ; set esi equal to the value of the variable chosenWordOffset

            .WHILE BYTE PTR [esi + eax] != 0 ; this loop will continue until the null terminator is found
                inc eax ; increase eax by 1
            .ENDW
                
            mov chosenWordLength, eax ; this stores the length of the randomly selected word in the chosenWordLength variable.

        ResetVariables: ; this label is used to reset the variables and arrays used in the game
            mov guessesWrongMax, 6 ; this sets the maximum number of wrong guesses to 4
            mov boolGameWon, 0 ; this sets the variable boolGameWon to false
            mov charGuessesIndex, 0 ; set the variable charGuessesIndex to 0

            mov ecx, 0 ; set ecx to 0

            .WHILE ecx < LENGTHOF alphabet ; while ecx is less than the length of the alphabet array
                mov alphabet[ecx * 4], 0 ; this sets the value of the alphabet array at the index of the guessed character to 0
                inc ecx ; increase ecx by 1
            .ENDW

            mov ecx, 0 ; set ecx to 0

            .WHILE ecx < LENGTHOF arrayWordDisplay ; while ecx is less than the length of the arrayWordDisplay array
                mov arrayWordDisplay[ecx], 0 ; this sets the value of the arrayWordDisplay array at the index of the guessed character to 0
                inc ecx ; increase ecx by 1
            .ENDW

            mov ecx, 0 ; set ecx to 0

            .WHILE ecx < LENGTHOF userGuessWord ; while ecx is less than the length of the userGuessWord array
                mov userGuessWord[ecx], 0 ; this sets the value of the userGuessWord array at the index of the guessed character to 0
                inc ecx ; increase ecx by 1
            .ENDW

            mov ecx, 0 ; set ecx to 0

            .WHILE ecx < LENGTHOF charGuesses ; while ecx is less than the length of the charGuesses array
                mov charGuesses[ecx], 0 ; this sets the value of the charGuesses array at the index of the guessed character to 0
                inc ecx ; increase ecx by 1
            .ENDW

        SetupWordDisplay: ; this label is used to set up the arrayWordDisplay array to display the hidden word with underscores for each letter
            mov ecx, 0 ; set ecx to 0
            mov al, '_' ; set al to '_'

            .WHILE ecx < chosenWordLength ; while ecx is less than the length of the chosen word
                mov arrayWordDisplay[ecx], al ; this sets the value of the arrayWordDisplay array at the index of the guessed character to '_'
                inc ecx ; increase ecx by 1
            .ENDW

            call Crlf ; new line
            call Crlf ; new line


        DisplayWord: ; this label is used to display the hangman as well as the hidden word with underscores for each letter

            mov esi, OFFSET arrayWordDisplay ; this initialized esi as a pointer to the array arrayWordDisplay
            mov al, '_' ; set al with '_'

            .WHILE BYTE PTR [esi] != 0 ; while the pointer esi is not pointing to the null terminator
                .IF BYTE PTR [esi] == '_' ; if the pointer esi is pointing to '_'
                    jmp DisplayWord2 ; jump to the DisplayWord2 label
                .ENDIF

                inc esi ; increase the pointer esi by 1
            .ENDW

            inc boolGameWon ; set the variable boolGameWon to true
            jmp EndGame ; jump to the EndGame label

            DisplayWord2: ; this label is used to display the hangman as well as the hidden word with underscores for each letter.
                          ; this is the second label to the first one named "DisplayWord". it is made for the purpose of using the jmp instruction.
                .IF guessesWrongMax == 6  ; if the user has guessed no wrong letters
                    mov edx, OFFSET hangmanTop ; this selects the array hangmanTop to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanTop2 ; this selects the array hangmanTop2 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanBottom1 ; this selects the array hangmanBottom1 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanBottom1 ; this selects the array hangmanBottom1 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanBottom1 ; this selects the array hangmanBottom1 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanBottom1 ; this selects the array hangmanBottom1 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanBottom2 ; this selects the array hangmanBottom2 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    call Crlf ; new line

                .ELSEIF guessesWrongMax == 5 ; if the user has guessed 1 wrong letter
                    mov edx, OFFSET hangmanTop ; this selects the array hangmanTop to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanTop2 ; this selects the array hangmanTop2 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanWrong1 ; this selects the array hangmanWrong1 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanBottom1 ; this selects the array hangmanBottom1 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanBottom1 ; this selects the array hangmanBottom1 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanBottom1 ; this selects the array hangmanBottom1 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanBottom2 ; this selects the array hangmanBottom2 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    call Crlf ; new line

                .ELSEIF guessesWrongMax == 4 ; if the user has guessed 2 wrong letters
                    mov edx, OFFSET hangmanTop ; this selects the array hangmanTop to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanTop2 ; this selects the array hangmanTop2 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanWrong1 ; this selects the array hangmanWrong1 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanWrong2 ; this selects the array hangmanWrong2 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanBottom1 ; this selects the array hangmanBottom1 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanBottom1 ; this selects the array hangmanBottom1 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanBottom2 ; this selects the array hangmanBottom2 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    call Crlf ; new line
                .ELSEIF guessesWrongMax == 3 ; if the user has guessed 3 wrong letters
                    mov edx, OFFSET hangmanTop ; this selects the array hangmanTop to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanTop2 ; this selects the array hangmanTop2 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanWrong1 ; this selects the array hangmanWrong1 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanWrong3 ; this selects the array hangmanWrong3 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanBottom1 ; this selects the array hangmanBottom1 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanBottom1 ; this selects the array hangmanBottom1 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanBottom2 ; this selects the array hangmanBottom2 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    call Crlf ; new line
                .ELSEIF guessesWrongMax == 2 ; if the user has guessed 4 wrong letters
                    mov edx, OFFSET hangmanTop ; this selects the array hangmanTop to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanTop2 ; this selects the array hangmanTop2 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanWrong1 ; this selects the array hangmanWrong1 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanWrong4 ; this selects the array hangmanWrong4 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanBottom1 ; this selects the array hangmanBottom1 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanBottom1 ; this selects the array hangmanBottom1 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanBottom2 ; this selects the array hangmanBottom2 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    call Crlf ; new line
                .ELSEIF guessesWrongMax == 1 ; if the user has guessed 5 wrong letters
                    mov edx, OFFSET hangmanTop ; this selects the array hangmanTop to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanTop2 ; this selects the array hangmanTop2 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanWrong1 ; this selects the array hangmanWrong1 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanWrong4 ; this selects the array hangmanWrong4 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanWrong5 ; this selects the array hangmanWrong5 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanBottom1 ; this selects the array hangmanBottom1 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    mov edx, OFFSET hangmanBottom2 ; this selects the array hangmanBottom2 to be displayed
                    call WriteString ; this displays the string from the edx offset
                    call Crlf ; new line

                    call Crlf ; new line
                .ELSE
                    jmp EndGame ; jump to the EndGame label
                .ENDIF

                mov edx, OFFSET displayHiddenWord ; prepares the string displayHiddenWord to be displayed
                call WriteString ; this displays the string displayHiddenWord

                call Crlf ; new line
                call Crlf ; new line

                mov edx, OFFSET arrayWordDisplay ; this selects the array arrayWordDisplay to be displayed
                call WriteString ; this displays the string from the edx offset

                call Crlf ; new line
                call Crlf ; new line

                .IF charGuessesIndex > 0 ; if the user has guessed at least one letter
                    mov edx, OFFSET displayGuessedChars ; prepares the string displayGuessedChars to be displayed
                    call WriteString ; this displays the string displayGuessedChars

                    mov eax, lightBlue + (black * 16) ; this sets the color of the text to light blue and the background to black
                    call SetTextColor ; this sets the text color to the value in eax

                    mov edx, OFFSET charGuesses ; this selects the array charGuesses to be displayed
                    call WriteString ; this displays the string from the edx offset

                    mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                    call SetTextColor ; this sets the text color to the value in eax

                    call Crlf ; new line
                    call Crlf ; new line
                .ENDIF

        GuessWordOrChar: ; this label is used to determine whether the user would like to guess a letter or a word
            mov charsFound, 0 ; this resets the variable charsFound to 0
            
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
                call Crlf ; new line
                jmp GuessWordOrChar ; jump to the GuessWordOrChar label
            .ENDIF ; end the if statements

        GuessWord: ; this label is used in the case that the user chooses to guess a word.
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

            mov edi, OFFSET userGuessWord ; set edi as a pointer to the userGuessWord array

            mov al, BYTE PTR [edi] ; this moves the first character of the guessed word into al

            CheckWord: ; this label is used to determine if the guessed word is valid.

                .IF al == 0 ; if the first value of the variable userGuessedWord is the null terminator
                    jmp WordError ; jump to the WordError label
                .ENDIF

                .WHILE al != 0 ; while al is not equal to the null terminator
                    .IF (al < 'a' || al > 'z') && (al < 'A' || al > 'Z') ; if the guessed word is not a letter
                        jmp WordError ; jump to the WordError label
                    .ENDIF

                    inc edi ; increase the pointer edi by 1

                    mov al, BYTE PTR [edi] ; this moves the next character of the guessed word into al
                .ENDW

            mov edi, OFFSET userGuessWord ; set edi as a pointer to the userGuessWord array

            mov al, [edi] ; this moves the first character of the guessed word into al

            .IF al < 'A' || al > 'Z' ; if the guessed word is not a capital letter
                .IF al >= 'a' || al <= 'z' ; if the guessed word is a lower case letter
                    sub al, 20h ; convert al to a capital letter
                    mov [edi], al ; store the capital letter in the first spot of the userGuessWord array
                .ENDIF
            .ENDIF

            mov esi, chosenWordOffset ; set esi as a pointer to the chosenWordOffset array
            mov ecx, 0 ; set ecx to 0

            .WHILE BYTE PTR [esi + ecx] != 0 ; while the pointer esi + ecx is not pointing to the null terminator
                mov bl, BYTE PTR [edi + ecx] ; move the character at the current position in userGuessWord to bl
                
                cmp BYTE PTR [esi + ecx], bl ; compare the character at the current position in chosenWordOffset with the character in userGuessWord
                jne FalseWord ; if they are not equal, jump to the FalseWord label

                inc ecx ; increase ecx by 1
            .ENDW

            jmp TrueWord ; jump to the TrueWord label

            TrueWord: ; this label is used in the case that the user guesses the correct word.
                mov eax, lightGreen + (black * 16) ; this sets the color of the text to light green and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov edx, OFFSET displayRightGuessWord ; prepares the string displayRightGuessWord to be displayed
                call WriteString ; this displays the string displayRightGuessWord

                mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                inc boolGameWon ; set the variable boolGameWon to true

                call Crlf ; new line
                call Crlf ; new line

                jmp EndGame ; jump to the EndGame label

            FalseWord: ; this label is used in the case that the user guesses the wrong word.
                mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov edx, OFFSET displayWrongGuessWord ; prepares the string displayWrongGuessWord to be displayed
                call WriteString ; this displays the string displayWrongGuessWord

                mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                call Crlf ; new line
                call Crlf ; new line

                jmp EndGame ; jump to the EndGame label

            WordError: ; this label is used in the case that the user guesses a word that is not valid.
                mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov edx, OFFSET displayWordError ; prepares the string displayWordError to be displayed
                call WriteString ; this displays the string displayWordError

                mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                call Crlf ; new line
                call Crlf ; new line
                
                jmp GuessWord ; jump to the GuessWord label
                                
        GuessChar: ; this label is used in the case that the user chooses to guess a letter.
            cmp guessesWrongMax, 0 ; compare the value of guessesWrongMax to 0
            je EndGame ; jump to the EndGame label if the value of guessesWrongMax is equal to 0

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

            CheckChar: ; this label is used to determine if the guessed character is valid.
                .IF al < 'A' || al > 'Z' && al < 'a' || al > 'z' ; if the guessed character is not a letter
                    jmp CharError2 ; jump to the CharError label if the guessed character is not a letter
                .ENDIF

            ConvertChar: ; this label is used to convert the guessed character into its corresponding number in the alphabet (0-25)
                or al, 00100000b ; this converts any letter into its lower-case equivalent

                mov bl, al ; this saves the lower case letter in bl

                sub al, 'a' ; this converts that letter into its corresponding number in the alphabet (0-25)

                movzx eax, al ; this moves the value in al into eax and zero-extends it to 32 bits

                cmp alphabet[eax*4], 1 ; compare the value in the alphabet array at the index of the guessed character to 1
                je CharError ; jump to the CharError label if the value in the alphabet array at the index of the guessed character is equal to 1

                inc alphabet[eax*4] ; this increments the value in the alphabet array at the index of the guessed character by 1
                jmp SearchWord ; jump to the SearchWord label

            SearchWord: ; this label is used to search the chosen word for the guessed character
                mov ecx, 0 ; set ecx to 0
                
                mov esi, chosenWordOffset ; set esi as a pointer to the chosenWordOffset array

                WordIteration: ; this label is used to iterate through the chosen word to find the guessed character
                    .WHILE ecx < chosenWordLength ; while ecx is less than the length of the chosen word
                        mov al, [esi + ecx] ; this moves the character at the current position in chosenWordOffset to al

                        .IF al == bl ; if al is equal to bl
                            inc charsFound ; this increments the value of charsFound by 1
                            jmp CharReveal ; reveals lower case
                        .ENDIF

                        sub bl, 20h ; this converts the guessed character into its upper-case equivalent

                        .IF al == bl ; if al is equal to bl
                            inc charsFound ; this increments the value of charsFound by 1
                            jmp CharReveal ; reveals upper case
                        .ENDIF

                        add bl, 20h ; conver the guessed character into its lower-case equivalent

                        inc ecx ; increase ecx by 1
                    .ENDW
                    
                    jmp TrueOrFalseChar ; jump to the TrueOrFalseChar label

                CharReveal: ; this label is used to reveal the guessed character in the arrayWordDisplay array
                    mov arrayWordDisplay[ecx], al ; this sets the value of the arrayWordDisplay array at the index of the guessed character to the guessed character
                    inc ecx ; increase ecx by 1

                    .IF bl < 'a' || bl > 'z' ; if the guessed character is an upper case letter
                        add bl, 20h ; this converts the guessed character into its lower-case equivalent
                    .ENDIF

                    jmp WordIteration ; jump to the WordIteration label

                TrueOrFalseChar: ; this label is used to determine if the guessed character was found in the chosen word
                    cmp charsFound, 1 ; compare the value of charsFound to 1
                    jge TrueChar ; jump to the TrueChar label if the value of charsFound is greater than or equal to 1

                    jmp FalseChar ; jump to the FalseChar label if the value of charsFound is less than 1

                CharError: ; this label is used in the case that the user guesses a character that has already been guessed.
                    mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
                    call SetTextColor ; this sets the text color to the value in eax

                    mov edx, OFFSET dispayCharRepeat ; prepares the string dispayCharRepeat to be displayed
                    call WriteString ; this displays the string dispayCharRepeat

                    mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                    call SetTextColor ; this sets the text color to the value in eax
                    
                    call Crlf ; new line
                    call Crlf ; new line

                    jmp DisplayWord ; jump to the DisplayWord label

                CharError2: ; this label is used in the case that the user guesses a character that is not a letter.
                    mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
                    call SetTextColor ; this sets the text color to the value in eax

                    mov edx, OFFSET displayCharError ; prepares the string displayCharError to be displayed
                    call WriteString ; this displays the string displayCharError

                    mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                    call SetTextColor ; this sets the text color to the value in eax

                    call Crlf ; new line
                    call Crlf ; new line

                    jmp DisplayWord ; jump to the DisplayWord label

            TrueChar: ; this label is used in the case that the user guesses a character that is in the chosen word.
                mov eax, lightGreen + (black * 16) ; this sets the color of the text to light green and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov edx, OFFSET displayRightGuessChar ; prepares the string displayRightGuessChar to be displayed
                call WriteString ; this displays the string displayRightGuessChar

                mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                call Crlf ; new line
                call Crlf ; new line

                mov esi, charGuessesIndex ; this moves the value of charGuessesIndex into esi

                mov al, userGuessChar[0] ; set the value of al to the guessed character

                mov charGuesses[esi], al ; this sets the value of the charGuesses array at the index of the guessed character to the guessed character

                inc charGuessesIndex ; this increments the value of charGuessesIndex by 1

                inc esi ; increase esi by 1

                mov al, ' ' ; set al to ' '

                mov charGuesses[esi], al ; this sets the value of the charGuesses array at the index of the guessed character to al

                inc charGuessesIndex ; increase charGuessesIndex by 1
                
                jmp DisplayWord ; jump to the DisplayWord label

            FalseChar: ; this label is used in the case that the user guesses a character that is not in the chosen word.
                mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov edx, OFFSET displayWrongGuessChar ; prepares the string displayWrongGuessChar to be displayed
                call WriteString ; this displays the string displayWrongGuessChar

                mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                call Crlf ; new line
                call Crlf ; new line

                dec guessesWrongMax ; decrease guessesWrongMax by 1

                mov esi, charGuessesIndex ; this moves the value of charGuessesIndex into esi

                mov al, userGuessChar[0] ; set the value of al to the guessed character

                mov charGuesses[esi], al ; this sets the value of the charGuesses array at the index of the guessed character to the guessed character

                inc charGuessesIndex ; this increments the value of charGuessesIndex by 1

                inc esi ; increase esi by 1
                
                mov al, ' ' ; set al to ' '

                mov charGuesses[esi], al ; this sets the value of the charGuesses array at the index of the guessed character to al

                inc charGuessesIndex ; increase charGuessesIndex by 1

                jmp DisplayWord ; jump to the DisplayWord label

    EndGame: ; this label is used to determine if the user has won or lost the game.
        cmp boolGameWon, 1 ; compare the value of boolGameWon to 1
        je WonGame ; jump to the WonGame label if the value of boolGameWon is equal to 1

        LostGame: ; this label is used in the case that the user has lost the game.
            mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
            call SetTextColor ; this sets the text color to the value in eax

            mov edx, OFFSET displayLostGame ; prepares the string displayLostGame to be displayed
            call WriteString ; this displays the string displayLostGame

            mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
            call SetTextColor ; this sets the text color to the value in eax

            call Crlf ; new line
            call Crlf ; new line

                mov edx, OFFSET hangmanTop ; this selects the array hangmanTop to be displayed
                call WriteString ; this displays the string from the edx offset
                call Crlf ; new line

                mov edx, OFFSET hangmanTop2 ; this selects the array hangmanTop2 to be displayed
                call WriteString ; this displays the string from the edx offset
                call Crlf ; new line

                mov edx, OFFSET hangmanWrong1 ; this selects the array hangmanWrong1 to be displayed
                call WriteString ; this displays the string from the edx offset
                call Crlf ; new line

                mov edx, OFFSET hangmanWrong4 ; this selects the array hangmanWrong4 to be displayed
                call WriteString ; this displays the string from the edx offset
                call Crlf ; new line

                mov edx, OFFSET hangmanWrong6 ; this selects the array hangmanWrong6 to be displayed
                call WriteString ; this displays the string from the edx offset
                call Crlf ; new line

                mov edx, OFFSET hangmanBottom1 ; this selects the array hangmanBottom1 to be displayed
                call WriteString ; this displays the string from the edx offset
                call Crlf ; new line

                mov edx, OFFSET hangmanBottom2 ; this selects the array hangmanBottom2 to be displayed
                call WriteString ; this displays the string from the edx offset
                call Crlf ; new line

                call Crlf ; new line

            call Crlf ; new line
            call Crlf ; new line

            jmp DisplayWordEnd ; jump to the DisplayWordEnd label

        WonGame: ; this label is used in the case that the user has won the game.
            mov eax, lightGreen + (black * 16) ; this sets the color of the text to light green and the background to black
            call SetTextColor ; this sets the text color to the value in eax

            mov edx, OFFSET displayWonGame ; prepares the string displayWonGame to be displayed
            call WriteString ; this displays the string displayWonGame

            mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
            call SetTextColor ; this sets the text color to the value in eax

            call Crlf ; new line
            call Crlf ; new line

            jmp DisplayWordEnd ; jump to the DisplayWordEnd label

        DisplayWordEnd: ; this label is used to display the chosen word at the end of the game.
            mov edx, OFFSET displayWordStr ; prepares the string displayWordStr to be displayed
            call WriteString ; this displays the string displayWordStr

            mov eax, lightBlue + (black * 16) ; this sets the color of the text to blue and the background to black
            call SetTextColor ; this sets the text color to the value in eax

            mov esi, chosenWordOffset ; this moves the offset of the randomly selected word into esi

            .WHILE BYTE PTR [esi] != 0 ; while the pointer esi is not pointing to the null terminator
                mov al, [esi] ; this moves the character at the offset of the randomly selected word into al
                call WriteChar ; this displays the character in al

                inc esi ; this increments the value of esi by 1
            .ENDW

            mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
            call SetTextColor ; this sets the text color to the value in eax

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

    EndProgram: ; this label is used to end the program.
        ret ; end the MainProgram procedure and return to the main procedure

MainProgram ENDP

main PROC

    call MainProgram ; run the MainProgram procedure.

    INVOKE ExitProcess,0

main ENDP

END main
