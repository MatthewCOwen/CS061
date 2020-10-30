;=================================================
; Name: 	Matthew Owen
; Email: 	mowen011@ucr.edu
; 
; Lab: lab 8, ex 1 & 2
; Lab section: 	023
; TA: 			Nikhil
; 
;=================================================
.ORIG x3000
; test harness
	LD	R2, SUB_PRINT_OPCODES
	JSRR R2
				 
				 
HALT			
;-----------------------------------------------------------------------------------------------
; test harness local data:
SUB_PRINT_OPCODES	.FILL	 x3200



;===============================================================================================


; subroutines:
;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_PRINT_OPCODES
; Parameters: None
; Postcondition: The subroutine has printed out a list of every LC3 instruction
;		 		 and corresponding opcode in the following format:
;		 		 ADD = 0001
;		  		 AND = 0101
;		  		 BR = 0000
;		  		 …
; Return Value: None
;-----------------------------------------------------------------------------------------------
.ORIG x3200
	ST	R0, BACKUP_R0_3200
	ST	R1, BACKUP_R1_3200
	ST	R2, BACKUP_R2_3200
	ST	R3, BACKUP_R3_3200
	ST	R4, BACKUP_R4_3200
	ST	R7, BACKUP_R7_3200
	
	LD	R1, instructions_po
	LD	R3, opcodes_po
	LD	R4, SUB_PRINT_OPCODE
		
	PRINT_LOOP
		AND R0, R0, #0
		ADD R0, R0, R1
		
		PUTS
	
		LEA R0, fill
		PUTS
	
		LDR R2, R3, #0
		JSRR R4
		
		LD 	R0, newline
		OUT
		
		ADD R1, R1, #5
		
		LDR R0, R1, #0
		BRn FINISHED_PRINTING
		
		ADD R3, R3, #1
		BRnzp PRINT_LOOP

	FINISHED_PRINTING
	
	LD	R0, BACKUP_R0_3200
	LD	R1, BACKUP_R1_3200
	LD	R2, BACKUP_R2_3200
	LD	R3, BACKUP_R3_3200
	LD	R4, BACKUP_R4_3200
	LD	R7,	BACKUP_R7_3200
RET
;-----------------------------------------------------------------------------------------------
; SUB_PRINT_OPCODES local data
BACKUP_R0_3200		.BLKW		#1
BACKUP_R1_3200		.BLKW		#1
BACKUP_R2_3200		.BLKW		#1
BACKUP_R3_3200		.BLKW		#1
BACKUP_R4_3200		.BLKW		#1
BACKUP_R7_3200		.BLKW		#1

opcodes_po			.FILL 		x4000
instructions_po		.FILL 		x4100

fill				.STRINGZ	" = "
newline				.FILL		'\n'

SUB_PRINT_OPCODE	.FILL		x3400

;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_PRINT_OPCODE
; Parameters: R2 containing a 4-bit op-code in the 4 LSBs of the register
; Postcondition: The subroutine has printed out just the 4 bits as 4 ascii 1s and 0s
;				 The output is NOT newline terminated.
; Return Value: None
;-----------------------------------------------------------------------------------------------
.ORIG x3400
	ST	R0, BACKUP_R0_3400
	ST	R1, BACKUP_R1_3400
	ST	R3, BACKUP_R3_3400
	ST	R7, BACKUP_R7_3400			 
	
	LD	R0, ASCII_ZERO
	
	AND R1, R1, #0
	ADD R1, R1, #8
	
	AND R3, R1, R2
	BRz PRINT_BIT_3
		ADD R0, R0, #1
	PRINT_BIT_3
		OUT
		
	LD	R0, ASCII_ZERO
	ADD R1, R1, #-4
	
	AND R3, R1, R2
	BRz	PRINT_BIT_2
		ADD R0, R0, #1
	PRINT_BIT_2
		OUT
		
	LD	R0, ASCII_ZERO
	ADD R1, R1, #-2
	
	AND R3, R1, R2
	BRz PRINT_BIT_1
		ADD R0, R0, #1
	PRINT_BIT_1
		OUT
	
	LD	R0, ASCII_ZERO
	ADD	R1, R1, #-1
	
	AND R3, R1, R2
	BRz PRINT_BIT_0
		ADD R0, R0, #1
	PRINT_BIT_0
		OUT
	
	LD	R0, BACKUP_R0_3400
	LD	R1, BACKUP_R1_3400
	LD	R3, BACKUP_R3_3400
	LD	R7, BACKUP_R7_3400
RET
;-----------------------------------------------------------------------------------------------
; SUB_PRINT_OPCODE local data
BACKUP_R0_3400		.BLKW		#1
BACKUP_R1_3400		.BLKW		#1
BACKUP_R3_3400		.BLKW		#1
BACKUP_R7_3400		.BLKW		#1

ASCII_ZERO			.FILL		'0'

;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_FIND_OPCODE
; Parameters: None
; Postcondition: The subroutine has invoked the SUB_GET_STRING subroutine and stored a string
; 				as local data; it has searched the AL instruction list for that string, and reported
;				either the instruction/opcode pair, OR "Invalid instruction"
; Return Value: None
;-----------------------------------------------------------------------------------------------
.ORIG x3600
				 
				 
				 
				 
				 
RET
;-----------------------------------------------------------------------------------------------
; SUB_FIND_OPCODE local data
opcodes_fo			.fill x4000
instructions_fo		.fill x4100



;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_GET_STRING
; Parameters: R2 - the address to which the null-terminated string will be stored.
; Postcondition: The subroutine has prompted the user to enter a short string, terminated 
; 				by [ENTER]. That string has been stored as a null-terminated character array 
; 				at the address in R2
; Return Value: None (the address in R2 does not need to be preserved)
;-----------------------------------------------------------------------------------------------
.ORIG x3800
				 
				 
				 
				 
				 
RET
;-----------------------------------------------------------------------------------------------
; SUB_GET_STRING local data



;===============================================================================================


;-----------------------------------------------------------------------------------------------
; REMOTE DATA
.ORIG x4000			; list opcodes as single numbers, e.g. .fill #12
	opcodes			.FILL #1	;ADD
					.FILL #5	;AND
					.FILL #0	;BR
					.FILL #12	;JMP
					.FILL #4	;JSR
					.FILL #4	;JSRR
					.FILL #2	;LD
					.FILL #10	;LDI
					.FILL #6	;LDR
					.FILL #14	;LEA
					.FILL #9	;NOT
					.FILL #12	;RET
					.FILL #8	;RTI
					.FILL #3	;ST
					.FILL #11	;STI
					.FILL #7	;STR
					.FILL #15	;TRAP

.ORIG x4100			; list AL instructions as null-terminated character strings, e.g. .stringz "JMP"
					;- be sure to follow same order in opcode & instruction arrays!
	INSTRUCTIONS	.STRINGZ	"ADD "
					.STRINGZ	"AND "
					.STRINGZ	"BR  "
					.STRINGZ	"JMP "
					.STRINGZ	"JSR "
					.STRINGZ	"JSRR"
					.STRINGZ	"LD  "
					.STRINGZ	"LDI "
					.STRINGZ	"LDR "
					.STRINGZ	"LEA "
					.STRINGZ	"NOT "
					.STRINGZ	"RET "
					.STRINGZ	"RTI "
					.STRINGZ	"ST  "
					.STRINGZ	"STI "
					.STRINGZ	"STR "
					.STRINGZ	"TRAP"
					.FILL #-1	;END OF OPCODES
	

;===============================================================================================
