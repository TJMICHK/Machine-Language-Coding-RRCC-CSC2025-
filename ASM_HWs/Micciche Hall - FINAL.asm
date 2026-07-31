; **********************************************************************;
; Program Name: BlackJack Game
; Program Description: This is a simple program which simulates the game of BlackJack (21).
;                      The user is able to play against the house, and bet money on each hand.
;                      Furthermore, the user is able to choose to stand or to hit. If the user
;                      runs out of money, then the program will end. There is no designated
;                      win-state.
; Author: Terrence Micciche-Hall
; Course: CSC2025X40
; Creation Date: 07/28/26
; Revisions: 0
; Date Last Modified: 07/31/26
; Test Cases:
;   ShuffleCards Case Ran - PASSED
;   Ace Algorithm - INTERMITTENT
;   Lose State - PASSED
; Notable Bugs:
;   While conducting testing, I found that every once in a while the Ace Algorithm would fail.
;   However, in most cases it seems to work. I am not entirely sure why this is happening.
;
;   Regarding the betting system, there is no system to ensure that the user does not obtain
;   more money than the limit of an unsigned DWORD (4,294,967,295). This system will not be
;   implemented in the current iteration of the program. This is due to the unlikely nature
;   of this case.
;***********************************************************************;

INCLUDE C:\Irvine\Irvine32.inc
INCLUDELIB C:\Irvine\Irvine32.lib

.data

    ;*************************************
    ; THE DATA BELOW ARE OUTPUT STRINGS. THESE STRINGS ARE USED FOR PROMPTING
    ; THE USER.
    ;*************************************

    displayNotEnoughMoney BYTE "Looks like ya' don't have enough money to bet. Come back when ya' got some more.", 0 ; this displays a message to the user that they don't have enough money to bet.
    
    promptRebet BYTE "I get the feeling that ya' tryin' to cheat me here... I'll give ya' another chance to bet a valid amount.", 0 ; this prompt the user to enter a valid amount of money they'd like to bet.

    promptBet BYTE "How much ya' wanna bet? The minimum bet is $", 0 ; this prompts the user to enter the amount of money they'd like to bet.

    displayLuckyNumber BYTE "That's my lucky number...", 0 ; this displays a message that their bet is confirmed.

    displayWallet BYTE "Wallet [$]: ", 0 ; this displays the amount of money the user has in their wallet.

    displayShuffleCards BYTE "Gimme a sec', I gotta shuffle the cards.", 0 ; this displays a message to the user that the cards are being shuffled.
    displayGoodbye BYTE "Come back anytime, stranger.", 0 ; this displays a farewell message

    displayUserWon BYTE "Well now, it looks like ya' won! Good for ya'!", 0 ; this displays a message to the user that they have won the game.
    displayHouseWon BYTE "Tough luck, ya' lost. Maybe the next hand will be ya' lucky one.", 0 ; this displays a message to the user that they have lost the game.

    displayTie21 BYTE "We both got 21! How about that?", 0 ; this displays a message to the user that both the user and the house got a 21.
    displayTie BYTE "Looks like we tied. How about that?", 0 ; this displays a message to the user that they have tied the game.

    displayHouseBust BYTE "Yup, the house busted. Good for ya'!", 0 ; this displays a message to the user that the house has busted.
    displayHouse21 BYTE "Tough luck, stranger. The house has 21. Ya' lost.", 0 ; this displays a message to the user that the house has 21 and the user has lost.

    displayTotalValueHouse BYTE "Seems like the house total is ", 0 ; this displays a message to the user that shows the total value of the house's hand of cards.

    displayTotalValueUser BYTE "Looks like ya' total is ", 0 ; this displays a message to the user that shows the total value of the user's hand of cards.

    promptHitOrStand BYTE "Whatcha thinkin? Hit or Stand? (h/s)? ", 0 ; this prompt the user to decide whether they'd like to hit or stand.

    displayCardsHouse BYTE "The house cards are: ", 0 ; this displays a message to the user that shows the house's hand of cards.
    displayCardsUser BYTE "Ya' cards are: ", 0 ; this displays a message to the user that shows the user's hand of cards.
    displayOf BYTE " of ", 0 ; this display is a part of a message which shows the number and suit of a card
    displayAnd BYTE " and ", 0 ; this display is a part of a message which shows the number and suit of a card

    displayAce BYTE "Ace", 0 ; this displays the word "Ace"
    displayTwo BYTE "Two", 0 ; this displays the word "Two"
    displayThree BYTE "Three", 0 ; this displays the word "Three"
    displayFour BYTE "Four", 0 ; this displays the word "Four"
    displayFive BYTE "Five", 0 ; this displays the word "Five"
    displaySix BYTE "Six", 0 ; this displays the word "Six"
    displaySeven BYTE "Seven", 0 ; this displays the word "Seven"
    displayEight BYTE "Eight", 0 ; this displays the word "Eight"
    displayNine BYTE "Nine", 0 ; this displays the word "Nine"
    displayTen BYTE "Ten", 0 ; this displays the word "Ten"
    displayJack BYTE "Jack", 0 ; this displays the word "Jack"
    displayQueen BYTE "Queen", 0 ; this displays the word "Queen"
    displayKing BYTE "King", 0 ; this displays the word "King"
    
    displayHearts BYTE "Hearts", 0 ; this displays the word "Hearts"
    displayDiamonds BYTE "Diamonds", 0 ; this displays the word "Diamonds"
    displaySpades BYTE "Spades", 0 ; this displays the word "Spades"
    displayClubs BYTE "Clubs", 0 ; this displays the word "Clubs"

    promptStartGame1 BYTE "This here is ", 0 ; this prompt the user to decide whether they'd like to play the game or not.
    promptStartGame2 BYTE ", stranger. Lookin' to play? (y/n)? ", 0 ; this prompt the user to decide whether they'd like to play the game or not.
    promptStartGame3 BYTE "Well, stranger, I don't know what to say. Goodbye.", 0 ; this displays a message to the user that they have chosen not to play the game.
    promptStartGame4 BYTE "Great. Want me to tell ya' the rules, or na'? (y/n)? ", 0 ; this prompt the user to decide whether they'd like to hear the rules of the game or not.
    promptStartGame5 BYTE "Let's get on then.", 0 ; this displays a message to the user that they have chosen not to hear the rules of the game.

    displayRules BYTE "Ya' goal is to have a hand that is closer to 21 than the house's hand without goin' over.", 0 ; this a part of a set of strings that display the rules of the game to the user.
    displayRules2 BYTE "If ya' go over 21, ya bust. If ya' get 21, then ya' win. Simple enough?", 0 ; this a part of a set of strings that display the rules of the game to the user.
    displayRules3 BYTE "Oh, and if ya' get a hand that is equal to the houses hand, then ya' tie.", 0 ; this a part of a set of strings that display the rules of the game to the user.
    displayRules4 BYTE "Let's say ya' win. If ya' get a natural BlackJack, which is an Ace and a 10, then ya' bet comes back double.", 0 ; this a part of a set of strings that display the rules of the game to the user.
    displayRules5 BYTE "Otherwise, ya' bet comes back as the same amount ya' bet.", 0 ; this a part of a set of strings that display the rules of the game to the user.
    displayRules6 BYTE "If ya' bust, then ya' not gettin' anythin' back. If ya' tie, then ya' gain nothin' and lose nothin'.", 0 ; this a part of a set of strings that display the rules of the game to the user.
    displayRules7 BYTE "Good luck, stranger.", 0 ; this is a part of a set of strings that display the rules of the game to the user.

    displayBlack BYTE "Black", 0 ; this displays the word "Black"

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

    BLACKJACKMULTIPLIER DWORD 2 ; this is an initialized DWORD variable. this variable is used to hold the multiplier for a blackjack hand. this is a constant.

    userWallet DWORD 250 ; this is an initialized DWORD variable. this variable is used to hold the amount of money the user has in their wallet.

    MINBET DWORD 25 ; this is an initialized DWORD variable. this variable is used to hold the minimum bet amount. this is a constant.

    userBet DWORD 0 ; this is an initialized DWORD variable. this variable is used to hold the amount of money the user has bet.

    aceCount DWORD 0 ; this is an initialized DWORD variable. this variable is used to hold the number of aces in a hand for the ace algorithm.

    MINIMUMCARDSBEFORESHUFFLE DWORD 39 ; this is an initialized DWORD variable. this variable is used to hold the minimum number of cards in a deck before the deck needs to be shuffled.
                                       ; this is a constant.

    MAXDECKNUMBER DWORD 1 ; this is an initialized DWORD variable. this variable is used to hold the maximum number of decks. this is a constant.

    chosenCard DWORD 0 ; this is an initialized DWORD variable. this variable is used to hold the value of the chosen card.

    cardDeck DWORD 52 DUP(0) ; this is an initialized array of DWORD elements. the elements are initialized to 0, and they are used to indicate which cards have
                             ; been dealt.
    
    delayValue DWORD 3000 ; this is an initialized DWORD variable. this variable is used to hold the value of 3 seconds in milliseconds.
    delayValue2 DWORD 5000 ; this is an initialized DWORD variable. this variable is used to hold the value of 2 seconds in milliseconds.
    delayValue3 DWORD 1000 ; this is an initialized DWORD variable. this variable is used to hold the value of 1 second in milliseconds.

    startingHandCount DWORD 2 ; this is an initialized DWORD variable. this variable is used to hold the starting hand count of the user.
    userTotalCards DWORD 0 ; this is an initialized DWORD variable. this variable is used to hold the total number of cards in the user's hand.
    userHand DWORD 10 DUP(0) ; this is an initialized array of DWORD elements. the elements are initialized to 0, and they are used to hold the user's hand of cards.
    userHandSuit DWORD 10 DUP(0) ; this is an initialized array of DWORD elements. the elements are initialized to 0, and they are used to hold the user's suits.
    userTotalValue DWORD ? ; this is an uninitialized DWORD variable. this variable is used to hold the total value of the user's hand of cards.

    TWENTYONE DWORD 21 ; this is an initialized DWORD variable. this variable is used to hold the value of 21, which is the winning value in a game of blackjack. this is a constant.

    houseTotalCards DWORD 0 ; this is an initialized DWORD variable. this variable is used to hold the total number of cards in the house's hand.
    houseHand DWORD 10 DUP(0) ; this is an initialized array of DWORD elements. the elements are initialized to 0, and they are used to hold the house's hand of cards.
    houseHandSuit DWORD 10 DUP(0) ; this is an initialized array of DWORD elements. the elements are initialized to 0, and they are used to hold the house's suits.
    houseTotalValue DWORD ? ; this is an uninitialized DWORD variable. this variable is used to hold the total value of the house's hand of cards.

    cardDeckNumbers DWORD OFFSET displayAce, OFFSET displayTwo, OFFSET displayThree, OFFSET displayFour, OFFSET displayFive, OFFSET displaySix, OFFSET displaySeven,
                          OFFSET displayEight, OFFSET displayNine, OFFSET displayTen, OFFSET displayJack, OFFSET displayQueen, OFFSET displayKing ; this is an initialized array of BYTE elements.
                                                                                                                                                  ; the elements are initialized to the values of a card deck.
    
    cardDeckSuits DWORD OFFSET displayHearts, OFFSET displayDiamonds, OFFSET displaySpades, OFFSET displayClubs ; this is an initialized array of BYTE elements. the elements are initialized
                                                                                                                ; to the suits of a card deck.

    boolUserBust DWORD 0 ; this is an initialized DWORD variable. this variable is used to determine whether the user has busted or not. 1 is true and 0 is false.

    boolUser21 DWORD 0 ; this is an initialized DWORD variable. this variable is used to determine whether the user has 21 or not. 1 is true and 0 is false.

    boolHouseBust DWORD 0 ; this is an initialized DWORD variable. this variable is used to determine whether the house has busted or not. 1 is true and 0 is false.
     
    boolHouse21 DWORD 0 ; this is an initialized DWORD variable. this variable is used to determine whether the house has 21 or not. 1 is true and 0 is false.

    boolHouseBusted DWORD ? ; this is an uninitialized DWORD variable. this variable is used to determine whether the house has busted or not. 1 is true and 0 is false.

    answer BYTE 2 DUP(0) ; this is an initialized array of DWORD elements. the elements are initialized to 0, and they are used to keep track
                         ; of the response to the TryAgain label as well as the null terminator.

; **********************************************************************;
; Functional description of the main program
;   
;   Inputs: The main program does not have any designated inputs. However, the user will be prompted to enter values in the terminal.
;
;   Outputs: The main program does not have any designated outputs. However, prompts will be displayed in the terminal.
;
;	Registers used and associated purpose of each:
;	    EAX - This is the Extended Accumulator Register. This register is used to hold values for arithmetic operations, as well as to hold values for the SetTextColor procedure.
;       ECX - This is the Extended Counter Register. This register is used to hold values for loops, as well as to hold values for the ReadString procedure.
;       EBX - This is the Extended Base Register. This register is used to hold values for comparisons, the RandomRange procedure, and for arithmetic operations. 
;       EDX - This is the Extended Data Register. This register is used to hold values for the WriteString procedure, as well as to hold values for the ReadString procedure.
;       AL - This is the Accumulator Low Register. This register is used to hold values for the ReadChar procedure. 
;
;	Memory locations use and associated purpose of each:
;       displayNotEnoughMoney - this displays a message to the user that they don't have enough money to bet.
;       promptRebet - this prompt the user to enter a valid amount of money they'd like to bet.
;       promptBet - this prompts the user to enter the amount of money they'd like to bet.
;       displayLuckyNumber - this displays a message that their bet is confirmed.
;       displayWallet - this displays the amount of money the user has in their wallet.
;       displayShuffleCards - this displays a message to the user that the cards are being shuffled.
;       displayGoodbye - this displays a farewell message
;       displayUserWon - this displays a message to the user that they have won the game.
;       displayHouseWon - this displays a message to the user that they have lost the game.
;       displayTie21 - this displays a message to the user that both the user and the house got a 21.
;       displayTie - this displays a message to the user that the game ended in a tie.
;       displayHouseBust - this displays a message to the user that the house has busted.
;       displayHouse21 - this displays a message to the user that the house has 21.
;       displayTotalValueHouse - this displays the total value of the house's hand.
;       displayTotalValueUser - this displays the total value of the user's hand.
;       promptHitOrStand - this prompt the user to decide whether they'd like to hit or stand.
;       displayCardsHouse - this displays a message to the user that shows the house's hand of cards.
;       displayCardsUser - this displays a message to the user that shows the user's hand of cards.
;       displayOf - this display is a part of a message which shows the number and suit of a card
;       displayAnd - this display is a part of a message which shows the number and suit of a card
;       displayAce - this displays the word "Ace"
;       displayTwo - this displays the word "Two"
;       displayThree - this displays the word "Three"
;       displayFour - this displays the word "Four"
;       displayFive - this displays the word "Five"
;       displaySix - this displays the word "Six"
;       displaySeven - this displays the word "Seven"
;       displayEight - this displays the word "Eight"
;       displayNine - this displays the word "Nine"
;       displayTen - this displays the word "Ten"
;       displayJack - this displays the word "Jack"
;       displayQueen - this displays the word "Queen"
;       displayKing - this displays the word "King"
;       displayHearts - this displays the word "Hearts"
;       displayDiamonds - this displays the word "Diamonds"
;       displaySpades - this displays the word "Spades"
;       displayClubs - this displays the word "Clubs"
;       promptStartGame1 - this prompt the user to decide whether they'd like to play the game or not. This is the first part
;                          of fiive prompts.
;       promptStartGame2 - this prompt the user to decide whether they'd like to play the game or not. This is the second part
;                         of five prompts.
;       promptStartGame3 - this displays a message to the user that they have chosen not to play the game. This is the third
;                          of five prompts.
;       promptStartGame4 - this displays a message to the user that they have chosen not to play the game. This is the fourth
;                          of five prompts.
;       promptStartGame5 - this displays a message to the user that they have chosen not to play the game. This is the fifth
;                          of five prompts.
;       displayRules - this displays the rules of the game to the user. This is the first part of seven prompts.
;       displayRules2 - this displays the rules of the game to the user. This is the second part of seven prompts.
;       displayRules3 - this displays the rules of the game to the user. This is the third part of seven prompts.
;       displayRules4 - this displays the rules of the game to the user. This is the fourth part of seven prompts.
;       displayRules5 - this displays the rules of the game to the user. This is the fifth part of seven prompts.
;       displayRules6 - this displays the rules of the game to the user. This is the sixth part of seven prompts.
;       displayRules7 - this displays the rules of the game to the user. This is the seventh part of seven prompts.
;       displayBlack - this displays the word "Black"
;       displayUser21 - this displays a message to the user that they have won the game
;       displayUserBust - this displays a message to the user that they have lost the game
;       promptTryAgain - this prompts the user to decide whether they'd like to continue the program or not.
;       promptErrorTry - this declares that the user entered an invalid response, then it prompts the user to try again.
;       promptErrorResp - this declares that the user entered an invalid response, then it prompts the user to try again.
;       BLACKJACKMULTIPLIER - this is a multiplier used to calculate the winnings for a blackjack hand. this is a constant.
;       userWallet - this is a variable that holds the amount of money the user has in their wallet.
;       MINBET - this is a variable that holds the minimum bet amount.
;       userBet - this is a variable that holds the amount of money the user has bet.
;       aceCount - this is a variable that holds the number of aces in the user's hand.
;       MINIMUMCARDSBEFORESHUFFLE - this is a variable that holds the minimum number of cards before the deck is shuffled. this is a constant.
;       MAXDECKNUMBER - this is a variable that holds the maximum number of decks in the game. this is a constant.
;       chosenCard - this is a variable that holds the card that has been chosen.
;       cardDeck - this is an array that holds all the cards in the deck.
;       delayValue - this is a variable that holds the delay value for the program.
;       delayValue2 - this is a variable that holds the delay value for the program.
;       delayValue3 - this is a variable that holds the delay value for the program.
;       startingHandCount - this is a variable that holds the number of cards in the starting hand.
;       userTotalCards - this is a variable that holds the total number of cards in the user's hand.
;       userHand - this is an array that holds all the cards in the user's hand.
;       userHandSuit - this is an array that holds all the suits in the user's hand.
;       userTotalValue - this is a variable that holds the total value of the user's hand.
;       TWENTYONE - this is a variable that holds the value of 21. this is a constant.
;       houseTotalCards - this is a variable that holds the total number of cards in the house's hand.
;       houseHand - this is an array that holds all the cards in the house's hand.
;       houseHandSuit - this is an array that holds all the suits in the house's hand.
;       houseTotalValue - this is a variable that holds the total value of the house's hand.
;       cardDeckNumbers - this is an array that holds all the numbers in the deck.
;       cardDeckSuits - this is an array that holds all the suits in the deck.
;       boolUserBust - this is a boolean variable that indicates if the user has busted.
;       boolUser21 - this is a boolean variable that indicates if the user has 21.
;       boolHouseBust - this is a boolean variable that indicates if the house has busted.
;       boolHouse21 - this is a boolean variable that indicates if the house has 21.
;       boolHouseBusted - this is a boolean variable that indicates if the house has busted.
;       answer - this is a variable that holds the user's answer to prompts.
;	Functional details: 
;       The main program runs almost entirely within the MainProgram procedure. Furthermore, the MainProgram procedure is responsible
;       for all of the display outputs as well as handling all of the user inputs. This procedure does utilize other procedures as well,
;       specifically CheckShuffleCards, SeedCard, and SeedSuit. These procedures are ancillary, and have the purpose of supporting
;       the main program. Without the ancillary procedures, the main program will still run, but not as efficiently. More information
;       regarding the ancillary procedures can be found in the comments above each procedure. In addition to that, more information
;       regarding the MainProgram procedure can be found in the comments above the procedure.
;  
; **********************************************************************;

.code

;***********************************
; Description: This procedure checks if the cards need to be shuffled. If so, then they will be shuffled within this procedure. If not,
;              then they will not be shuffled.
; Receives: This procedure does not directly receive anything.
; Returns: This procedure does not directly return anything.
; Requires: This procedure requires the Irvine32 library as well as the array cardDeck.
;***********************************
CheckShuffleCards PROC
    
    CheckCards:
        mov eax, 0 ; this sets the value of eax to 0
        mov ecx, 0 ; this sets the value of ecx to 0
        mov ebx, MAXDECKNUMBER ; this moves the value of MAXDECKNUMBER into ebx

        .WHILE ecx < LENGTHOF cardDeck ; while the value in ecx is less than the length of the cardDeck array
            .IF cardDeck[ecx*4] >= ebx ; if the value of the cardDeck array at the index in ecx is equal to 0
                inc eax ; this increases the value in eax by 1
            .ENDIF

            cmp eax, MINIMUMCARDSBEFORESHUFFLE ; this compares the value in eax to 39
            jge ShuffleCards ; if the value in eax is greater than or equal to 3, then jump to the ShuffleCards label

            inc ecx ; this increases the value in ecx by 1
        .ENDW

        ret

    ShuffleCards:
        
        call Crlf ; new line

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        mov edx, OFFSET displayShuffleCards ; prepares the string displayShuffleCards to be displayed
        call WriteString ; this displays a string from edx

        call Crlf ; new line
        call Crlf ; new line

        mov eax, delayValue ; this moves the value of delayValue into eax
        call Delay ; this delays the program for the amount of time in milliseconds specified in eax

        Call Crlf ; new line

        mov ecx, 0 ; this sets the value of ecx to 0

        .WHILE ecx < LENGTHOF cardDeck ; while the value in ecx is less than the length of the cardDeck array
            mov cardDeck[ecx*4], 0 ; this sets the value of the cardDeck array at the index in ecx to 0
            inc ecx ; this increases the value in ecx by 1
        .ENDW

    ret

CheckShuffleCards ENDP

;***********************************
; Description: This procedure is used to generate a random number value.
; Receives: This procedure does not directly receive anything.
; Returns: This procedure returns a random value saved in eax.
; Requires: This procedure requires the Irvine32 library as well as the array cardDeckNumbers.
;***********************************
SeedCard PROC
    mov eax, LENGTHOF cardDeckNumbers ; this gets the length of the cardDeckNumbers array and saves it in eax

    call RandomRange ; this generates a random number between 0 and the length of the cardDeckNumbers array and saves it in eax
    
    ret
SeedCard ENDP

;***********************************
; Description: This procedure is used to generate a random suit value.
; Receives: This procedure does not directly receive anything.
; Returns: This procedure returns a random value saved in eax.
; Requires: This procedure requires the Irvine32 library as well as the array cardDeckSuits.
;***********************************
SeedSuit PROC
    mov eax, LENGTHOF cardDeckSuits ; this gets the length of the cardDeckSuits array and saves it in eax

    call RandomRange ; this generates a random number between 0 and the length of the cardDeckSuits array and saves it in eax
    
    ret
SeedSuit ENDP

;***********************************
; Description: This procedure starts with the user in a main menu. The user will be prompted to decide whether they'd like to play BlackJack or not. If no, then
;              the program will end. If yes, then the user will be prompted to decide whether they'd like to hear the rules or not. If no, then the rules will not
;              be displayed. If yes, the rules will be displayed. Afterwards, the game will start. The first thing the user must do is place a bet greater than minimum bet.
;              If in any case the user doesn't have enough money to match the minimum bet, the game will end. Once the bet has been placed, program will call the
;              procedure CheckShuffleCards. This is done to see if the cards need shuffling. The default settings of this game ensure that only one deck
;              of cards are used. Also, before the user is dealt any cards, the procedures SeedCard and SeedSuit will be called to generate a random card and suit.
;              The total value of the cards will be displayed, and the user will be prompted to hit or stand. If the user hits, then they will be dealt another card
;              and the total value will display again. Once more they will be prompted to hit or stand. When the user decides to stand, the house will then be dealt
;              two cards. The total value of the house's cards will be displayed. If the house has a total value of less than 17, then they must hit. If the house has
;              a total value of 17 or more, then they must stand. The winner will be calculated by comparison of who is the closest to 21.
;
;              There are more than a few comparisons to determine who the winner is. If the user busts, then they immediately lose. If the house busts, then they
;              immediately lose. Due to the single-player nature of this program, there is no case where both the house and the user bust. If the user hits 21
;              and the house has not, then the user wins. Furthermore, if the user gets a BlackJack (their two deal cards are an Ace and a 10), then the user
;              gets a special pay out of 2x their bet. In any other case the user wins, they will get 1x their bet. If they lose, then they will lose their bet.
;              Next, if the house gets 21 and the user doesn't then they win. If the user gets 21 and the house gets 21, then it is a tie. Also, any other case where the
;              user and the house have the same total value of cards results in a tie. In a tie, there is no payout. The user loses no money but also gains no money.
;              After the winner is determined, the user is prompted to decide whether they'd like to play again. If no, then the program ends. If yes, then the program starts
;              by dealing two new cards to the user.
;
;              Three features have been added for playability of the program. The first feature is the use of only one deck in the game, though multiple can be chosen if
;              desired. This is done by changing the variable "MAXDECKNUMBER" in the .data section. This program will remember what cards were already dealt. They cannot
;              be used again until the cards are shuffled. The next feature is the betting system. So long as the program remains open, the amount of money the user has
;              will be remembered. There is no feature to save their money when the program is closed. The final feature is an Ace Algorithm which immediately
;              deals with the nuances of Aces within the game. If it is more beneficial for an Ace to be an eleven, then it will remain an eleven. If it is more beneficial for the
;              Ace to be a one, then it will become a one.
; Receives: This procedure does not directly receive anything. However, the user will be prompted to input values.
; Returns: This procedure does not directly return anything. However, prompts will be displayed to the terminal.
; Requires: This procedure requires the Irvine32 library, the SeedSuit procedure, the SeedCard procedure, and the CheckShuffleCards procedure.
;***********************************
MainProgram PROC
    StartGame: ; this label is used to display the main menu of the BlackJack game and prompt the user to decide whether they would like to play the game or not
        mov edx, OFFSET promptStartGame1 ; prepares the string promptStartGame1 to be displayed
        call WriteString ; this displays a string from edx
        
        mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        mov edx, OFFSET displayBlack ; prepares the string displayBlack to be displayed
        call WriteString ; this displays a string from edx

        mov eax, white + (black * 16) ; this sets the color of the text to white and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        mov edx, OFFSET displayJack ; prepares the string displayJack to be displayed
        call WriteString ; this displays a string from edx

        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
        call SetTextColor ; this sets the text color to the value in eax

        mov edx, OFFSET promptStartGame2 ; prepares the string promptStartGame2 to be displayed
        call WriteString ; this displays a string from edx

        CheckAnswer: ; this label is used to check the user's answer to the prompt of whether they would like to play the game or not

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

                jmp MainMenu ; jump to the MainMenu label
            .ELSEIF answer[0] == 'n' || answer[0] == 'N' ; if the answer is no
                call Crlf ; new line
                call Crlf ; new line

                mov edx, OFFSET promptStartGame3 ; prepares the string promptStartGame3 to be displayed
                call WriteString ; this displays a string from edx

                call Crlf ; new line

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

        MainMenu: ; this label is used if the user decided to play the game
            
            mov edx, OFFSET promptStartGame4 ; prepares the string promptStartGame4 to be displayed
            call WriteString ; this displays a string from edx

            CheckAnswer1: ; this label is used to check the user's answer to the prompt of whether they would like to hear the rules of the game or not

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

                    jmp ShowRules ; jump to the ShowRules label
                .ELSEIF answer[0] == 'n' || answer[0] == 'N' ; if the answer is no
                    call Crlf ; new line
                    call Crlf ; new line

                    mov edx, OFFSET promptStartGame5 ; prepares the string promptStartGame5 to be displayed
                    call WriteString ; this displays a string from edx

                    call Crlf ; new line
                    call Crlf ; new line
                    call Crlf ; new line

                    jmp PlayGame ; jump to the PlayGame label
                .ELSE ; if the answer is not yes or no
                    call Crlf ; new line 

                    mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
                    call SetTextColor ; this sets the text color to the value in eax
            
                    mov edx, OFFSET promptErrorResp ; prepares the string promptErrorResp to be displayed
                    call WriteString ; displays a string from the edx offset

                    mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                    call SetTextColor ; this sets the text color to the value in eax

                    jmp CheckAnswer1 ; jump to the CheckAnswer1 label
                .ENDIF ; end the if statements

            ShowRules: ; this label is used to show the rules of the game to the user
                mov edx, OFFSET displayRules ; prepares the string displayRules to be displayed
                call WriteString ; this displays a string from edx

                call Crlf ; new line
                call Crlf ; new line

                mov eax, delayValue2 ; this moves the value of delayValue2 into eax
                call Delay ; this delays the program for the amount of time in milliseconds specified in eax

                mov edx, OFFSET displayRules2 ; prepares the string displayRules2 to be displayed
                call WriteString ; this displays a string from edx

                call Crlf ; new line
                call Crlf ; new line

                mov eax, delayValue2 ; this moves the value of delayValue2 into eax
                call Delay ; this delays the program for the amount of time in milliseconds specified in eax

                mov edx, OFFSET displayRules3 ; prepares the string displayRules3 to be displayed
                call WriteString ; this displays a string from edx

                call Crlf ; new line
                call Crlf ; new line

                mov eax, delayValue2 ; this moves the value of delayValue2 into eax
                call Delay ; this delays the program for the amount of time in milliseconds specified in eax

                mov edx, OFFSET displayRules4 ; prepares the string displayRules4 to be displayed
                call WriteString ; this displays a string from edx

                call Crlf ; new lone
                call Crlf ; new line

                mov eax, delayValue2 ; this moves the value of delayValue2 into eax
                call Delay ; this delays the program for the amount of time in milliseconds specified in eax

                mov edx, OFFSET displayRules5 ; prepares the string displayRules5 to be displayed
                call WriteString ; this displays a string from edx

                call Crlf ; new line
                call Crlf ; new line

                mov eax, delayValue2 ; this moves the value of delayValue2 into eax
                call Delay ; this delays the program for the amount of time in milliseconds specified in eax

                mov edx, OFFSET displayRules6 ; prepares the string displayRules6 to be displayed
                call WriteString ; this displays a string from edx

                call Crlf ; new line
                call Crlf ; new line

                mov eax, delayValue2 ; this moves the value of delayValue2 into eax
                call Delay ; this delays the program for the amount of time in milliseconds specified in eax

                mov edx, OFFSET displayRules7 ; prepares the string displayRules7 to be displayed
                call WriteString ; this displays a string from edx

                call Crlf ; new line
                call Crlf ; new line
                call Crlf ; new line

                mov eax, delayValue2 ; this moves the value of delayValue2 into eax
                call Delay ; this delays the program for the amount of time in milliseconds specified in eax

                jmp PlayGame ; jump to the PlayGame label

    PlayGame: ; this label is ran to start running the BlackJack game
        DefaultSettings: ; this label is used to set the default settings for the game
            call Randomize ; this seeds the random number generator with the current time

            mov boolUserBust, 0 ; this sets the value of boolUserBust to 0
            mov boolUser21, 0 ; this sets the value of boolUser21 to 0
            
            mov boolHouseBust, 0 ; this sets the value of boolHouseBust to 0
            mov boolHouse21, 0 ; this sets the value of boolHouse21 to 0

            mov userBet, 0 ; this sets the value of userBet to 0

            mov aceCount, 0 ; this sets the value of aceCount to 0
            
            mov ecx, 0 ; this sets the value of ecx to 0

            .WHILE ecx < LENGTHOF userHand ; while the value in ecx is less than the length of the userHand array
                mov userHand[ecx*4], 0 ; this sets the value of the userHand array at the index in ecx to 0
                mov userHandSuit[ecx*4], 0 ; this sets the value of the userHandSuit array at the index in ecx to 0
                
                inc ecx ; this increases the value in ecx by 1
            .ENDW

        DealUser: ; this label is used to deal the user cards

            call CheckShuffleCards ; this calls the CheckShuffleCards procedure to check if the cards need to be shuffled

            mov ebx, MINBET ; this moves the value of MINBET into ebx

            .IF userWallet < ebx
                
                mov edx, OFFSET displayNotEnoughMoney ; prepares the string displayNotEnoughMoney to be displayed
                call WriteString ; this displays a string from edx

                call Crlf ; new line
                call Crlf ; new line

                jmp EndProgram ; jump to the EndProgram label
                
            .ENDIF

            Betting:
                mov edx, OFFSET displayWallet ; prepares the string displayWallet to be displayed
                call WriteString ; this displays a string from edx

                mov eax, lightGreen + (black * 16) ; this sets the color of the text to light green and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov eax, userWallet ; this moves the value of userWallet into eax
                call WriteDec ; this displays the value in eax as a decimal number

                mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                call SetTextColor ; this sets the text color to the value in eax
            
                call Crlf ; new line
                call Crlf ; new line

                mov edx, OFFSET promptBet ; prepares the string promptBet to be displayed
                call WriteString ; this displays a string from edx

                mov eax, MINBET ; this prepares the variable MINBET to be displayed
                call WriteDec ; this displays the variable MINBET from eax

                mov al, ':' ; this prepares the character ':' to be displayed
                call WriteChar ; this displays the variable ':'

                mov al, ' ' ; this prepares the character ' ' to be displayed
                call WriteChar ; this displays the variable ' '

                mov eax, lightBlue + (black * 16) ; this sets the color of the text to light blue and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                call ReadDec ; this reads a decimal number from the user and saves it in eax

                mov userBet, eax ; this saves the value in eax into userBet

                mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                call Crlf ; new line
                call Crlf ; new line

                CheckBet:
                    mov ebx, MINBET ; this moves the value of MINBET into ebx
                    mov edx, userWallet ; this moves the value of userWallet into edx

                    .IF userBet < ebx || userBet > edx ; if the value of userBet is less than the value of MINBET or greater than the value of userWallet
                        mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
                        call SetTextColor ; this sets the text color to the value in eax

                        mov edx, OFFSET promptRebet ; prepares the string promptRebet to be displayed
                        call WriteString ; this displays a string from edx

                        mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                        call SetTextColor ; this sets the text color to the value in eax

                        call Crlf ; new line
                        call Crlf ; new line

                        jmp Betting           
                    .ELSE
                        mov edx, OFFSET displayLuckyNumber
                        call WriteString

                        call Crlf ; new line
                        call Crlf ; new line
                        call Crlf ; new line

                        jmp SuccessBet
                    .ENDIF

            SuccessBet:        
                mov ecx, 0 ; this sets the value of ecx to 0

                .WHILE ecx < startingHandCount ; while the value in ecx is less than the startingHandCount variable

                    DetermineSuit: ; this label is used to determine the suit of the dealt card
                        call SeedSuit ; this calls the SeedSuit procedure to generate a random number between 0 and the length of the cardDeckSuits array and saves it in eax

                        mov edx, cardDeckSuits[eax*4] ; this moves the value at the index in eax times four of the cardDeckSuits array into edx
                        mov userHandSuit[ecx*4], edx ; this saves the value at the index in eax times four into the first element of the userHandSuit array

                        mov ebx, 13 ; this moves the value of 13 into ebx
                        mul ebx ; this multiplies the value in eax by the value in ebx and saves the result in eax

                        mov chosenCard, eax ; this saves the value in eax into chosenCard

                    DetermineNumber: ; this label is used to determine the number of the dealt card
                        call SeedCard ; this calls the SeedCard procedure to generate a random number between 0 and the length of the cardDeckNumbers array and saves it in eax

                        mov edx, cardDeckNumbers[eax*4] ; this moves the value at the index in eax times four of the cardDeckNumbers array into edx
                        mov userHand[ecx*4], edx ; this saves the value at the index in eax times four into the first element of the userHand array

                        add chosenCard, eax ; this adds the value in eax to the value in chosenCard
                
                    ProcessCard: ; this label is used to check if the card limit has been reached for the dealt card
                        mov eax, chosenCard ; this moves the value in chosenCard into eax
                        mov ebx, MAXDECKNUMBER ; this moves the value in MAXDECKNUMBER into ebx

                        .IF cardDeck[eax*4] == ebx ; if the value of the cardDeck array at the index in eax is equal to ebx
                            jmp DetermineSuit ; jump to the DetermineSuit label
                        .ENDIF

                        inc cardDeck[eax*4] ; this increases the value of the cardDeck array at the index in eax by 1
                
                    inc ecx ; this increases the value in ecx by 1
                .ENDW

                mov userTotalCards, ecx ; this saves the value in ecx into userTotalCards

            CalculateTotalUser: ; this label is used to calculate the total value of the user's hand of cards
                mov ecx, 0 ; this sets the value of ecx to 0
                mov userTotalValue, 0 ; this sets the value of userTotalValue to 0
                mov aceCount, 0

                .WHILE ecx < userTotalCards ; while the value in ecx is less than the value of userTotalCards


                    .IF userHand[ecx*4] == OFFSET displayAce ; if the card is an Ace
                        inc aceCount
                        add userTotalValue, 11 ; this adds 11 to the value of userTotalValue
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

                    mov eax, TWENTYONE ; this moves the value of TWENTYONE into eax

                    ; BELOW IS THE ACE ALGORITHM. THIS ALGORITHM WAS FOUND AT: https://people.cs.pitt.edu/~jmisurda/teaching/cs401/2157/cs0401-2157-project2.htm

                    .WHILE userTotalValue > eax && aceCount > 0  ; while the value of userTotalValue is greater than 21 and the value of aceCount is greater than 0
                        sub userTotalValue, 10 ; this subtracts 10 from the value of userTotalValue
                        dec aceCount ; this decreases the value of aceCount by 1
                    .ENDW

                    inc ecx ; this increases the value in ecx by 1
                .ENDW

            ShowCardsUser: ; this label is used to show the user's hand of cards
                mov edx, OFFSET displayCardsUser ; prepares the string displayCardsUser to be displayed
                call WriteString ; this displays a string from edx

                call Crlf ; new line
                call Crlf ; new line

                mov eax, black + (white * 16) ; this sets the color of the text to black and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov ecx, 0 ; this sets the value of ecx to 0

                .WHILE ecx < userTotalCards ; while the value in ecx is less than the value of userTotalCards

                    mov eax, delayValue3 ; this moves the value of delayValue into eax
                    call Delay ; this delays the program for the amount of time in milliseconds specified in eax

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

                mov eax, delayValue3 ; this moves the value of delayValue into eax
                call Delay ; this delays the program for the amount of time in milliseconds specified in eax

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

            CheckForEndGameUser: ; this label is used to determine whether the user has busted or has 21
                mov eax, userTotalValue ; this moves the value of userTotalValue into eax

                .IF eax > TWENTYONE ; if the value of userTotalValue is greater than 21
                    mov boolUserBust, 1 ; this sets the value of boolUserBust to 1
                    jmp EndGame ; jump to the EndGame label
                .ELSEIF eax == TWENTYONE ; if the value of userTotalValue is equal to 21
                    mov boolUser21, 1 ; this sets the value of boolUser21 to 1

                    mov eax, delayValue ; this moves the value of delayValue into eax
                    call Delay ; this delays the program for the amount of time in milliseconds specified in eax

                    jmp DealHouse ; jump to the DealHouse label
                .ENDIF

            HitOrStandUser: ; this label is used to prompt the user to decide whether they would like to hit or stand
                mov edx, OFFSET promptHitOrStand ; prepares the string promptHitOrStand to be displayed
                call WriteString ; this displays a string from edx

                CheckAnswer2: ; this label is used to check the user's answer to the prompt of whether they would like to hit or stand

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

            HitUser: ; this label is ran if the user wants to hit

                call CheckShuffleCards ; this calls the CheckShuffleCards procedure to check if the cards need to be shuffled

                mov ecx, userTotalCards ; this moves the value of userTotalCards into ecx

                DetermineSuit2: ; this label is used to determine the suit of the dealt card
                    call SeedSuit ; this calls the SeedSuit procedure to generate a random number between 0 and the length of the cardDeckSuits array and saves it in eax

                    mov edx, cardDeckSuits[eax*4] ; this moves the value at the index in eax times four of the cardDeckSuits array into edx
                    mov userHandSuit[ecx*4], edx ; this saves the value at the index in eax times four into the first element of the userHandSuit array

                    mov ebx, 13 ; this moves the value of 13 into ebx
                    mul ebx ; this multiplies the value in eax by the value in ebx and saves the result in eax

                    mov chosenCard, eax ; this saves the value in eax into chosenCard

                DetermineNumber2: ; this label is used to determine the number of the dealt card
                    call SeedCard ; this calls the SeedCard procedure to generate a random number between 0 and the length of the cardDeckNumbers array and saves it in eax

                    mov edx, cardDeckNumbers[eax*4] ; this moves the value at the index in eax times four of the cardDeckNumbers array into edx
                    mov userHand[ecx*4], edx ; this saves the value at the index in eax times four into the first element of the userHand array

                    add chosenCard, eax ; this adds the value in eax to the value in chosenCard
                
                ProcessCard2: ; this label is used to check if the card limit has been reached for the dealt card
                    mov eax, chosenCard ; this moves the value in chosenCard into eax
                    mov ebx, MAXDECKNUMBER ; this moves the value in MAXDECKNUMBER into ebx

                    .IF cardDeck[eax*4] == ebx ; if the value of the cardDeck array at the index in eax is equal to ebx
                        jmp DetermineSuit2 ; jump to the DetermineSuit label
                    .ENDIF

                    inc cardDeck[eax*4] ; this increases the value of the cardDeck array at the index in eax by 1

                inc ecx ; this increases the value in ecx by 1

                mov userTotalCards, ecx ; this saves the value in ecx into userTotalCards

                jmp CalculateTotalUser ; jump to the CalculateTotalUser label

            StandUser: ; this label is ran if the user wants to stand
                jmp DealHouse ; jump to the DealHouse label
        
        DealHouse: ; this label is used to deal the house cards
            
            call CheckShuffleCards ; this calls the CheckShuffleCards procedure to check if the cards need to be shuffled

            mov ecx, 0 ; this sets the value of ecx to 0

            .WHILE ecx < startingHandCount ; while the value in ecx is less than the startingHandCount variable

                DetermineSuit3: ; this label is used to determine the suit of the dealt card
                    call SeedSuit ; this calls the SeedSuit procedure to generate a random number between 0 and the length of the cardDeckSuits array and saves it in eax

                    mov edx, cardDeckSuits[eax*4] ; this moves the value at the index in eax times four of the cardDeckSuits array into edx
                    mov houseHandSuit[ecx*4], edx ; this saves the value at the index in eax times four into the first element of the houseHandSuit array

                    mov ebx, 13 ; this moves the value of 13 into ebx
                    mul ebx ; this multiplies the value in eax by the value in ebx and saves the result in eax

                    mov chosenCard, eax ; this saves the value in eax into chosenCard

                DetermineNumber3: ; this label is used to determine the number of the dealt card
                    call SeedCard ; this calls the SeedCard procedure to generate a random number between 0 and the length of the cardDeckNumbers array and saves it in eax

                    mov edx, cardDeckNumbers[eax*4] ; this moves the value at the index in eax times four of the cardDeckNumbers array into edx
                    mov houseHand[ecx*4], edx ; this saves the value at the index in eax into the first element of the houseHand array

                    add chosenCard, eax ; this adds the value in eax to the value in chosenCard

                ProcessCard3: ; this label is used to check if the card limit has been reached for the dealt card
                    mov eax, chosenCard ; this moves the value in chosenCard into eax
                    mov ebx, MAXDECKNUMBER ; this moves the value in MAXDECKNUMBER into ebx

                    .IF cardDeck[eax*4] == ebx ; if the value of the cardDeck array at the index in eax is equal to ebx
                        jmp DetermineSuit3 ; jump to the DetermineSuit label
                    .ENDIF

                    inc cardDeck[eax*4] ; this increases the value of the cardDeck array at the index in eax by 1

                inc ecx ; this increases the value in ecx by 1
            .ENDW

            mov houseTotalCards, ecx ; this saves the value in ecx into houseTotalCards

            CalculateTotalHouse: ; this label is used to calculate the total value of the house's hand of cards
                mov ecx, 0 ; this sets the value of ecx to 0
                mov houseTotalValue, 0 ; this sets the value of houseTotalValue to 0
                mov aceCount, 0 ; this sets the value of aceCount to 0

                .WHILE ecx < houseTotalCards ; while the value in ecx is less than the value of houseTotalCards
                    .IF houseHand[ecx*4] == OFFSET displayAce ; if the card is an Ace
                        inc aceCount ; increase the variable aceCount by 1
                        add houseTotalValue, 11 ; this adds 11 to the value of houseTotalValue
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

                    mov eax, TWENTYONE ; this moves the value of TWENTYONE into eax

                    ; BELOW IS THE ACE ALGORITHM. THIS ALGORITHM WAS FOUND AT: https://people.cs.pitt.edu/~jmisurda/teaching/cs401/2157/cs0401-2157-project2.htm

                    .WHILE houseTotalValue > eax && aceCount > 0  ; while the value of houseTotalValue is greater than 21 and the value of aceCount is greater than 0
                        sub houseTotalValue, 10 ; this subtracts 10 from the value of houseTotalValue
                        dec aceCount ; this decreases the value of aceCount by 1
                    .ENDW

                    inc ecx ; this increases the value in ecx by 1
                .ENDW

             ShowCardsHouse: ; this label is used to show the house's hand of cards
                mov edx, OFFSET displayCardsHouse ; prepares the string displayCardsHouse to be displayed
                call WriteString ; this displays a string from edx

                call Crlf ; new line
                call Crlf ; new line

                mov eax, black + (white * 16) ; this sets the color of the text to black and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov ecx, 0 ; this sets the value of ecx to 0

                .WHILE ecx < houseTotalCards ; while the value in ecx is less than the value of houseTotalCards

                    mov eax, delayValue3 ; this moves the value of delayValue into eax
                    call Delay ; this delays the program for the amount of time in milliseconds specified in eax

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

                mov eax, delayValue3 ; this moves the value of delayValue into eax
                call Delay ; this delays the program for the amount of time in milliseconds specified in eax

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


                CheckForEndGameHouse: ; this label is used to determine whether the house has busted or has 21
                    mov eax, delayValue ; this moves the value of delayValue into eax

                    call Delay ; this calls the Delay procedure to delay the program for a certain amount of time

                    mov eax, houseTotalValue ; this moves the value of userTotalValue into eax

                    .IF eax > TWENTYONE ; if the value of houseTotalValue is greater than 21
                        mov boolHouseBust, 1 ; this sets the value of boolHouseBust to 1
                        
                        jmp EndGame ; jump to the EndGame label
                    .ELSEIF eax == TWENTYONE ; if the value of houseTotalValue is equal to 21
                        mov boolHouse21, 1 ; this sets the value of boolHouse21 to 1
                        
                        jmp EndGame ; jump to the EndGame label
                    .ELSEIF eax >= 17 ; if the value of houseTotalValue is greater than or equal to 17
                        jmp EndGame ; jump to the EndGame label
                    .ELSE ; if the value of houseTotalValue is less than 17

                        call CheckShuffleCards ; this calls the CheckShuffleCards procedure to check if the cards need to be shuffled

                        mov ecx, houseTotalCards ; this moves the value of houseTotalCards into ecx

                        DetermineSuit4: ; this label is used to determine the suit of the dealt card
                            call SeedSuit ; this calls the SeedSuit procedure to generate a random number between 0 and the length of the cardDeckSuits array and saves it in eax

                            mov edx, cardDeckSuits[eax*4] ; this moves the value at the index in eax times four of the cardDeckSuits array into edx
                            mov houseHandSuit[ecx*4], edx ; this saves the value at the index in eax times four into the first element of the houseHandSuit array

                            mov ebx, 13 ; this moves the value of 13 into ebx
                            mul ebx ; this multiplies the value in eax by the value in ebx and saves the result in eax

                            mov chosenCard, eax ; this saves the value in eax into chosenCard

                        DetermineNumber4: ; this label is used to determine the number of the dealt card
                            call SeedCard ; this calls the SeedCard procedure to generate a random number between 0 and the length of the cardDeckNumbers array and saves it in eax

                            mov edx, cardDeckNumbers[eax*4] ; this moves the value at the index in eax times four of the cardDeckNumbers array into edx
                            mov houseHand[ecx*4], edx ; this saves the value at the index in eax into the first element of the houseHand array

                            add chosenCard, eax ; this adds the value in eax to the value in chosenCard

                        ProcessCard4: ; this label is used to check if the card limit has been reached for the dealt card
                            mov eax, chosenCard ; this moves the value in chosenCard into eax
                            mov ebx, MAXDECKNUMBER ; this moves the value in MAXDECKNUMBER into ebx

                            .IF cardDeck[eax*4] == ebx ; if the value of the cardDeck array at the index in eax is equal to ebx
                                jmp DetermineSuit4 ; jump to the DetermineSuit4 label
                            .ENDIF

                            inc cardDeck[eax*4] ; this increases the value of the cardDeck array at the index in eax by 1

                        inc ecx ; this increases the value in ecx by 1

                        mov houseTotalCards, ecx ; this saves the value in ecx into houseTotalCards

                        jmp CalculateTotalHouse ; jump to the CalculateTotalHouse label
                    .ENDIF

        EndGame: ; this label is used to determine the winner of the game
            
            .IF boolUserBust == 1 ; if the user has busted
                
                mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov edx, OFFSET displayUserBust ; prepares the string displayUserBust to be displayed
                call WriteString ; this displays a string from edx

                mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                call Crlf ; new line

                mov eax, userBet ; this moves the value of userBet into eax

                sub userWallet, eax ; this subtracts the value in eax from the value in userWallet

                jmp TryAgain ; jump to the TryAgain label
            .ELSEIF boolHouseBust == 1 ; if the house has busted

                mov eax, lightGreen + (black * 16) ; this sets the color of the text to light green and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov edx, OFFSET displayHouseBust ; prepares the string displayHouseBust to be displayed
                call WriteString ; this displays a string from edx

                mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov eax, userBet ; this moves the value of userBet into eax

                add userWallet, eax ; this adds the value in eax to the value in userWallet

                call Crlf ; new line

                jmp TryAgain ; jump to the TryAgain label
            .ELSEIF boolUser21 == 1 && boolHouse21 == 0 ; if the user has 21 and the house does not
                .IF userTotalCards == 2 ; if the user has a natural BlackJack
                    
                    mov eax, userBet ; this moves the value of userBet into eax
                    mov ebx, BLACKJACKMULTIPLIER ; this moves the value of BLACKJACKMULTIPLIER into ebx

                    mul ebx ; this multiplies the value in eax by the value in ebx and saves the result in eax

                    add userWallet, eax ; this adds the value of eax into the variable userWallet

                .ENDIF

                mov eax, lightGreen + (black * 16) ; this sets the color of the text to light green and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov edx, OFFSET displayUser21 ; prepares the string displayUser21 to be displayed
                call WriteString ; this displays a string from edx

                mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                call SetTextColor ; this sets the text color to the value in eax
                
                call Crlf ; new line

                mov eax, userBet ; this moves the value of userBet into eax
                add userWallet, eax ; this adds the value in eax to the value in userWallet

                jmp TryAgain ; jump to the TryAgain label
            .ELSEIF boolUser21 == 1 && boolHouse21 == 1 ; if the user has 21 and the house has 21

                mov edx, OFFSET displayTie21 ; prepares the string displayTie21 to be displayed
                call WriteString ; this displays a string from edx

                call Crlf ; new line

                jmp TryAgain ; jump to the TryAgain label

            .ELSEIF boolUser21 == 0 && boolHouse21 == 1

                mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov edx, OFFSET displayHouse21 ; prepares the string displayHouse21 to be displayed
                call WriteString ; this displays a string from edx

                mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                call Crlf ; new line

                mov eax, userBet ; this moves the value of userBet into eax
                sub userWallet, eax ; this subtracts the value in eax from the value in userWallet

                jmp TryAgain ; jump to the TryAgain label
            .ENDIF

            mov eax, userTotalValue ; this moves the value of userTotalValue into eax

            .IF eax > houseTotalValue ; if the value of userTotalValue is greater than the value of houseTotalValue
                jmp UserWins ; jump to the UserWins label
            .ELSEIF eax == houseTotalValue ; if the value of userTotalValue is equal to the value of houseTotalValue
                mov edx, OFFSET displayTie ; prepares the string displayTie to be displayed
                call WriteString ; this displays a string from edx

                call Crlf ; new line

                jmp TryAgain ; jump to the TryAgain label
            .ELSE ; if the value of userTotalValue is less than the value of houseTotalValue
                jmp HouseWins ; jump to the HouseWins label
            .ENDIF

            UserWins: ; this label is ran if the user has won the game
                mov eax, lightGreen + (black * 16) ; this sets the color of the text to light green and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov edx, OFFSET displayUserWon ; prepares the string displayWonGame to be displayed
                call WriteString ; this displays a string from edx

                call Crlf ; new line

                mov eax, userBet ; this moves the value of userBet into eax
                add userWallet, eax ; this adds the value in eax to the value in userWallet

                mov eax, lightGray + (black * 16) ; this sets the color of the text to light grey and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                jmp TryAgain ; jump to the TryAgain label
            HouseWins: ; this label is ran if the house has won the game
                mov eax, lightRed + (black * 16) ; this sets the color of the text to light red and the background to black
                call SetTextColor ; this sets the text color to the value in eax

                mov edx, OFFSET displayHouseWon ; prepares the string displayHouseWon to be displayed
                call WriteString ; this displays a string from edx

                call Crlf ; new line

                mov eax, userBet ; this moves the value of userBet into eax
                sub userWallet, eax ; this subtracts the value in eax from the value in userWallet

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
