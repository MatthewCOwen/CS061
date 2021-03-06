;=================================================
; Name: 
; Email:  
; 
; Lab: lab 2, ex 4
; Lab section: 023
; TA: Nikhil
; 
;=================================================
.ORIG x3000
;-------------------------------------------------
;Instructions
;-------------------------------------------------
	LD R0, NEWLINE
	TRAP x21
	
	LD R0, START
	LD R1, NUM_ITER
	
	FOR_LOOP_START:
		TRAP x21
		ADD R0, R0, #1
		ADD R1, R1, #-1
		BRp FOR_LOOP_START
	
	HALT
;-------------------------------------------------
;Local Data
;-------------------------------------------------
	START		.FILL 	x61
	NUM_ITER 	.FILL	x1A
	NEWLINE		.FILL	'\n'
;-------------------------------------------------
.END
