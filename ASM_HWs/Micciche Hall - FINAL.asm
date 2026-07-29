; **********************************************************************;
; Program Name: BlackJack Game
; Program Description: 
; Author: Terrence Micciche Hall
; Course: CSC2025X40
; Creation Date: 07/28/26
; Revisions: 0
; Date Last Modified: 07/28/26
; Test Cases:
;
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

    displayShuffleCards BYTE "Gimme a sec', I gotta shuffle the cards.", 0
    displayGoodbye BYTE "Come back anytime, stranger.", 0

    displayUserWon BYTE "Well now, it looks like ya' won! Good for ya'!", 0
    displayHouseWon BYTE "Tough luck, ya' lost. Maybe the next hand will be ya' lucky one.", 0

    displayTie21 BYTE "We both got 21! How about that?", 0
    displayTie BYTE "Looks like we tied. How about that?", 0

    displayHouseBust BYTE "Yup, the house busted. Good for ya'!", 0
    displayHouse21 BYTE "Tough luck, stranger. The house has 21. Ya' lost.", 0

    displayTotalValueHouse BYTE "Seems like the house total is ", 0    

    displayTotalValueUser BYTE "Looks like ya' total is ", 0

    promptHitOrStand BYTE "Whatcha thinkin? Hit or Stand? (h/s)? ", 0

    displayCardsHouse BYTE "The house cards are: ", 0
    displayCardsUser BYTE "Ya' cards are: ", 0
    displayOf BYTE " of ", 0
    displayAnd BYTE " and ", 0

    displayAce BYTE "Ace", 0
    displayTwo BYTE "Two", 0
    displayThree BYTE "Three", 0
    displayFour BYTE "Four", 0
    displayFive BYTE "Five", 0
    displaySix BYTE "Six", 0
    displaySeven BYTE "Seven", 0
    displayEight BYTE "Eight", 0
    displayNine BYTE "Nine", 0
    displayTen BYTE "Ten", 0
    displayJack BYTE "Jack", 0
    displayQueen BYTE "Queen", 0
    displayKing BYTE "King", 0

    displayHearts BYTE "Hearts", 0
    displayDiamonds BYTE "Diamonds", 0
    displayClubs BYTE "Clubs", 0
    displaySpades BYTE "Spades", 0

    promptStartGame1 BYTE "This here is ", 0 ; this prompt the user to decide whether they'd like to play the game or not.
    promtStartGame2 BYTE ", stranger. Lookin' to play? (y/n)? ", 0 ; this prompt the user to decide whether they'd like to play the game or not.

    displayBlack BYTE "Black", 0 ; this displays the word "Black"
    diplayJack BYTE "Jack", 0 ; this displays the word "Jack"

    displayUser21 BYTE "Hey, 21! Looks like Lady Luck is on ya' side.", 0 ; this displays a message to the user that they have won the game.

    displayUserBust BYTE "How about that... ya' busted. Better luck next time.", 0 ; this displays a message to the user that they have lost the game.

    promptTryAgain BYTE "Would ya' like to try again? (y/n)? ", 0 ; this prompt the user to decide whether they'd like to continue the program or not.
    promptErrorTry BYTE "Ya' gonna need to say that again. I got hearin' pro'lems.", 0 ; this declares that the user entered an invalid response, then it prompts
                                                                                       ; the user to try again
    promptErrorResp BYTE "Say again, stranger. I can't understand ya': ", 0 ; this declares that the user entered an invalid response, then it prompts
                                                                            ; the user to try again
    ;*************************************
    ; THE DATA BELOW ARE INPUT VARIABLES AND ARRAYS. THIS DATA IS USED FOR
    ; HOLDING USER INPUTTED DATA.
    ;*************************************

    delayValue DWORD 3000 ; this is an initialized DWORD variable. this variable is used to hold the value of the delay in milliseconds.

    startingHandCount DWORD 2 ; this is an initialized DWORD variable. this variable is used to hold the starting hand count of the user.
    userTotalCards DWORD 0 ; this is an initialized DWORD variable. this variable is used to hold the total number of cards in the user's hand.
    userHand DWORD 10 DUP(0) ; this is an initialized array of DWORD elements. the elements are initialized to 0, and they are used to hold the user's hand of cards.
    userHandSuit DWORD 10 DUP(0) ; this is an initialized array of DWORD elements. the elements are initialized to 0, and they are used to hold the user's suits.
    userTotalValue DWORD ? ; this is an initialized DWORD variable. this variable is used to hold the total value of the user's hand of cards.

    twentyOne DWORD 21 ; this is an initialized DWORD variable. this variable is used to hold the value of 21, which is the winning value in a game of blackjack.

    houseTotalCards DWORD 0 ; this is an initialized DWORD variable. this variable is used to hold the total number of cards in the house's hand.
    houseHand DWORD 10 DUP(0) ; this is an initialized array of DWORD elements. the elements are initialized to 0, and they are used to hold the house's hand of cards.
    houseHandSuit DWORD 10 DUP(0) ; this is an initialized array of DWORD elements. the elements are initialized to 0, and they are used to hold the house's suits.
    houseTotalValue DWORD ? ; this is an initialized DWORD variable. this variable is used to hold the total value of the house's hand of cards.

    cardDeckNumbers DWORD OFFSET displayAce, OFFSET displayTwo, OFFSET displayThree, OFFSET displayFour, OFFSET displayFive, OFFSET displaySix, OFFSET displaySeven,
                          OFFSET displayEight, OFFSET displayNine, OFFSET displayTen, OFFSET displayJack, OFFSET displayQueen, OFFSET displayKing ; this is an initialized array of BYTE elements.
                                                                                                                                                  ; the elements are initialized to the values of a card deck.
    
    cardDeckNumbersCounts DWORD 13 DUP(4) ; this is an initialized array of DWORD elements. the elements are initialized to the counts of each value in a card deck.
    
    cardDeckSuits DWORD OFFSET displayHearts, OFFSET displayDiamonds, OFFSET displaySpades, OFFSET displayClubs ; this is an initialized array of BYTE elements. the elements are initialized
                                                                                                                ; to the suits of a card deck.

    ; PLEASE REMEMBER THAT HEARTS AND DIAMONDS ARE RED AND SPACES AND CLUBS ARE BLACK. THIS IS IMPORTANT FOR THE COLORING OF THE CARDS.
    cardDeckSuitCounts DWORD 4 DUP(13); this is an initialized array of BYTE elements. the elements are initialized to the counts of each suit in a card deck.

    boolUserBust DWORD 0

    boolUser21 DWORD 0

    boolHouseBust DWORD 0
     
    boolHouse21 DWORD 0




    boolGameWon DWORD ? ; this is an initialized DWORD variable. this variable is used to determine whether the user has won the game or not. 1 is true and 0 is false.

    boolHouseBusted DWORD ? ; this is an initialized DWORD variable. this variable is used to determine whether the house has busted or not. 1 is true and 0 is false.

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
; Receives: This procedure does not directly receive anything.
; Returns: This procedure does not directly return anything.
; Requires: This procedure requires the Irvine32 library as well as every single memory variable in the .data section.
;***********************************
CheckShuffleCards PROC
    
    CheckCards:
        mov eax, 0
        mov ecx, 0

        .WHILE ecx < LENGTHOF cardDeckSuitCounts ; while the value in ecx is less than the length of the cardDeckSuitCounts array
            .IF cardDeckSuitCounts[ecx*4] == 0 ; if the value of the cardDeckSuitCounts array at the index in ecx is equal to 0
                inc eax
            .ENDIF

            inc ecx ; this increases the value in ecx by 1
        .ENDW

        cmp eax, 3
        jge ShuffleCards ; if the value in eax is greater than or equal to 3, then jump to the ShuffleCards label

        ret

    ShuffleCards:
        
        call Crlf

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        mov edx, OFFSET displayShuffleCards ; prepares the string displayShuffleCards to be displayed
        call WriteString ; this displays a string from edx

        mov eax, delayValue ; this moves the value of delayValue into eax
        call Delay ; this delays the program for the amount of time in milliseconds specified in eax

        Call Crlf

        .WHILE ecx < LENGTHOF cardDeckSuitCounts ; while the value in ecx is less than the length of the cardDeckSuitCounts array

            mov cardDeckSuitCounts[ecx*4], 13 ; this sets the value of the cardDeckSuitCounts array at the index in ecx to 13
            inc ecx ; this increases the value in ecx by 1
        .ENDW

        mov ecx, 0

        .WHILE ecx < LENGTHOF cardDeckNumbersCounts ; while the value in ecx is less than the length of the cardDeckNumbersCounts array
            mov cardDeckNumbersCounts[ecx*4], 4 ; this sets the value of the cardDeckNumbersCounts array at the index in ecx to 4
            inc ecx ; this increases the value in ecx by 1
        .ENDW

    ret

CheckShuffleCards ENDP

;***********************************
; Description: This procedure handles the entire program.
; Receives: This procedure does not directly receive anything.
; Returns: This procedure does not directly return anything.
; Requires: This procedure requires the Irvine32 library as well as every single memory variable in the .data section.
;***********************************
SeedCard PROC
    mov eax, LENGTHOF cardDeckNumbers ; this gets the length of the cardDeckNumbers array and saves it in eax

    call RandomRange ; this generates a random number between 0 and the length of the cardDeckNumbers array and saves it in eax
    
    ret
SeedCard ENDP

;***********************************
; Description: This procedure handles the entire program.
; Receives: This procedure does not directly receive anything.
; Returns: This procedure does not directly return anything.
; Requires: This procedure requires the Irvine32 library as well as every single memory variable in the .data section.
;***********************************
SeedSuit PROC
    mov eax, LENGTHOF cardDeckSuits ; this gets the length of the cardDeckSuits array and saves it in eax

    call RandomRange ; this generates a random number between 0 and the length of the cardDeckSuits array and saves it in eax
    
    ret
SeedSuit ENDP

;***********************************
; Description: This procedure handles the entire program.
; Receives: This procedure does not directly receive anything.
; Returns: This procedure does not directly return anything.
; Requires: This procedure requires the Irvine32 library as well as every single memory variable in the .data section.
;***********************************
MainProgram PROC
; NEED TO CLEAR THE HANDS WHEN DONE, BUT DONT CLEAR THE DECK COUNTS. THE DECK COUNTS ARE USED TO DETERMINE IF THE CARDS NEED TO BE SHUFFLED.
; make a betting function???

    StartGame:
        mov edx, OFFSET promptStartGame1 ; prepares the string promptStartGame1 to be displayed
        call WriteString ; this displays a string from edx
        
        mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        mov edx, OFFSET displayBlack ; prepares the string displayBlack to be displayed
        call WriteString ; this displays a string from edx

        mov eax, white + (black * 16) ; this sets the color of the text to white and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        mov edx, OFFSET diplayJack ; prepares the string diplayJack to be displayed
        call WriteString ; this displays a string from edx

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        mov edx, OFFSET promtStartGame2 ; prepares the string promtStartGame2 to be displayed
        call WriteString ; this displays a string from edx

        CheckAnswer:

            mov eax, lightBlue + (black * 16) ; this sets the color of the text to light blue and the background to black
            call SetTextColor ; this sets the text color to the value in eax

            mov edx, OFFSET answer ; this selects the array answer to be filled with a string
            mov ecx, SIZEOF answer ; this sets the size of the answer to 2. this includes the character y or n, as well as the
                                   ; null terminator

            call readString ; this reads a string then saves the input in the edx offset

            mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
            call SetTextColor ; this sets the text color to the value in eax

            .IF answer[0] == 'y' || answer[0] == 'Y' ; if the answer is yes
                call Crlf ; new line
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

                jmp CheckAnswer ; jump to the CheckAnswer label
            .ENDIF ; end the if statements

    PlayGame:
        DefaultSettings:
            call Randomize ; this seeds the random number generator with the current time

            mov boolUserBust, 0
            mov boolUser21, 0
            
            mov boolHouseBust, 0
            mov boolHouse21, 0

            mov ecx, 0

            .WHILE ecx < LENGTHOF userHand ; while the value in ecx is less than the length of the userHand array
                mov userHand[ecx*4], 0 ; this sets the value of the userHand array at the index in ecx to 0
                mov userHandSuit[ecx*4], 0 ; this sets the value of the userHandSuit array at the index in ecx to 0
                
                inc ecx ; this increases the value in ecx by 1
            .ENDW

        DealUser:

            ; ONLY DO THIS IF YOU DO ONE CARD DECK  call CheckShuffleCards ; this calls the CheckShuffleCards procedure to check if the cards need to be shuffled

            mov ecx, 0

            .WHILE ecx < startingHandCount
                DetermineNumber:
                    call SeedCard ; this calls the SeedCard procedure to generate a random number between 0 and the length of the cardDeckNumbers array and saves it in eax

             ; ONLY DO THIS IF YOU DO ONE CARD DECK         .IF cardDeckNumbersCounts[eax*4] == 0 ; if the count of the cardDeckNumbersCounts array at the index in eax is 0
            ; ONLY DO THIS IF YOU DO ONE CARD DECK              jmp DetermineNumber ; jump to the DetermineNumber label
            ; ONLY DO THIS IF YOU DO ONE CARD DECK          .ENDIF

              ; ONLY DO THIS IF YOU DO ONE CARD DECK        dec cardDeckNumbersCounts[eax*4] ; this decreases the count of the cardDeckNumbersCounts array at the index in eax by 1

                    mov edx, cardDeckNumbers[eax*4]
                    mov userHand[ecx*4], edx ; this saves the value at the index in eax into the first element of the userHand array

                DetermineSuit:
                    call SeedSuit ; this calls the SeedSuit procedure to generate a random number between 0 and the length of the cardDeckSuits array and saves it in eax

                ; ONLY DO THIS IF YOU DO ONE CARD DECK      .IF cardDeckSuitCounts[eax*4] == 0 ; if the count of the cardDeckSuitCounts array at the index in eax is 0
                ; ONLY DO THIS IF YOU DO ONE CARD DECK          jmp DetermineSuit ; jump to the DetermineSuit label
                ; ONLY DO THIS IF YOU DO ONE CARD DECK      .ENDIF

                ; ONLY DO THIS IF YOU DO ONE CARD DECK      dec cardDeckSuitCounts[eax*4] ; this decreases the count of the cardDeckSuitCounts array at the index in eax by 1

                    mov edx, cardDeckSuits[eax*4]
                    mov userHandSuit[ecx*4], edx

                inc ecx
            .ENDW

            mov userTotalCards, ecx ; this saves the value in ecx into userTotalCards

            CalculateTotalUser:
                mov ecx, 0
                mov userTotalValue, 0 ; this sets the value of userTotalValue to 0

                .WHILE ecx < userTotalCards
                    .IF userHand[ecx*4] == OFFSET displayAce ; if the card is an Ace
                        add userTotalValue, 11 ; this adds 11 to the value of userTotalValue
                        mov eax, twentyOne ; this moves the value of userTotalValue into eax
                        .IF userTotalValue > eax ; if the value of userTotalValue is greater than 21
                            sub userTotalValue, 10 ; this subtracts 10 from the value of userTotalValue
                        .ENDIF
                    .ELSEIF userHand[ecx*4] == OFFSET displayTwo ; if the card is a Two
                        add userTotalValue, 2 ; this adds 2 to the value of userTotalValue
                    .ELSEIF userHand[ecx*4] == OFFSET displayThree ; if the card is a Three
                        add userTotalValue, 3 ; this adds 3 to the value of userTotalValue
                    .ELSEIF userHand[ecx*4] == OFFSET displayFour ; if the card is a Four
                        add userTotalValue, 4 ; this adds 4 to the value of userTotalValue
                    .ELSEIF userHand[ecx*4] == OFFSET displayFive ; if the card is a Five
                        add userTotalValue, 5 ; this adds 5 to the value of userTotalValue
                    .ELSEIF userHand[ecx*4] == OFFSET displaySix ; if the card is a Six
                        add userTotalValue, 6 ; this adds 6 to the value of userTotalValue
                    .ELSEIF userHand[ecx*4] == OFFSET displaySeven ; if the card is a Seven
                        add userTotalValue, 7 ; this adds 7 to the value of userTotalValue
                    .ELSEIF userHand[ecx*4] == OFFSET displayEight ; if the card is an Eight
                        add userTotalValue, 8 ; this adds 8 to the value of userTotalValue
                    .ELSEIF userHand[ecx*4] == OFFSET displayNine ; if the card is a Nine
                        add userTotalValue, 9 ; this adds 9 to the value of userTotalValue
                    .ELSEIF userHand[ecx*4] == OFFSET displayTen || userHand[ecx*4] == OFFSET displayJack || userHand[ecx*4] == OFFSET displayQueen || userHand[ecx*4] == OFFSET displayKing ; if the card is a Ten, Jack, Queen, or King
                        add userTotalValue, 10 ; this adds 10 to the value of userTotalValue
                    .ENDIF

                    inc ecx ; this increases the value in ecx by 1
                .ENDW

            ShowCardsUser:
                mov edx, OFFSET displayCardsUser ; prepares the string displayCardsUser to be displayed
                call WriteString ; this displays a string from edx

                call Crlf ; new line
                call Crlf ; new line

                mov eax, black + (white * 16) ; this sets the color of the text to black and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov ecx, 0

                .WHILE ecx < userTotalCards
                    mov eax, black + (white * 16) ; this sets the color of the text to white and the background to black
                    call SetTextColor ; this sets the text color to the value in eax

                    .IF userHandSuit[ecx*4] == OFFSET displayHearts || userHandSuit[ecx*4] == OFFSET displayDiamonds ; if the suit is hearts or diamonds
                        mov eax, lightRed + (white * 16) ; this sets the color of the text to white and the background to black
                        call SetTextColor ; this sets the text color to the value in eax
                    .ENDIF

                    mov edx, userHand[ecx*4] ; this moves the value at the index in ecx of the userHand array into edx
                    call WriteString ; this displays a string from edx

                    mov edx, OFFSET displayOf ; prepares the string displayOf to be displayed
                    call WriteString ; this displays a string from edx

                    mov edx, userHandSuit[ecx*4] ; this moves the value at the index in ecx of the userHandSuit array into edx
                    call WriteString ; this displays a string from edx

                    mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                    call SetTextColor ; this sets the text color to the value in eax

                    call Crlf ; new line

                    inc ecx ; this increases the value in ecx by 1

                .ENDW

                call Crlf ; new line
            
                mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov edx, OFFSET displayTotalValueUser ; prepares the string displayTotalValueUser to be displayed
                call WriteString ; this displays a string from edx

                mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov eax, userTotalValue ; this moves the value of userTotalValue into eax
                call WriteDec ; this displays the value in eax as a decimal number
            
                mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                call Crlf ; new line
                call Crlf ; new line

            CheckForEndGameUser:
                mov eax, userTotalValue

                .IF eax > twentyOne
                    mov boolUserBust, 1
                    jmp EndGame
                .ELSEIF eax == twentyOne
                    mov boolUser21, 1
                    ; LET THEUSER KNOW THEY GOT 21
                    jmp DealHouse
                .ENDIF

            HitOrStandUser:
                mov edx, OFFSET promptHitOrStand ; prepares the string promptHitOrStand to be displayed
                call WriteString ; this displays a string from edx

                CheckAnswer2:

                    mov eax, lightBlue + (black * 16) ; this sets the color of the text to light blue and the background to black
                    call SetTextColor ; this sets the text color to the value in eax

                    mov edx, OFFSET answer ; this selects the array answer to be filled with a string
                    mov ecx, SIZEOF answer ; this sets the size of the answer to 2. this includes the character h or s, as well as the
                                           ; null terminator

                    call ReadString ; this reads a string then saves the input in the edx offset

                    .IF answer[0] == 'h' || answer[0] == 'H' ; if the answer is hit
                        call Crlf ; new line
                        call Crlf ; new line

                        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                        call SetTextColor ; this sets the text color to the value in eax

                        jmp HitUser ; jump to the HitUser label
                    .ELSEIF answer[0] == 's' || answer[0] == 'S' ; if the answer is stand
                        call Crlf ; new line
                        call Crlf ; new line

                        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                        call SetTextColor ; this sets the text color to the value in eax

                        jmp StandUser ; jump to the StandUser label
                    .ELSE ; if the answer is not yes or no
                        call Crlf ; new line 

                        mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
                        call SetTextColor ; this sets the text color to the value in eax
            
                        mov edx, OFFSET promptErrorResp ; prepares the string promptErrorResp to be displayed
                        call WriteString ; displays a string from the edx offset

                        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                        call SetTextColor ; this sets the text color to the value in eax

                        jmp CheckAnswer2 ; jump to the CheckAnswer2 label
                    .ENDIF ; end the if statements

            HitUser:

                call CheckShuffleCards

                mov ecx, userTotalCards ; this moves the value of userTotalCards into ecx

                DetermineNumber2:
                    call SeedCard ; this calls the SeedCard procedure to generate a random number between 0 and the length of the cardDeckNumbers array and saves it in eax

                ; ONLY DO THIS IF YOU DO ONE CARD DECK      .IF cardDeckNumbersCounts[eax*4] == 0 ; if the count of the cardDeckNumbersCounts array at the index in eax is 0
                ; ONLY DO THIS IF YOU DO ONE CARD DECK          jmp DetermineNumber ; jump to the DetermineNumber label
                ; ONLY DO THIS IF YOU DO ONE CARD DECK      .ENDIF

                 ; ONLY DO THIS IF YOU DO ONE CARD DECK     dec cardDeckNumbersCounts[eax*4] ; this decreases the count of the cardDeckNumbersCounts array at the index in eax by 1

                    mov edx, cardDeckNumbers[eax*4]
                    mov userHand[ecx*4], edx ; this saves the value at the index in eax into the first element of the userHand array

                DetermineSuit2:
                    call SeedSuit ; this calls the SeedSuit procedure to generate a random number between 0 and the length of the cardDeckSuits array and saves it in eax

             ; ONLY DO THIS IF YOU DO ONE CARD DECK         .IF cardDeckSuitCounts[eax*4] == 0 ; if the count of the cardDeckSuitCounts array at the index in eax is 0
             ; ONLY DO THIS IF YOU DO ONE CARD DECK             jmp DetermineSuit ; jump to the DetermineSuit label
            ; ONLY DO THIS IF YOU DO ONE CARD DECK          .ENDIF

           ; ONLY DO THIS IF YOU DO ONE CARD DECK           dec cardDeckSuitCounts[eax*4] ; this decreases the count of the cardDeckSuitCounts array at the index in eax by 1

                    mov edx, cardDeckSuits[eax*4]
                    mov userHandSuit[ecx*4], edx

                inc ecx ; this increases the value in ecx by 1

                mov userTotalCards, ecx ; this saves the value in ecx into userTotalCards

                jmp CalculateTotalUser ; jump to the CalculateTotalUser label

            StandUser:
                jmp DealHouse ; jump to the DealHouse label

        DealHouse:
            
          ; ONLY DO THIS IF YOU DO ONE CARD DECK  call CheckShuffleCards ; this calls the CheckShuffleCards procedure to check if the cards need to be shuffled

            mov ecx, 0

            .WHILE ecx < startingHandCount
                DetermineNumber3:
                    call SeedCard ; this calls the SeedCard procedure to generate a random number between 0 and the length of the cardDeckNumbers array and saves it in eax

                  ; ONLY DO THIS IF YOU DO ONE CARD DECK    .IF cardDeckNumbersCounts[eax*4] == 0 ; if the count of the cardDeckNumbersCounts array at the index in eax is 0
                  ; ONLY DO THIS IF YOU DO ONE CARD DECK        jmp DetermineNumber ; jump to the DetermineNumber label
                ; ONLY DO THIS IF YOU DO ONE CARD DECK      .ENDIF

               ; ONLY DO THIS IF YOU DO ONE CARD DECK       dec cardDeckNumbersCounts[eax*4] ; this decreases the count of the cardDeckNumbersCounts array at the index in eax by 1

                    mov edx, cardDeckNumbers[eax*4]
                    mov houseHand[ecx*4], edx ; this saves the value at the index in eax into the first element of the userHand array

                DetermineSuit3:
                    call SeedSuit ; this calls the SeedSuit procedure to generate a random number between 0 and the length of the cardDeckSuits array and saves it in eax

           ; ONLY DO THIS IF YOU DO ONE CARD DECK           .IF cardDeckSuitCounts[eax*4] == 0 ; if the count of the cardDeckSuitCounts array at the index in eax is 0
              ; ONLY DO THIS IF YOU DO ONE CARD DECK            jmp DetermineSuit ; jump to the DetermineSuit label
              ; ONLY DO THIS IF YOU DO ONE CARD DECK        .ENDIF

               ; ONLY DO THIS IF YOU DO ONE CARD DECK       dec cardDeckSuitCounts[eax*4] ; this decreases the count of the cardDeckSuitCounts array at the index in eax by 1

                    mov edx, cardDeckSuits[eax*4]
                    mov houseHandSuit[ecx*4], edx

                inc ecx
            .ENDW

            mov houseTotalCards, ecx ; this saves the value in ecx into houseTotalCards

            CalculateTotalHouse:
                mov ecx, 0
                mov houseTotalValue, 0 ; this sets the value of houseTotalValue to 0

                .WHILE ecx < houseTotalCards
                    .IF houseHand[ecx*4] == OFFSET displayAce ; if the card is an Ace
                        add houseTotalValue, 11 ; this adds 11 to the value of houseTotalValue
                        mov eax, twentyOne ; this moves the value of houseTotalValue into eax
                        .IF houseTotalValue > eax ; if the value of houseTotalValue is greater than 21
                            sub houseTotalValue, 10 ; this subtracts 10 from the value of houseTotalValue
                        .ENDIF
                    .ELSEIF houseHand[ecx*4] == OFFSET displayTwo ; if the card is a Two
                        add houseTotalValue, 2 ; this adds 2 to the value of houseTotalValue
                    .ELSEIF houseHand[ecx*4] == OFFSET displayThree ; if the card is a Three
                        add houseTotalValue, 3 ; this adds 3 to the value of houseTotalValue
                    .ELSEIF houseHand[ecx*4] == OFFSET displayFour ; if the card is a Four
                        add houseTotalValue, 4 ; this adds 4 to the value of houseTotalValue
                    .ELSEIF houseHand[ecx*4] == OFFSET displayFive ; if the card is a Five
                        add houseTotalValue, 5 ; this adds 5 to the value of houseTotalValue
                    .ELSEIF houseHand[ecx*4] == OFFSET displaySix ; if the card is a Six
                        add houseTotalValue, 6 ; this adds 6 to the value of houseTotalValue
                    .ELSEIF houseHand[ecx*4] == OFFSET displaySeven ; if the card is a Seven
                        add houseTotalValue, 7 ; this adds 7 to the value of houseTotalValue
                    .ELSEIF houseHand[ecx*4] == OFFSET displayEight ; if the card is an Eight
                        add houseTotalValue, 8 ; this adds 8 to the value of houseTotalValue
                    .ELSEIF houseHand[ecx*4] == OFFSET displayNine ; if the card is a Nine
                        add houseTotalValue, 9 ; this adds 9 to the value of houseTotalValue
                    .ELSEIF houseHand[ecx*4] == OFFSET displayTen || houseHand[ecx*4] == OFFSET displayJack || houseHand[ecx*4] == OFFSET displayQueen || houseHand[ecx*4] == OFFSET displayKing ; if the card is a Ten, Jack, Queen, or King
                        add houseTotalValue, 10 ; this adds 10 to the value of houseTotalValue
                    .ENDIF

                    inc ecx ; this increases the value in ecx by 1
                .ENDW

             ShowCardsHouse:
                mov edx, OFFSET displayCardsHouse ; prepares the string displayCardsHouse to be displayed
                call WriteString ; this displays a string from edx

                call Crlf ; new line
                call Crlf ; new line

                mov eax, black + (white * 16) ; this sets the color of the text to black and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov ecx, 0

                .WHILE ecx < houseTotalCards
                    mov eax, black + (white * 16) ; this sets the color of the text to white and the background to black
                    call SetTextColor ; this sets the text color to the value in eax

                    .IF houseHandSuit[ecx*4] == OFFSET displayHearts || houseHandSuit[ecx*4] == OFFSET displayDiamonds ; if the suit is hearts or diamonds
                        mov eax, lightRed + (white * 16) ; this sets the color of the text to white and the background to black
                        call SetTextColor ; this sets the text color to the value in eax
                    .ENDIF

                    mov edx, houseHand[ecx*4] ; this moves the value at the index in ecx of the houseHand array into edx
                    call WriteString ; this displays a string from edx

                    mov edx, OFFSET displayOf ; prepares the string displayOf to be displayed
                    call WriteString ; this displays a string from edx

                    mov edx, houseHandSuit[ecx*4] ; this moves the value at the index in ecx of the houseHandSuit array into edx
                    call WriteString ; this displays a string from edx

                    mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                    call SetTextColor ; this sets the text color to the value in eax

                    call Crlf ; new line

                    inc ecx ; this increases the value in ecx by 1

                .ENDW

                call Crlf ; new line
            
                mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov edx, OFFSET displayTotalValueHouse ; prepares the string displayTotalValueHouse to be displayed
                call WriteString ; this displays a string from edx

                mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov eax, houseTotalValue ; this moves the value of userTotalValue into eax
                call WriteDec ; this displays the value in eax as a decimal number
            
                mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                call Crlf ; new line
                call Crlf ; new line


                CheckForEndGameHouse:
                    mov eax, delayValue

                    call Delay ; this calls the Delay procedure to delay the program for a certain amount of time

                    mov eax, houseTotalValue ; this moves the value of userTotalValue into eax

                    .IF eax > twentyOne
                        mov boolHouseBust, 1
                        
                        jmp EndGame
                    .ELSEIF eax == twentyOne
                        mov boolHouse21, 1
                        
                        jmp EndGame
                    .ELSEIF eax >= 17
                        jmp EndGame
                    .ELSE
                        mov ecx, houseTotalCards ; this moves the value of houseTotalCards into ecx

                        DetermineNumber4:
                            call SeedCard ; this calls the SeedCard procedure to generate a random number between 0 and the length of the cardDeckNumbers array and saves it in eax

                     ; ONLY DO THIS IF YOU DO ONE CARD DECK         .IF cardDeckNumbersCounts[eax*4] == 0 ; if the count of the cardDeckNumbersCounts array at the index in eax is 0
                    ; ONLY DO THIS IF YOU DO ONE CARD DECK              jmp DetermineNumber ; jump to the DetermineNumber label
                     ; ONLY DO THIS IF YOU DO ONE CARD DECK         .ENDIF

                      ; ONLY DO THIS IF YOU DO ONE CARD DECK        dec cardDeckNumbersCounts[eax*4] ; this decreases the count of the cardDeckNumbersCounts array at the index in eax by 1

                            mov edx, cardDeckNumbers[eax*4]
                            mov houseHand[ecx*4], edx ; this saves the value at the index in eax into the first element of the userHand array

                        DetermineSuit4:
                            call SeedSuit ; this calls the SeedSuit procedure to generate a random number between 0 and the length of the cardDeckSuits array and saves it in eax

                   ; ONLY DO THIS IF YOU DO ONE CARD DECK           .IF cardDeckSuitCounts[eax*4] == 0 ; if the count of the cardDeckSuitCounts array at the index in eax is 0
               ; ONLY DO THIS IF YOU DO ONE CARD DECK                   jmp DetermineSuit ; jump to the DetermineSuit label
                      ; ONLY DO THIS IF YOU DO ONE CARD DECK        .ENDIF

                     ; ONLY DO THIS IF YOU DO ONE CARD DECK         dec cardDeckSuitCounts[eax*4] ; this decreases the count of the cardDeckSuitCounts array at the index in eax by 1

                            mov edx, cardDeckSuits[eax*4]
                            mov houseHandSuit[ecx*4], edx

                        inc ecx

                        mov houseTotalCards, ecx ; this saves the value in ecx into houseTotalCards

                        jmp CalculateTotalHouse ; jump to the CalculateTotalHouse label
                    .ENDIF

        EndGame:
            
            .IF boolUserBust == 1

                mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov edx, OFFSET displayUserBust ; prepares the string displayUserBust to be displayed
                call WriteString ; this displays a string from edx

                mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                call Crlf ; new line

                jmp TryAgain
            .ELSEIF boolHouseBust == 1

                mov eax, lightGreen + (black * 16) ; this sets the color of the text to light green and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov edx, OFFSET displayHouseBust ; prepares the string displayHouseBust to be displayed
                call WriteString ; this displays a string from edx

                mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                call Crlf ; new line

                jmp TryAgain
            .ELSEIF boolUser21 == 1 && boolHouse21 == 0

                mov eax, lightGreen + (black * 16) ; this sets the color of the text to light green and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov edx, OFFSET displayUser21 ; prepares the string displayUser21 to be displayed
                call WriteString ; this displays a string from edx

                mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                call SetTextColor ; this sets the text color to the value in eax
                
                call Crlf ; new line

                jmp TryAgain
            .ELSEIF boolUser21 == 1 && boolHouse21 == 1

                mov edx, OFFSET displayTie21 ; prepares the string displayTie21 to be displayed
                call WriteString ; this displays a string from edx

                call Crlf ; new line

                jmp TryAgain

            .ELSEIF boolUser21 == 0 && boolHouse21 == 1

                mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov edx, OFFSET displayHouse21 ; prepares the string displayHouse21 to be displayed
                call WriteString ; this displays a string from edx

                mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                call Crlf ; new line

                jmp TryAgain
            .ENDIF

            mov eax, userTotalValue ; this moves the value of userTotalValue into eax

            .IF eax > houseTotalValue
                jmp UserWins
            .ELSEIF eax == houseTotalValue
                mov edx, OFFSET displayTie ; prepares the string displayTie to be displayed
                call WriteString ; this displays a string from edx

                call Crlf ; new line

                jmp TryAgain
            .ELSE
                jmp HouseWins
            .ENDIF

            UserWins:
                mov eax, lightGreen + (black * 16) ; this sets the color of the text to light green and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov edx, OFFSET displayUserWon ; prepares the string displayWonGame to be displayed
                call WriteString ; this displays a string from edx

                call Crlf ; new line

                mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                jmp TryAgain ; jump to the TryAgain label
            HouseWins:
                mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov edx, OFFSET displayHouseWon ; prepares the string displayHouseWon to be displayed
                call WriteString ; this displays a string from edx

                call Crlf ; new line

                mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                call SetTextColor ; this sets the text color to the value in eax

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

            jmp PlayGame ; jump to the PlayGame label
        .ELSEIF answer[0] == 'n' || answer[0] == 'N' ; if the answer is no
            
            call Crlf
            call Crlf

            mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
            call SetTextColor ; this sets the text color to the value in eax

            mov edx, OFFSET displayGoodbye
            call WriteString
            
            call Crlf
            call Crlf
            call Crlf

            jmp EndProgram
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

    EndProgram: ; this label is used to end the program.
        ret ; end the MainProgram procedure and return to the main procedure

MainProgram ENDP

main PROC

    call MainProgram ; run the MainProgram procedure.

    INVOKE ExitProcess,0

main ENDP

END main
