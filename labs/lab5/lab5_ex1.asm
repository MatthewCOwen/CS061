;=========================================================================
; Name: 	Matthew Owen
; Email: 	mowen011@ucr.edu
; 
; Lab: lab 5, ex 1
; Lab section: 	023
; TA: 			Nikhil
; 
;=========================================================================

.ORIG x3000					; Program begins here
;-------------------------------------------------------------------------
;Instructions
;-------------------------------------------------------------------------
AND R0, R0, #0		; set R0 to #1 (2^0)
ADD R0, R0, #1		; R0 will hold the numbers that will be entered into
					; the array

LD 	R6, ARRAY_PTR	; R6 will be the array ptr

AND R2, R2, #0		; R2 will be the loop counter
ADD R2, R2, #10		

WHILE_LOOP		
	STR R0, R6, #0
	
	ADD R0, R0, R0

	ADD R6, R6, #1
	ADD R2, R2, #-1
	BRp WHILE_LOOP

LD 	R6, ARRAY_PTR

PRINT_LOOP
	LDR	R1, R6, #0				; R1 is used to pull values from the array
								; The spec sheet says to use R2, but I had
								;  already used R2 during Assignment 3
	JSR SUB_PRINT_BIN_X3200
	
	ADD R6, R6, #1

	LEA	R0, ARRAY_LEN
	LD	R3,	ARRAY_LEN
	ADD R3, R3, #-1
	STR R3, R0, #0
	
	BRp PRINT_LOOP

HALT
;-------------------------------------------------------------------------
;Local Data
;-------------------------------------------------------------------------
Value_addr			.FILL xAB00	; The address where value to be 
								; displayed is stored

ARRAY_PTR 			.FILL x4000
ARRAY_LEN			.FILL #10

SUB_PRINT_BIN_X3200	.FILL x3200

;-------------------------------------------------------------------------
; Subroutine	: PRINT_BIN
; Parameter (R1): A 16-bit value
; Postcondition : The subroutine has printed the full 16-bit
;				  to the console
;-------------------------------------------------------------------------
.ORIG x3200

ST	R0, BACKUP_R0_3200
ST	R2, BACKUP_R2_3200
ST 	R3, BACKUP_R3_3200
ST	R4, BACKUP_R4_3200
ST	R5, BACKUP_R5_3200
ST	R7, BACKUP_R7_3200

LD	R2, SET_MSB				; load a 1 into the MSB

AND	R4, R4, #0				; R4 will be the inner loop counter

AND	R5, R5, #0				; R5 will be the outer loop counter
ADD R5, R5, #4				; load a 4 into R5

LD	R0, CHAR_B
OUT

OUTER_LOOP
	ADD R4, R4, #4			; load a 4 into R4
	INNER_LOOP
		LD	R0, ZERO
		AND R3, R1, R2		; if zero: print('0')	else: print('1')
		BRz PRINT_CHAR
			ADD R0, R0, #1	; '0' + 1 -> '1'
			
		PRINT_CHAR
			OUT
	
		ADD R1, R1, R1
		ADD R4, R4, #-1
		BRnp INNER_LOOP
		
	LD	R0, SPACE
	ADD R5, R5, #-1
	BRz	END_LOOPS			; loop will terminate when R5 == 0
		OUT
	
	BRnzp OUTER_LOOP
END_LOOPS

LD	R0, NEWLINE
OUT

LD	R0, BACKUP_R0_3200
LD	R2, BACKUP_R2_3200
LD 	R3, BACKUP_R3_3200
LD	R4, BACKUP_R4_3200
LD	R5, BACKUP_R5_3200
LD	R7, BACKUP_R7_3200

RET
;-------------------------------------------------------------------------
; Subroutine: PRINT_BIN DATA
;-------------------------------------------------------------------------
ZERO				.FILL '0'
NEWLINE				.FILL '\n'
SPACE 				.FILL ' '
CHAR_B				.FILL 'b'
SET_MSB				.FILL x8000	; set bit-15 to 1

BACKUP_R0_3200		.BLKW #1
BACKUP_R2_3200		.BLKW #1
BACKUP_R3_3200		.BLKW #1
BACKUP_R4_3200		.BLKW #1
BACKUP_R5_3200		.BLKW #1
BACKUP_R7_3200		.BLKW #1

;-------------------------------------------------------------------------
; REMOTE DATA
;-------------------------------------------------------------------------
.ORIG x4000
ARRAY 		.BLKW #10

.ORIG xAB00				; Remote data
Value .FILL xABCD		; <----!!!NUMBER TO BE DISPLAYED AS BINARY!!! 
						; Note: label is redundant.
;-------------------------------------------------------------------------	
;END of PROGRAM
;-------------------------------------------------------------------------
.END
