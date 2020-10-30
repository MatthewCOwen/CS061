;=========================================================================
; Name: 	Matthew Owen
; Email: 	mowen011@ucr.edu
; 
; Lab: lab 6, ex 3
; Lab section: 	023
; TA: 			Nikhil
; 
;=========================================================================

.ORIG x3000					; Program begins here
;-------------------------------------------------------------------------
;Instructions
;-------------------------------------------------------------------------
AND R0, R0, #0
LEA R1, STRING
LD	R2, SUB_GET_STRING

JSRR R2
ADD R0, R1, R0
PUTS

LD	R0, NEWLINE
OUT

LD	R2, SUB_TO_UPPER
JSRR R2
LEA R0, STRING
PUTS

LD	R2, SUB_IS_A_PALINDROME
JSRR R2

HALT
;-------------------------------------------------------------------------
;Local Data
;-------------------------------------------------------------------------
STRING				.BLKW	#100

NEWLINE				.FILL	x000A

SUB_GET_STRING		.FILL	x3200
SUB_IS_A_PALINDROME	.FILL	x3400
SUB_TO_UPPER		.FILL	x3600

;-------------------------------------------------------------------------
; Subroutine	:	SUB_GET_STRING
; Parameter		:	R1 - the starting address of the character array
; Postcondition	:	The subroutine has prompted the user to input a string,
;						terminated by the [ENTER] key (the "sentinel"), and
;						has stored the recieved characters in an array of
;						characters starting at (R1). The array is 
;						null-terminated. The sentinel is not stored.
; Return value	:	R5 - 	the number of *non-sentinel" characters read 
;							from the user.
;					R1 -	still contains the address of the character
;							array.
;-------------------------------------------------------------------------
.ORIG x3200

ST	R0, BACKUP_R0_3200
ST	R1, BACKUP_R1_3200
ST	R2, BACKUP_R2_3200
ST	R3, BACKUP_R3_3200
ST	R7, BACKUP_R7_3200

LEA R0, PROMPT
PUTS

LDR R2, R0, #0	;'\n' is at the front of the prompt, so I'll grab it
NOT	R2, R2
ADD R2, R2, #1	;form negative of x0A

AND R5, R5, #0

DO_WHILE_NOT_SENTINEL
		GETC
		OUT
		
		ADD R3, R2, R0			;if entered char == '\n' -> end Subroutine
		BRz	SENTINEL_REACHED
		
		STR R0, R1, #0
		ADD R1, R1, #1
		ADD R5, R5, #1
		BRnzp DO_WHILE_NOT_SENTINEL
		
SENTINEL_REACHED

LD	R0, BACKUP_R0_3200
LD	R1, BACKUP_R1_3200
LD	R2, BACKUP_R2_3200
LD	R3, BACKUP_R3_3200
LD	R7, BACKUP_R7_3200
RET
;-------------------------------------------------------------------------
; SUB_GET_STRING DATA
;-------------------------------------------------------------------------
BACKUP_R0_3200	.BLKW		#1
BACKUP_R1_3200	.BLKW		#1
BACKUP_R2_3200	.BLKW		#1
BACKUP_R3_3200	.BLKW		#1
BACKUP_R7_3200	.BLKW		#1

PROMPT			.STRINGz	"\nEnter a string to be checked\n"

;-------------------------------------------------------------------------
; Subroutine	:	SUB_IS_A_PALINDROME
; Parameters	:	R1 - the starting address of the character array
;					R5 - the number of characters in the array
; Postcondition	:	The subroutine has determined whether the string at
;						at (R1) is a palindrome or not
; Return value	:	R4 - {1 if palindrome, 0 if not}
;					R1 - still contains the address of the character
;							array.
;-------------------------------------------------------------------------
.ORIG x3400

ST	R0, BACKUP_R0_3400
ST	R1, BACKUP_R1_3400
ST	R2, BACKUP_R2_3400
ST	R3, BACKUP_R3_3400
ST	R5, BACKUP_R5_3400
ST	R6, BACKUP_R6_3400
ST	R7, BACKUP_R7_3400

AND R0, R0, #0
ADD R0, R1, R5
ADD R0, R0, #-1 ; R0 will point to the end of the array

CHECK_PALINDROME_LOOP
	AND R4, R4, #0		; assume this iteration will fail

	LDR	R2, R0, #0	
	LDR R3, R1, #0
	
	NOT R3, R3
	ADD R3, R3, #1		; negate the number

	ADD R6, R2, R3	
	BRnp FINISHED_CHECKING
	
	ADD R1, R1, #1		; move forward 1 character
	ADD R0, R0, #-1		; move back 1 character
	
	ADD R4, R4, #1		; assume this is the last iteration and the
						;	string is a palindrome
	
	ADD R5, R5, #-1		; the string will redundantly move past the 
						;	center point, but it won't be wrong
						
	BRnp CHECK_PALINDROME_LOOP

FINISHED_CHECKING

LD	R0, BACKUP_R0_3400
LD	R1, BACKUP_R1_3400
LD	R2, BACKUP_R2_3400
LD	R3, BACKUP_R3_3400
LD	R5, BACKUP_R5_3400
LD	R6, BACKUP_R6_3400
LD	R7, BACKUP_R7_3400

RET
;-------------------------------------------------------------------------
; SUB_IS_A_PALINDROME DATA
;-------------------------------------------------------------------------
BACKUP_R0_3400	.BLKW	#1
BACKUP_R1_3400	.BLKW	#1
BACKUP_R2_3400	.BLKW	#1
BACKUP_R3_3400	.BLKW	#1
BACKUP_R5_3400	.BLKW	#1
BACKUP_R6_3400	.BLKW	#1
BACKUP_R7_3400	.BLKW	#1

;-------------------------------------------------------------------------
; Subroutine	:	SUB_TO_UPPER
; Parameters	:	R1 - the starting address of a null-terminated
;							character array
; Postcondition	:	The subroutine has finished converting all
;						characters to uppercase
; Return value	:	No return but,
;					R1 - still contains the address of the character
;							array.
;-------------------------------------------------------------------------
.ORIG x3600
ST	R0, BACKUP_R0_3600
ST	R1, BACKUP_R1_3600
ST	R2, BACKUP_R2_3600
ST	R7, BACKUP_R7_3600

LD	R0, MASK

WHILE_NOT_FINISHED
	LDR R2, R1, #0		;If the last value is 0 (null terminated)
	BRz	ALL_UPPERCASE	;exit loop
	
	AND	R2, R2, R0		;turn off bit 5 (subtract 32)
	STR	R2, R1, #0		;
	
	ADD R1, R1, #1
	BRnzp WHILE_NOT_FINISHED

ALL_UPPERCASE

LD	R0, BACKUP_R0_3600
LD	R1, BACKUP_R1_3600
LD	R2, BACKUP_R2_3600
LD	R7, BACKUP_R7_3600

RET
;-------------------------------------------------------------------------
; SUB_IS_A_PALINDROME DATA
;-------------------------------------------------------------------------
BACKUP_R0_3600	.BLKW	#1
BACKUP_R1_3600	.BLKW	#1
BACKUP_R2_3600	.BLKW	#1
BACKUP_R7_3600	.BLKW	#1

MASK			.FILL	x005F
;-------------------------------------------------------------------------	
;END of PROGRAM
;-------------------------------------------------------------------------
.END
