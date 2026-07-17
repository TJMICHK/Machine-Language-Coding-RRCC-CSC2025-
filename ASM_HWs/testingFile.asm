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

    val1   QWORD 20403004362047A1h
    val2   QWORD 055210304A2630B2h
    result QWORD 0

    ;*************************************
    ; THE DATA BELOW ARE INPUT VARIABLES AND ARRAYS. THIS DATA IS USED FOR
    ; HOLDING USER INPUTTED DATA.
    ;*************************************




.code

MainProgram PROC

   mov  ecx, 8               ; loop counter (changed to ecx because loop uses ecx and not cx)

                             ; consider that val1 and val2 are 64-bit while esi and edi are 32-bit
                             ; thus, the full values of val1 and val2 CANNOT be stored in esi or edi

   mov  esi, OFFSET val1     ; set index to start (changed to OFFSET because edi is a pointer)
   mov  edi, OFFSET val2     ; set index to start (changed to OFFSET because edi is a pointer)

   clc                       ; clear Carry flag

top:
   mov  al, BYTE PTR[esi]     ; get first number
   sbb  al, BYTE PTR[edi]     ; subtract second
   mov  BYTE PTR[esi], al     ; store the result
   inc  esi                   ; increase esi by 1 (changed to inc instead of dec because OFFSET starts
                              ; at the start and not the end.)
   inc  edi                   ; increase edi by 1 (changed to inc instead of dec because OFFSET starts
                              ; at the start and not the end.)
   loop top                   ; loop the label top

MainProgram ENDP

main PROC

    call MainProgram ; run the MainProgram procedure.

    INVOKE ExitProcess,0

main ENDP

END main
