;=========================================================================
; Name: 	Matthew Owen
; Email: 	mowen011@ucr.edu
; 
; Lab: lab 6, ex 1
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
LEA R2, SUB_GET_STRING

JSRR R2
ADD R0, R1, R0
PUTS

HALT
;-------------------------------------------------------------------------
;Local Data
;-------------------------------------------------------------------------
STRING			.BLKW	#100

SUB_GET_STRING	.FILL	x3200

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
; Subroutine: SUB_GET_STRING DATA
;-------------------------------------------------------------------------
BACKUP_R0_3200	.BLKW		#1
BACKUP_R1_3200	.BLKW		#1
BACKUP_R2_3200	.BLKW		#1
BACKUP_R3_3200	.BLKW		#1
BACKUP_R5_3200	.BLKW		#1
BACKUP_R7_3200	.BLKW		#1

PROMPT			.STRINGz	"\nEnter a string to be checked\n"
;-------------------------------------------------------------------------	
;END of PROGRAM
;-------------------------------------------------------------------------
.END
