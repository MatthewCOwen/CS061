;=================================================
; Name: 	Matthew Owen
; Email: 	mowen011@ucr.edu
; 
; Lab: lab 3, ex 3
; Lab section: 	023
; TA: 			Nikhil
; 
;=================================================
.ORIG x3000
;-------------------------------------------------
;Instructions
;-------------------------------------------------
	;Populate the Array
	AND R1, R1, #0		;Initialize R1 to 0
	ADD	R2, R1, #-10	;Initialize R2 to -10
	
	DO_WHILE_1
		LEA	R3, ARRAY
		GETC
		ADD R3, R3, R1
		STR	R0, R3, #0
		
		ADD R1, R1, #1
		ADD R0, R1, R2
		BRnp DO_WHILE_1
		
	;Print the Array
	AND R1, R1, #0		;Initialize R1 to 0
	ADD	R2, R1, #-10	;Initialize R2 to -10
	
	DO_WHILE_2
		LEA	R3, ARRAY
		
		LD R0, NEWLINE
		OUT
		
		ADD R3, R3, R1
		LDR	R0, R3, #0
		OUT
		
		ADD R1, R1, #1
		ADD R0, R1, R2
		BRnp DO_WHILE_2
	
	LD R0, NEWLINE		;for sanity
	OUT
	HALT
;-------------------------------------------------
;Local Data
;-------------------------------------------------
	ARRAY 	.BLKW	#10
	NEWLINE	.FILL	'\n'
;-------------------------------------------------
;Remote Data
;-------------------------------------------------
;-------------------------------------------------
.END
