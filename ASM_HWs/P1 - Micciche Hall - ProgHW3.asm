; **********************************************************************;
; Program Name: Time Conversion Program
; Program Description: This program takes values for hours, minutes, and seconds then uses them to calculate
; the total amount of time in minutes and the total amount of time in seconds.
; Author: Terrence Micciche Hall
; Creation Date: 06/11/26
; Revisions:0
; Date Last Modified: 06/11/26
;***********************************************************************;

INCLUDE C:\Irvine\Irvine32.inc
INCLUDELIB C:\Irvine\Irvine32.lib

.data

    hours DWORD ? ; creates an unitialized variable hours
    minutes DWORD ? ; creates an uninitialized variable minutes
    seconds DWORD ? ; creates an uninitialized variable seconds

    totalMinutes DWORD ? ; creates an uninitialized variable totalMinutes
    totalSeconds DWORD ? ; creates an uninitialized variable totalSeconds

    hoursStr BYTE "Enter the number of hours:  ", 0 ; creates a request for hours string
    minsStr BYTE "Enter the number of minutes:  ", 0 ; creates a request for minutes string
    secsStr BYTE "Enter the number of seconds:  ", 0 ; creates a request for seconds string

    hoursDisp BYTE "The number of hours entered was ", 0 ; creates a display of hours string
    minsDisp BYTE "The number of minutes entered was ", 0 ; creates a display of minutes string
    secsDisp BYTE "The number of seconds entered was ", 0 ; creates a display of seconds string

    minutesTotalStr BYTE "The total number of minutes is ", 0 ; creates a total number of minutes string
    minutesTotalStr2 BYTE " minutes.", 0 ; creates the second half of the total number of minutes string

    secondsTotalStr BYTE "The total number of seconds is ", 0 ; creates a total number of seconds string
    secondsTotalStr2 BYTE " seconds.", 0 ; creates the second half of the total number of minutes string

    errorMessage BYTE "Please re-enter the value.  ", 0 ; creates a request to re-enter a value string

    tryAgainStr BYTE "Try Again (y/n)? ", 0 ; creates a request to run the program again string

    answer BYTE 2 DUP(0) ; creates an array to hold the response to tryAgainStr. this includes the null terminator



; **********************************************************************;
; Functional description of the main program
;   Inputs: The main program does not require any user inputs directly.
;	Outputs: The main program displays the entered hours, minutes, seconds, total minutes and total seconds.
;	Registers used and associated purpose of each:
;       EDX - This is the Extended Data register. This register is used to store the offset for strings.
;       EAX - This is the Extended Accumulator register. This register is used to store integers as well as any
;       calculations.
;       AL - This is the Accumulator Low register. This register is used to store characters.
;	Memory locations use and associated purpose of each
;       hours - This is an uninitialized variable with a DWORD data-type. This is used to hold the user input of hours.
;       minutes - This is an uninitialized variable with a DWORD data-type. This is used to hold the user input of minutes.
;       seconds - This is an uninitialized variable with a DWORD data-type. This is used to hold the user input of seconds.
;       totalMinutes - This is an uninitialized variable with a DWORD data-type. This is used to hold the calculated total time in minutes.
;       totalSeconds - This is an uninitialized variable with a DWORD data-type. This is used to hold the calculated total time in seconds.
;       hoursStr - This is an initialized string of the BYTE data-type. This is used to prompt the user to enter an integer of hours.
;       minsStr - This is an initialized string of the BYTE data-type. This is used to prompt the user to enter an integer of minutes.
;       secsStr - This is an initialized string of the BYTE data-type. This is used to prompt the user to enter an integer of seconds.
;       hoursDisp - This is an initialized string of the BYTE data-type. This is used to display the user input of hours.
;       minsDisp - This is an initialized string of the BYTE data-type. This is used to display the user input of minutes.
;       secsDisp - This is an initialized string of the BYTE data-type. This is used to display the user input of seconds.
;       minutesTotalStr - This is an initialized string of the BYTE data-type. This is used as the first half of the string to display the 
;       total amount of time in minutes.
;       minutesTotalStr2 - This is an initialized string of the BYTE data-type. This is used as the second half of the string to display the
;       total amount of time in minutes.
;       secondsTotalStr - This is an initialized string of the BYTE data-type. This is used as the first half of the string to display the
;       total amount of time in seconds.
;       secondsTotalStr2 - This is an initialized string of the BYTE data-type. This is used as the second half of the string to display the
;       total amount of time in secnds.
;       errorMessage - This is an initialized string of the BYTE data-type. This is used to prompt the user to re-enter a value. This string is
;       particularly used whenever an integer or character that the program is not expecting is inputted.
;       tryAgainStr - This is an initialized string of the BYTE data-type. This is used to prompt the user to either continue the program or to
;       end the program.
;       answer - This is an initialized array of all zeros of the data-type BYTE. This is used to hold both the user-inputted response to the
;       string tryAgainStr as well as the null terminator. The answer variable was created as a string as to perfectly match the example given
;       in part one of the CSC2025X40 Programming Homework for week three.
;	Functional details: The main program calls the TimeConv procedure, which deals with all of the user
;   inputs, calculations, as well as all of the program outputs.
; **********************************************************************;

.code

;***********************************
; Description: This procedure reads an integer input, then displays an error message if the input is not an integer.
; The procedure does not end until an integer is inputted.
; Recieves: This procedure recieves nothing.
; Returns: This procedure returns a valid integer in the eax register.
; Requires: This procedure requires the Irvine32 library.
;***********************************
GetValidInt PROC
    Read: ; this label reads the input
        call ReadInt ; reads an integer. note that ReadInt saves the input in the eax register
        jo BadInput ; if an overflow flag is thrown, such that the input of the ReadInt is not an integer, then the program
                    ; jumps to the BadInput label.
        ret ; this ends the call
    
    BadInput: ; this label acts accordingly if the input is not an integer
        call Crlf ; new line
        mov edx, OFFSET errorMessage ; prepares errorMessage to be displayed. note that strings are 'saved' in
                                     ; the edx register
        call WriteString ; calls errorMessage from edx
        jmp Read ; this jumps to the Read label
GetValidInt ENDP

;***********************************
; Description: This procedure sequentially asks the user to enter hours, minutes, and seconds then saves those user
; inputs in memory. Those values are then used to compute the total number of seconds. If a non-numeric input is
; entered, the procedure calls the GetValidInt procedure repeats it until a numeric input is entered. The procedure
; displays all of the user inputted information then displays the total number of minutes and seconds. Finally, the user
; is provided with the option to repeeat the program.
; Recieves: This procedure recieves nothing.
; Returns: This procedure has no returns.
; Requires: This procedure requires the GetValidInt procedure and the Irvine32 library.
;***********************************
TimeConv PROC ; need the information for this function

    GetHours: ; this label asks for a number hours then saves the input in memory
        mov edx, OFFSET hoursStr ; prepares the string hoursStr to be displayed
        call WriteString ; displays a string from the edx offset
        call GetValidInt ; this calls the GetValidInt procedure
        mov hours, eax ; save hours from eax
        jmp GetMinutes ; this jumps to the GetMinutes label

    GetMinutes: ; this label asks for a number of minutes then saves the input in memory
        mov edx, OFFSET minsStr ; prepares the string minsStr to be displayed
        call WriteString ; displays a string from the edx offset
        call GetValidInt ; this calls the GetValidInt procedure
        mov minutes, eax ; save minutes from eax
        jmp GetSeconds ; this jumps to the GetSeconds label

    GetSeconds: ; this label asks for a number of seconds then saves the input in memory
        mov edx, OFFSET secsStr ; prepares the string secsStr to be displayed
        call WriteString ; displays a string from the edx offset
        call GetValidInt ; this calls the GetValidInt procedure
        call Crlf ; new line
        mov seconds, eax ; save seconds from eax
        jmp DisplayTime ; this

    DisplayTime: ; this label displays the inputs for hours, minutes, and seconds 
        mov edx, OFFSET hoursDisp ; prepare the string hoursDisp to be displayed
        call WriteString ; displays a string from the edx offset
        mov eax, hours ; prepare the integer hours to be displayed
        call WriteDec ; displays an integer from eax
        mov al, '.' ; prepares the char '.' to be displayed
        call WriteChar ; displays a character from al
        call Crlf ; new line
            
        mov edx, OFFSET minsDisp ; prepares the string minsDisp to be displayed
        call WriteString ; displays a string from the edx offset
        mov eax, minutes ; prepares the integer minutes to be displayed
        call WriteDec ; displays an integer from eax
        mov al, '.' ; preparess the char '.' to be displayed
        call WriteChar ; displays a character from al
        call Crlf ; new line

        mov edx, OFFSET secsDisp ; prepares the string secsDisp to be displayed
        call WriteString ; displays a string from the edx offset
        mov eax, seconds ; prepares the integer seconds to be displayed
        call WriteDec ; displays an integer from eax
        mov al, '.' ; prepares the char '.' to be displayed
        call WriteChar ; displays a character from al
        call Crlf ; new line
        jmp CalculateTotals ; this jumps to the CalculateTotals label

    CalculateTotals: ; this label calculates the total time in minutes and seconds
        mov eax, hours ; add hours to register eax
        imul eax, 60 ; multiply hours by 60
        add eax, minutes ; add minutes to eax
        mov totalMinutes, eax ; this is the total minutes

        mov eax, totalMinutes ; add totalMinutes to register eax
        imul eax, 60 ; multiply total minutes by 60
        add eax, seconds ; add seconds to eax
        mov totalSeconds, eax ; this is the total seconds
        jmp DisplayTotals ; this jumps to the DisplayTotals label

    DisplayTotals: ; this label displays the total time in minutes and seconds
        call Crlf ; new line
        mov edx, OFFSET minutesTotalStr ; prepares the string minutesTotalStr to be displayed
        call WriteString ; displays a string from the edx offset
        mov eax, totalMinutes ; prepares the integer totalMinutes to be displayed
        call WriteDec ; displays an integer from eax
        mov edx, OFFSET minutesTotalStr2 ; prepares the string minutesTotalStr2 to be displayed
        call WriteString ; displays a string from the edx offset
        call Crlf ; new line

        mov edx, OFFSET secondsTotalStr ; prepares the string secondsTotalStr to be displayed
        call WriteString ; displays a string from the edx offset
        mov eax, totalSeconds ; prepares the string totalSeconds to be displayed
        call WriteDec ; displays a character from al
        mov edx, OFFSET secondsTotalStr2 ; prepares the string secondsTotalStr2 to be displayed
        call WriteString ; displays a string from the edx offset
        call Crlf ; new line
        jmp TryAgain ; this jumps to the TryAgain label

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
            jmp GetHours ; jump to the GetHours label
        .ELSEIF answer == 'n' || answer == 'N' ; if the answer is no
            ret ; end the program
        .ELSE ; if the answer is not yes or no
            call Crlf ; new line 
            mov edx, OFFSET errorMessage ; prepares the string errorMessage to be displayed
            call WriteString ; displays a string from the edx offset
            jmp TryAgain ; jump to the TryAgain label
        .ENDIF ; end the if statements

    ret
TimeConv ENDP

main PROC

    call TimeConv ; this starts the Time Conversion program

    INVOKE ExitProcess,0

main ENDP

END main