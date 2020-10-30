;=================================================
; Name: 	Matthew Owen
; Email: 	mowen011@ucr.edu
; 
; Lab: lab 9, ex 3
; Lab section: 	023
; TA: 			Nikhil
; 
;=================================================
.ORIG x3000
;Test Harness
	
	LD	R1, SUB_GET_NUMBER
	
	LD	R2, SUB_STACK_PUSH
	
	LD	R3, SUB_RPN_MULTIPLY
		
	LD	R4, BASE
	LD	R5, MAX
	LD	R6, TOS
	
	JSRR R1				; get 1st number
	ST	R0, LHS 		; save 1st number for later
	JSRR R2				; push 1st number
	
	JSRR R1				; get 2nd number
	ST	R0, RHS			; save 2nd number for later
	JSRR R2				; push 2nd number
	
	GETC
	
	LEA R0, OUTPUT_MESSAGE_1
	
	JSRR R3		
	
	LD	R2, SUB_STACK_POP
	JSRR R2
	
	ST	R0, PRODUCT		; save product for later
	
	AND R0, R0, #0
	ADD R0, R0, x000A
	OUT					; needed a newline here
	
	LD	R2, SUB_PRINT_DECIMAL
	
	LD	R1, LHS
	JSRR R2
	
	LEA	R0, OUTPUT_MESSAGE_1
	PUTS
	
	LD	R1, RHS
	JSRR R2
	
	LEA R0, OUTPUT_MESSAGE_2
	PUTS
	
	LD	R1, PRODUCT
	JSRR R2
	
	AND R0, R0, #0
	ADD R0, R0, x000A
	OUT
	
HALT
;-----------------------------------------------------------------------------------------------
; Test Harness local data:
BASE				.FILL		xA000
MAX					.FILL		xA005
TOS					.FILL		xA000

SUB_STACK_PUSH		.FILL		x3200
SUB_STACK_POP		.FILL		x3400
SUB_RPN_MULTIPLY	.FILL		x3600
SUB_GET_NUMBER		.FILL		x4000
SUB_PRINT_DECIMAL	.FILL		x4200

LHS					.BLKW		#1
RHS					.BLKW		#1
PRODUCT				.BLKW		#1

OUTPUT_MESSAGE_1	.STRINGZ	" * "
OUTPUT_MESSAGE_2	.STRINGZ	" = "

;===============================================================================================


;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_PUSH
; Parameter (R0): The value to push onto the stack
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has pushed (R0) onto the stack (i.e to address TOS+1). 
;		    If the stack was already full (TOS = MAX), the subroutine has printed an
;		    overflow error message and terminated.
; Return Value: R6 ← updated TOS
;------------------------------------------------------------------------------------------
.ORIG x3200

	ST	R0, BACKUP_R0_3200
	ST	R1, BACKUP_R1_3200
	ST	R2, BACKUP_R2_3200
	ST	R3, BACKUP_R3_3200
	ST	R7, BACKUP_R7_3200

	ADD	R1, R6, #1	; R1 <- TOS + 1
	
	NOT R1, R1
	ADD R1, R1, #1	; R1 <- -1 * (TOS + 1)

	ADD R2, R5, R1	; R2 <- MAX - (TOS + 1)
	BRn PUSH_ERROR	; if (TOS + 1 > MAX) => stack overflow

	ADD R6, R6, #1	; actually increment TOS
	
	STR R0, R6, #0	; "Push" to the top of the stack

	BRnzp PUSH_DONE	; skip error message

PUSH_ERROR
	LEA R0, STACK_OVERFLOW
	PUTS

PUSH_DONE
	LD	R0, BACKUP_R0_3200
	LD	R1, BACKUP_R1_3200
	LD	R2, BACKUP_R2_3200				 
	LD	R3, BACKUP_R3_3200
	LD	R7, BACKUP_R7_3200

RET
;-----------------------------------------------------------------------------------------------
; SUB_STACK_PUSH local data

BACKUP_R0_3200	.BLKW		#1
BACKUP_R1_3200	.BLKW		#1
BACKUP_R2_3200	.BLKW		#1
BACKUP_R3_3200	.BLKW		#1
BACKUP_R7_3200	.BLKW		#1

STACK_OVERFLOW	.STRINGZ	"The stack is already full.\n"

;===============================================================================================


;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_POP
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped MEM[TOS] off of the stack.
;		    If the stack was already empty (TOS = BASE), the subroutine has printed
;                an underflow error message and terminated.
; Return Value: R0 ← value popped off the stack
;		   R6 ← updated TOS
;------------------------------------------------------------------------------------------
.ORIG x3400

	ST	R1, BACKUP_R1_3400
	ST	R2, BACKUP_R2_3400
	ST	R3, BACKUP_R3_3400
	ST	R7, BACKUP_R7_3400

	ADD	R1, R6, #-1	; R1 <- TOS - 1
	
	NOT R1, R1
	ADD R1, R1, #1	; R1 <- -1 * (TOS - 1)

	ADD R2, R4, R1	; R2 <- BASE - (TOS - 1)
	BRp POP_ERROR	; if (TOS - 1 < BASE) => stack underflow
	
	LDR R0, R6, #0	; Pop from the top of the stack
	
	ADD R6, R6, #-1	; actually decrement TOS
	
	BRnzp POP_DONE	; skip error message

POP_ERROR
	LEA R0, STACK_UNDRFLOW
	PUTS

POP_DONE
	LD	R1, BACKUP_R1_3400
	LD	R2, BACKUP_R2_3400				 
	LD	R3, BACKUP_R3_3400
	LD	R7, BACKUP_R7_3400

RET
;-----------------------------------------------------------------------------------------------
; SUB_STACK_POP local data

BACKUP_R1_3400	.BLKW		#1
BACKUP_R2_3400	.BLKW		#1
BACKUP_R3_3400	.BLKW		#1
BACKUP_R7_3400	.BLKW		#1

STACK_UNDRFLOW	.STRINGZ	"The stack is already empty.\n"

;===============================================================================================


;------------------------------------------------------------------------------------------
; Subroutine: SUB_RPN_MULTIPLY
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped off the top two values of the stack,
;		    multiplied them together, and pushed the resulting value back
;		    onto the stack.
; Return Value: R6 ← updated TOS address
;------------------------------------------------------------------------------------------
.ORIG x3600

	ST	R0, BACKUP_R0_3600
	ST	R1, BACKUP_R1_3600
	ST	R2, BACKUP_R2_3600
	ST	R3, BACKUP_R3_3600
	ST	R7, BACKUP_R7_3600

	AND R1, R1, #0
	AND R2, R2, #0
	
	LD	R3,	SUB_POP
	
	JSRR R3
	ADD R1, R0, #0
	
	JSRR R3
	ADD R2, R0, #0
	
	LD	R3, SUB_MULTIPLY
	JSRR R3
	
	LD	R3, SUB_PUSH
	JSRR R3
		
	LD	R0, BACKUP_R0_3600
	LD	R1, BACKUP_R1_3600
	LD	R2, BACKUP_R2_3600
	LD	R3, BACKUP_R3_3600
	LD	R7, BACKUP_R7_3600
	
RET
;-----------------------------------------------------------------------------------------------
; SUB_RPN_MULTIPLY local data

BACKUP_R0_3600	.BLKW		#1
BACKUP_R1_3600	.BLKW		#1
BACKUP_R2_3600	.BLKW		#1
BACKUP_R3_3600	.BLKW		#1
BACKUP_R7_3600	.BLKW		#1

TEMP_VAR_1		.BLKW		#1
TEMP_VAR_2		.BLKW		#1

SUB_PUSH		.FILL		x3200
SUB_POP			.FILL		x3400
SUB_MULTIPLY	.FILL		x3800

;===============================================================================================


;------------------------------------------------------------------------------------------
; Subroutine: SUB_MULTIPLY
; Parameter (R1): LHS: A pointer to the base (one less than the lowest available
;                      address) of the stack
; Parameter (R2): RHS: The "highest" available address in the stack
; Postcondition: The subroutine has finished multiplying the 2 numbers
; Return Value: R0 ← The product of R1 and R2
;------------------------------------------------------------------------------------------
.ORIG x3800

	ST	R3, BACKUP_R3_3800
	ST	R7, BACKUP_R7_3800

	AND R0, R1, #0	; R0 ← R1 * 1
	
	ADD	R3, R2, #0	; R3 will be the counter 
	
MULT_LOOP
	ADD R0, R1, R0
		
	ADD R3, R3, #-1

	BRp MULT_LOOP

	LD	R3, BACKUP_R3_3800
	LD	R7, BACKUP_R7_3800	

RET
;-----------------------------------------------------------------------------------------------
; SUB_RPN_MULTIPLY local data

BACKUP_R3_3800	.BLKW		#1
BACKUP_R7_3800	.BLKW		#1

;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine	: SUB_GET_NUMBER
; Postcondition	: R0 contains a single digit number
; Return Value  : R0
;-----------------------------------------------------------------------------------------------
.ORIG x4000
	
	ST	R1, BACKUP_R1_4000
	ST	R7, BACKUP_R7_4000

	LD	R1, ASCII_TO_DECIMAL
	
	LEA R0, PROMPT
	PUTS
	
	GETC
	OUT
	
	ADD R0, R1, R0

	LD	R1, BACKUP_R1_4000
	LD	R7, BACKUP_R7_4000

RET
;-----------------------------------------------------------------------------------------------
; SUB_GET_NUMBER local data

BACKUP_R1_4000		.BLKW		#1
BACKUP_R7_4000		.BLKW		#1

PROMPT				.STRINGZ	"\nPlease enter a single digit number\n"

ASCII_TO_DECIMAL	.FILL		#-48

;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine	: SUB_PRINT_DECIMAL
; Parameter		: R1 contains a positive 16-bit value
; Postcondition	: R1 is no longer divisible by 10
;-----------------------------------------------------------------------------------------------
.ORIG x4200

	ST	R0, BACKUP_R0_4200
	ST	R1, BACKUP_R1_4200
	ST	R2, BACKUP_R2_4200
	ST	R3, BACKUP_R3_4200
	ST	R4, BACKUP_R4_4200
	ST	R5, BACKUP_R5_4200
	ST	R7, BACKUP_R7_4200

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

		ADD R4, R4, #0
		BRz NO_PRINT

		LD 	R0, DEC_TO_ASCII
		ADD R0, R0, R4
		OUT
		
	NO_PRINT
		
		ADD R2, R2, #1
		
		AND R4, R4, #0
		BRnzp SUB_LOOP
		
BREAK_LOOP

	LD	R0, BACKUP_R0_4200
	LD	R1, BACKUP_R1_4200
	LD	R2, BACKUP_R2_4200
	LD	R3, BACKUP_R3_4200
	LD	R4, BACKUP_R4_4200
	LD	R5, BACKUP_R5_4200
	LD	R7, BACKUP_R7_4200

RET
;-----------------------------------------------------------------------------------------------
; SUB_PRINT_DECIMAL Data

BACKUP_R0_4200	.BLKW	#1
BACKUP_R1_4200	.BLKW	#1
BACKUP_R2_4200	.BLKW	#1
BACKUP_R3_4200	.BLKW	#1
BACKUP_R4_4200	.BLKW	#1
BACKUP_R5_4200	.BLKW	#1
BACKUP_R7_4200	.BLKW	#1

NEG_TEST		.FILL	x8000
NEG_SIGN		.FILL	'-'

DEC_TO_ASCII	.FILL	x0030

FACTORS			.FILL	#-10000
				.FILL	#-1000
				.FILL	#-100
				.FILL	#-10
				.FILL	#-1

;===============================================================================================
.END
