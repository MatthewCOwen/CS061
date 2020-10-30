;=========================================================================
; Name: 	Matthew Owen
; Email: 	mowen011@ucr.edu
; 
; Lab: lab 5, ex 2
; Lab section: 	023
; TA: 			Nikhil
; 
;=========================================================================

.ORIG x3000					; Program begins here
;-------------------------------------------------------------------------
;Instructions
;-------------------------------------------------------------------------
JSR	SUB_READ_BSTRING_x3200
HALT
;-------------------------------------------------------------------------
;Local Data
;-------------------------------------------------------------------------

SUB_READ_BSTRING_x3200		.FILL	x3200


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

AND R2, R2, #0					;set R2 to 0

AND R3, R3, #0					;R3 will be the loop counter
ADD R3, R3, #-16				;set R3 to #-16

GETC
OUT								;print 'b'

ADD R1, R1, #2					;'1', '0', and ' ' are the only valid 
								;characters now

LD	R4, ASCII_2_DEC_OFFSET		;set R4 to #-48

DO_WHILE_BSTRING
	GETC
	OUT							;print most recently entered character
	ADD R0, R0, R4
	
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

ASCII_2_DEC_OFFSET			.FILL		#-48
;-------------------------------------------------------------------------	
;END of PROGRAM
;-------------------------------------------------------------------------
.END
