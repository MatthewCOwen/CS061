;=========================================================================
; Name: 	Matthew Owen
; Email: 	mowen011@ucr.edu
; 
; Lab: lab 7, ex 1
; Lab section: 	023
; TA: 			Nikhil
; 
;=========================================================================
.ORIG x3000	
;-------------------------------------------------------------------------
;Instructions
;-------------------------------------------------------------------------
AND	R0, R0, #0
ADD R0, R0, x000A
OUT

LD	R1, VALUE
LD	R2, SUB_DIV_BY_TEN
JSRR R2

HALT
;-------------------------------------------------------------------------
;Local Data
;-------------------------------------------------------------------------
VALUE			.FILL	#-32767

SUB_DIV_BY_TEN	.FILL	x3200

;-------------------------------------------------------------------------
; Subroutine	: DIV_BY_TEN
; Parameter		: R1 contains a positive 16-bit value
; Postcondition	: R1 is no longer divisible by 10
; Return value	: R1
;-------------------------------------------------------------------------
.ORIG x3200

ST	R0, BACKUP_R0_3200
ST	R1, BACKUP_R1_3200
ST	R2, BACKUP_R2_3200
ST	R3, BACKUP_R3_3200
ST	R4, BACKUP_R4_3200
ST	R5, BACKUP_R5_3200
ST	R7, BACKUP_R7_3200

LD	R0, NEG_TEST
AND	R0, R1, R0
BRzp ALREADY_POSITIVE

ADD R1, R1, #-1
NOT	R1, R1

LD	R0, NEG_SIGN
OUT

ALREADY_POSITIVE

LEA	R2, FACTORS

AND R4, R4, #0

SUB_LOOP
	LDR R3, R2, #0
	BRz	BREAK_LOOP
	
	ADD R1, R1, R3
	BRn TOO_MUCH
	
	ADD R4, R4, #1
	BRp SUB_LOOP
	
	TOO_MUCH
		ADD R3, R3, #-1
		NOT R3, R3
		
		ADD R1, R1, R3

		LD 	R0, DEC_TO_ASCII
		ADD R0, R0, R4
		OUT
		
		ADD R2, R2, #1
		
		AND R4, R4, #0
		BRnzp SUB_LOOP
		
BREAK_LOOP

LD	R0, BACKUP_R0_3200
LD	R1, BACKUP_R1_3200
LD	R2, BACKUP_R2_3200
LD	R3, BACKUP_R3_3200
LD	R4, BACKUP_R4_3200
LD	R5, BACKUP_R5_3200
LD	R7, BACKUP_R7_3200

RET
;-------------------------------------------------------------------------
;DIV_BY_TEN Data
;-------------------------------------------------------------------------
BACKUP_R0_3200	.BLKW	#1
BACKUP_R1_3200	.BLKW	#1
BACKUP_R2_3200	.BLKW	#1
BACKUP_R3_3200	.BLKW	#1
BACKUP_R4_3200	.BLKW	#1
BACKUP_R5_3200	.BLKW	#1
BACKUP_R7_3200	.BLKW	#1

NEG_TEST		.FILL	x8000
NEG_SIGN		.FILL	'-'

DEC_TO_ASCII	.FILL	x0030
FACTORS			.FILL	#-10000
				.FILL	#-1000
				.FILL	#-100
				.FILL	#-10
				.FILL	#-1
