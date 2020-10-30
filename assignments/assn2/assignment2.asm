;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: 	Matthew Owen
; Email: 	mowen011@ucr.edu
; 
; Assignment name: Assignment 2
; Lab section: 	023
; TA: 			Nikhil
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=========================================================================

.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------

;----------------------------------------------
;output prompt
;----------------------------------------------	
LEA R0, intro			; get starting address of prompt string
PUTS			    	; Invokes BIOS routine to output string

;-------------------------------
;INSERT YOUR CODE here
;--------------------------------

LEA	R4, OUTPUT_STR

GETC
OUT
STR	R0, R4, #0
LD	R1, INT_OFFSET
ADD	R0, R0, R1

AND R1, R1, #0
ADD R1, R1, R0

LD	R0, newline
OUT

GETC
OUT
STR R0, R4, #4
LD	R2, INT_OFFSET
ADD	R0, R0, R2

AND R2, R2, #0
ADD R2, R2, R0

LD	R0, newline
OUT

NOT	R2, R2
ADD	R2, R2, 1

ADD R3, R1, R2
BRn	LESS_THAN_ZERO
	
	LD	R1, INT_OFFSET
	ADD R1, R1, #-1
	NOT R1, R1
	
	ADD R3, R3, R1
	
	STR	R3, R4, #8
	BRnzp PRINT_OUTPUT
	
LESS_THAN_ZERO

	LD 	R0, SUB_CHAR
	STR R0, R4, #8
	
	ADD R3, R3, #-1
	NOT	R3, R3

	LD	R1, INT_OFFSET
	ADD R1, R1, #-1
	NOT R1, R1
	
	ADD R3, R3, R1
	
	STR R3, R4, #9
	
PRINT_OUTPUT

	LEA R0, OUTPUT_STR
	PUTS

HALT				; Stop execution of program
;------	
;Data
;------
; String to prompt user. Note: already includes terminating newline!
intro 		.STRINGZ	"ENTER two numbers (i.e '0'....'9')\n"
newline 	.FILL 		'\n'

INT_OFFSET 	.FILL 		#-48
OUTPUT_STR	.STRINGZ	"  -   =   \n"
SUB_CHAR	.FILL		'-'

;---------------	
;END of PROGRAM
;---------------	
.END

