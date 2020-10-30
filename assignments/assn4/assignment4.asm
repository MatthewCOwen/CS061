;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: 	Matthew Owen
; Email: 	mowen011@ucr.edu
; 
; Assignment name: Assignment 4
; Lab section: 	023
; TA: 			Nikhil
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=================================================================================
;THE BINARY REPRESENTATION OF THE USER-ENTERED DECIMAL NUMBER MUST BE STORED IN R5
;=================================================================================
.ORIG x3000		

;-------------------------------------------------------------------------------
;Instructions
;-------------------------------------------------------------------------------

THE_BEGINNING
; output intro prompt
LD	R0, introPromptPtr
PUTS					
; Set up flags, counters, accumulators as needed
LEA	R1, VALID_CHARS

AND	R5, R5, #0

AND R0, R0, #0
ADD	R0, R0, #5

ST	R0, NUM_NUMS	; wasn't resetting this value properly

; Get first character, test for '\n', '+', '-', digit/non-digit 	
GETC
OUT

LD	R2, SUB_VALIDATE_CHAR
JSRR R2

ADD	R0, R0, #0
;is it < '0'? if so, it is not a digit - o/p error message, start over
;is it > '9'? if so, it is not a digit - o/p error message, start over
BRn PRINT_ERR_MSG

NOT	R3, R0
ADD	R3, R3, #1	;form -R0

;is very first character = '\n'? if so, just quit (no message)!
LD	R4, NEWLINE
ADD R6, R4, R3
BRz	FINISHED

;is very first character = '-'? if so, set neg flag, go get digits
LDR	R4, R1, #1	;I could make another label to hold '-' or use LDR in 
				;the way that you said we'd never use it.
ADD R6, R4, R3
BRn SKIP_FIRST_ENTRY
BRp GET_DIGITS

AND R6, R6, #0
ADD R6, R6, #1
ST	R6, NEG_FLAG

GET_DIGITS					;housekeeping before loop
	ADD R1, R1, #2			;VALID_CHARS[0] will now be '\n'
	LD	R3, ASCII_OFFSET

GET_DIGITS_LOOP
; if none of the above, first character is first numeric digit - deal with it!			
; Now get (remaining) digits (max 5) from user and build up number in accumulator
	GETC
	OUT
	
	LD	R2, SUB_VALIDATE_CHAR
	JSRR R2
	ADD	R0, R0, #0	;not sure if the LD instruction affects the NZP registers
		
	BRn		PRINT_ERR_MSG
	BRzp	SKIP_SKIP_BLOCK
	
	SKIP_FIRST_ENTRY
		ADD R1, R1, #2	;VALID_CHARS[0] will now be '\n'
		LD	R3, ASCII_OFFSET
	SKIP_SKIP_BLOCK
	
	ADD R0, R0, R3
	BRn	FINISHED		;'\n' < '0' so if R3 is negative then it has to be '\n'
	
	LD	R2, SUB_MULT_BY_TEN
	JSRR R2
	
	LD	R6, NEG_FLAG
	ADD	R6, R6, #0
	BRz	ADD_NEW_NUM	;if NEG_FLAG = 1 -> form negative of R0
		NOT R0, R0
		ADD R0, R0, #1
	ADD_NEW_NUM
		ADD R5, R5, R0
	
	LD	R6, NUM_NUMS
	ADD	R6, R6, #-1
	ST	R6, NUM_NUMS
	BRp GET_DIGITS_LOOP	
	BRz	FINISHED
	
PRINT_ERR_MSG
	LD	R0, NEWLINE
	OUT
	
	LD	R0, errorMessagePtr
	PUTS
	BRnzp THE_BEGINNING
	
FINISHED
	;remember to end with a newline!
	LD	R0, NEWLINE
	OUT

HALT
;-------------------------------------------------------------------------------	
; Program Data
;-------------------------------------------------------------------------------
SUB_MULT_BY_TEN		.FILL		x3200
SUB_VALIDATE_CHAR	.FILL		x3400

introPromptPtr		.FILL		x3A00
errorMessagePtr		.FILL	 	x3B00

VALID_CHARS			.STRINGZ	"+-\n0123456789"
ASCII_OFFSET		.FILL		#-48

NEG_FLAG			.FILL		0	;0 -> false		1 -> true
NUM_NUMS			.BLKW		#1	;could not resist naming this variable NUM_NUMS
NEWLINE				.FILL		x000A

;-------------------------------------------------------------------------------
; Subroutine	: MULT_BY_TEN
; Parameter (R5): R5 contains the value to be multiplied by 10
; Postcondition : R5 is 10x the value that it started as
; Return value	: R5
;-------------------------------------------------------------------------------
.ORIG x3200

ST	R0, BACKUP_R0_3200
ST	R7, BACKUP_R7_3200

	AND	R0, R0, #0
	ADD R0, R0, R5
	
	;3 left shifts is equivalent to 8x
	ADD R5, R5, R5
	ADD R5, R5, R5
	ADD R5, R5, R5
	
	;add original value twice to get to 10x
	ADD	R5, R5, R0
	ADD R5, R5, R0

LD	R0, BACKUP_R0_3200
LD	R7, BACKUP_R7_3200
RET
;-------------------------------------------------------------------------------
; Subroutine	: MULT_BY_TEN DATA
;-------------------------------------------------------------------------------
BACKUP_R0_3200		.BLKW		#1
BACKUP_R7_3200		.BLKW		#1

;-------------------------------------------------------------------------------
; Subroutine			: VALIDATE_CHAR
; Parameter (R0), (R1)	: An address to an array of acceptable characters
; Postcondition 		: R0 retains its value if it contains a valid character
;						: otherwise it contains a #-1
; Return value			: R0
;-------------------------------------------------------------------------------
.ORIG x3400

ST	R1, BACKUP_R1_3400
ST	R2, BACKUP_R2_3400
ST	R3, BACKUP_R3_3400
ST	R4, BACKUP_R4_3400
ST	R7, BACKUP_R7_3400

DO_WHILE_VALID_CHAR
	NOT R2, R0	
	ADD R2, R2, #1				;R2 = -1 * R0
	
	CHECK_LOOP
		LDR R3, R1, #0			
		BRn BAD_CHAR	
		
		ADD R4, R3, R2			
		BRz GOOD_CHAR

		ADD R1, R1, #1
		BRnzp CHECK_LOOP
		
	BAD_CHAR
		AND	R0, R0, #0
		ADD	R0, R0, #-1
		
GOOD_CHAR
	LD	R1, BACKUP_R1_3400
	LD	R2, BACKUP_R2_3400
	LD	R3, BACKUP_R3_3400
	LD	R4, BACKUP_R4_3400
	LD	R7, BACKUP_R7_3400
	RET
;-------------------------------------------------------------------------------
; Subroutine	: VALIDATE_CHAR DATA
;-------------------------------------------------------------------------------
BACKUP_R1_3400		.BLKW #1
BACKUP_R2_3400		.BLKW #1
BACKUP_R3_3400		.BLKW #1
BACKUP_R4_3400		.BLKW #1
BACKUP_R7_3400		.BLKW #1

;-------------------------------------------------------------------------------
; Remote data
;-------------------------------------------------------------------------------

.ORIG x3A00			; intro prompt
.STRINGZ	"Input a positive or negative decimal number (max 5 digits), followed by ENTER\n"
					
.ORIG x3B00			; error message
.STRINGZ	"ERROR: invalid input\n"

;-------------------------------------------------------------------------------
; END of PROGRAM
;-------------------------------------------------------------------------------
.END

;-------------------------------------------------------------------------------
; PURPOSE of PROGRAM
;-------------------------------------------------------------------------------
; Convert a sequence of up to 5 user-entered ascii numeric digits into a 16-bit two's complement binary representation of the number.
; if the input sequence is less than 5 digits, it will be user-terminated with a newline (ENTER).
; Otherwise, the program will emit its own newline after 5 input digits.
; The program must also output a final newline.
; Input validation is performed on the individual characters as they are input, but not on the magnitude of the number.
