;=========================================================================
; Name: 	Matthew Owen
; Email: 	mowen011@ucr.edu
; 
; Lab: lab 4, ex 2
; Lab section: 	023
; TA: 			Nikhil
; 
;=========================================================================
.ORIG x3000

;-------------------------------------------------------------------------
; Instructions
;-------------------------------------------------------------------------
AND R0, R0, #0		; set R0 to #0
					; R0 will hold the numbers that will be entered into
					; the array

LD 	R1, ARRAY_PTR	; R1 will be the array ptr

AND R2, R2, #0		; R2 will be the loop counter
ADD R2, R2, #10		

WHILE_LOOP		
	STR R0, R1, #0
	
	ADD R0, R0, #1
	ADD R1, R1, #1
	ADD R2, R2, #-1
	BRp WHILE_LOOP


LD 	R1, ARRAY_PTR	; R1 will be the array ptr

AND R2, R2, #0		; R2 will be the loop counter
ADD R2, R2, #10	

LD	R3, ASCII_ZERO

PRINT_LOOP
	LDR R0, R1, #0
	ADD R0, R0, R3
	OUT
	ADD R1, R1, #1
	ADD R2, R2, #-1
	BRp PRINT_LOOP

LD 	R0, NEWLINE
OUT
HALT
;-------------------------------------------------------------------------
; LOCAL DATA
;-------------------------------------------------------------------------
ARRAY_PTR 	.FILL x4000

ASCII_ZERO 	.FILL '0'
NEWLINE		.FILL '\n'

;-------------------------------------------------------------------------
; REMOTE DATA
;-------------------------------------------------------------------------
.ORIG x4000

ARRAY 		.BLKW #10
;-------------------------------------------------------------------------	
;END of PROGRAM
;-------------------------------------------------------------------------
.END
