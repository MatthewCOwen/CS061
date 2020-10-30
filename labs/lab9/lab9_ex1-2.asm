;=================================================
; Name: 	Matthew Owen
; Email: 	mowen011@ucr.edu
; 
; Lab: lab 9, ex 1 & 2
; Lab section: 	023
; TA: 			Nikhil
; 
;=================================================
.ORIG x3000
;Test Harness

	LD	R1, SUB_STACK_PUSH
	LD	R2, SUB_STACK_POP

	LD	R4, BASE
	LD	R5, MAX
	LD	R6, TOS
	
	AND R0, R0, #0
	ADD R0, R0, #-16
	
	JSRR R1
	JSRR R1
	JSRR R1
	JSRR R1
	JSRR R1
	JSRR R1	; should get an error message here
	
	JSRR R2
	JSRR R2
	JSRR R2
	JSRR R2
	JSRR R2
	JSRR R2	; should get an error message here

HALT
;-----------------------------------------------------------------------------------------------
; Test Harness local data:
BASE			.FILL	xA000
MAX				.FILL	xA005
TOS				.FILL	xA000

SUB_STACK_PUSH	.FILL	x3200
SUB_STACK_POP	.FILL	x3400

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
.END
