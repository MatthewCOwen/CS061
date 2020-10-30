;=========================================================================
; Name: 	Matthew Owen
; Email: 	mowen011@ucr.edu
; 
; Lab: lab 5, ex 3
; Lab section: 	023
; TA: 			Nikhil
; 
;=========================================================================

.ORIG x3000					; Program begins here
;-------------------------------------------------------------------------
;Instructions
;-------------------------------------------------------------------------
JSR	SUB_READ_BSTRING_x3200
LD	R0, NEWLINE_CHAR
OUT
HALT
;-------------------------------------------------------------------------
;Local Data
;-------------------------------------------------------------------------

SUB_READ_BSTRING_x3200		.FILL	x3200

NEWLINE_CHAR				.FILL	'\n'
;-------------------------------------------------------------------------
; Subroutine	: READ_BSTRING
; Parameter		: None
; Postcondition	: R2 contains a valid 16-bit value
; Return value	: R2
;-------------------------------------------------------------------------
.ORIG x3200

ST	R0, BACKUP_R0_3200
ST	R1, BACKUP_R1_3200
ST	R3, BACKUP_R3_3200
ST	R4, BACKUP_R4_3200
ST	R7, BACKUP_R7_3200

LEA R1, VALID_CHARS_ARRAY
AND R2, R2, #0					;set R2 to 0

AND R3, R3, #0					;R3 will be the loop counter
ADD R3, R3, #-16				;set R3 to #-16

JSR	SUB_READ_VALID_CHAR_x3400	;'b' is the only acceptable character
OUT								;print 'b'

ADD R1, R1, #2					;'1', '0', and ' ' are the only valid 
								;characters now

LD	R4, ASCII_2_DEC_OFFSET		;set R4 to #-48

DO_WHILE_BSTRING
	ST	R2, BACKUP_R2_TEMP
	LD	R2, SUB_READ_VALID_CHAR_x3400
	JSRR R2
	LD	R2, BACKUP_R2_TEMP
	OUT							;print most recently entered character
	ADD R0, R0, R4				;subtract #48 from R0
								;if R0 is '0' or '1' the result will be
								;	#0 or #1
								;if R0 is ' ' the result will be negative
	BRn DO_WHILE_BSTRING		;	therefore skip it
	
	ADD R2, R2, R2				;slliiiiddee to the left!
	ADD R2, R2, R0				;add result to R2
	
	ADD R3, R3, #1				;increment loop counter
	BRn DO_WHILE_BSTRING				

LD	R0, BACKUP_R0_3200
LD	R1, BACKUP_R1_3200
LD	R3, BACKUP_R3_3200
LD	R4, BACKUP_R4_3200
LD	R7, BACKUP_R7_3200
RET
;-------------------------------------------------------------------------
; Subroutine: READ_BSTRING DATA
;-------------------------------------------------------------------------
BACKUP_R0_3200				.BLKW 		#1
BACKUP_R1_3200				.BLKW 		#1
BACKUP_R3_3200				.BLKW 		#1
BACKUP_R4_3200				.BLKW 		#1
BACKUP_R7_3200				.BLKW 		#1

BACKUP_R2_TEMP				.BLKW		#1

ASCII_2_DEC_OFFSET			.FILL		#-48


VALID_CHARS_ARRAY			.FILL		'b'
							.FILL 		#-1
							.FILL		'1'
							.FILL		'0'
							.FILL		' '
							.FILL		#-1

SUB_READ_VALID_CHAR_x3400	.FILL 		x3400
							
;-------------------------------------------------------------------------
; Subroutine	: READ_VALID_CHAR
; Parameter (R1): An address to an array of acceptable characters
; Postcondition : R0 contains the value of an acceptable character
; Return value	: R0
;-------------------------------------------------------------------------
.ORIG x3400

ST	R1, BACKUP_R1_3400
ST	R2, BACKUP_R2_3400
ST	R3, BACKUP_R3_3400
ST	R4, BACKUP_R4_3400
ST	R7, BACKUP_R7_3400

DO_WHILE_VALID_CHAR
	GETC
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
		LEA R0, ERROR_MESSAGE
		PUTS
		
		LD	R1, BACKUP_R1_3400
		BRnzp DO_WHILE_VALID_CHAR	

GOOD_CHAR
	LD	R1, BACKUP_R1_3400
	LD	R2, BACKUP_R2_3400
	LD	R3, BACKUP_R3_3400
	LD	R4, BACKUP_R4_3400
	LD	R7, BACKUP_R7_3400
	RET
;-------------------------------------------------------------------------
; Subroutine	: READ_VALID_CHAR DATA
;-------------------------------------------------------------------------
BACKUP_R1_3400		.BLKW #1
BACKUP_R2_3400		.BLKW #1
BACKUP_R3_3400		.BLKW #1
BACKUP_R4_3400		.BLKW #1
BACKUP_R7_3400		.BLKW #1

ERROR_MESSAGE		.STRINGZ	"\nInvalid input. Try again.\n"
;-------------------------------------------------------------------------	
;END of PROGRAM
;-------------------------------------------------------------------------
.END
