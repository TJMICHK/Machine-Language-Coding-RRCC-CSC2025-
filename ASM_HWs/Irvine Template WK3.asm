; **********************************************************************;
; Program Name:
; Program Description:
; Author:
; Creation Date:
; Revisions:
; Date Last Modified:
;***********************************************************************;

INCLUDE C:\Irvine\Irvine32.inc
INCLUDELIB C:\Irvine\Irvine32.lib

.data
    hoursStr BYTE "Enter the number of hours:  "
    minStr BYTE "Enter the number of minutes:  "
    secStr BYTE "Enter the number of seconds:  "

    hours DWORD ?
    minutes DWORD ?
    seconds DWORD ?


; **********************************************************************;
; Functional description of the main program
;	Inputs
;	Outputs
;	Registers used and associated purpose of each
;	Memory locations use and associated purpose of each
;	Functional details
; There should be a similar block prior to procedures, functions, or
;	otherwise major sections of code
; **********************************************************************;

.code
main PROC

    TimeConv PROC ; need the information for this function
        mov edx, OFFSET hoursStr
        call WriteString ; calls from edx
        call readInt ; saves to eax
        mov hours, eax ; save hours from eax
    TimeConv ENDP

    INVOKE ExitProcess,0

main ENDP

END main
