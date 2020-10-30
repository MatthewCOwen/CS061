;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: 	Matthew Owen
; Email: 	mowen011@ucr.edu
; 
; Assignment name: Assignment 3
; Lab section: 	023
; TA:			Nikhil
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=========================================================================

.ORIG x3000				; Program begins here
;-------------------------------------------------------------------------
;Instructions
;-------------------------------------------------------------------------
LD R6, Value_addr			; R6 <-- pointer to value to be displayed as binary
LDR R1, R6, #0				; R1 <-- value to be displayed as binary 
;-------------------------------------------------------------------------
;INSERT CODE STARTING FROM HERE
;-------------------------------------------------------------------------
LD	R2, SET_MSB				; load a 1 into the MSB

AND	R4, R4, #0				; R4 will be the inner loop counter

AND	R5, R5, #0				; R5 will be the outer loop counter
ADD R5, R5, #4				; load a 4 into R5

OUTER_LOOP
	ADD R4, R4, #4			; load a 4 into R4
	INNER_LOOP
		LD	R0, ZERO
		AND R3, R1, R2	
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
HALT
;-------------------------------------------------------------------------
;Data
;-------------------------------------------------------------------------
Value_addr	.FILL xAB00	; The address where value to be displayed is stored
ZERO		.FILL '0'
NEWLINE		.FILL '\n'
SPACE 		.FILL ' '
SET_MSB		.FILL x8000	; set bit-15 to 1

.ORIG xAB00				; Remote data
Value .FILL xABCD		; <----!!!NUMBER TO BE DISPLAYED AS BINARY!!! 
						; Note: label is redundant.
;---------------	
;END of PROGRAM
;---------------	
.END
