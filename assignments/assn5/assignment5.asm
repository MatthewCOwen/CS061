;=================================================================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: 	Matthew Owen
; Email: 	mowen011@ucr.edu
; 
; Assignment name: Assignment 5
; Lab section: 	023
; TA: 			Nikhil
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=================================================================================================================

;=================================================================================================================
; Instructions
;-----------------------------------------------------------------------------------------------------------------
.ORIG x3000

MENU_LOOP
	LD	R0, SUB_MENU
	JSRR R0
;=================================================================================================================
OPTION_1
	ADD R0, R1, #-1
	BRp	OPTION_2

	LD	R0, SUB_ALL_MACHINES_BUSY
	JSRR R0
	
	LEA R0, ALLBUSY
	
	ADD R2, R2, #0
	BRp OPTION_1_PRINT_OUTPUT

	LEA R0, ALLNOTBUSY

OPTION_1_PRINT_OUTPUT
	PUTS

	BRnzp BOTTOM_OF_LOOP	
;=================================================================================================================
OPTION_2
	ADD R0, R1, #-2
	BRp OPTION_3
	
	LD	R0, SUB_ALL_MACHINES_FREE
	JSRR R0
	
	LEA R0, FREE
	
	ADD R2, R2, #0
	BRp OPTION_2_PRINT_OUTPUT
	
	LEA R0, NOTFREE
	
OPTION_2_PRINT_OUTPUT
	PUTS
	
	BRnzp BOTTOM_OF_LOOP
;=================================================================================================================
OPTION_3
	ADD R0, R1, #-3
	BRp OPTION_4
	
	LD	R0, SUB_NUM_BUSY_MACHINES
	JSRR R0
	
	ADD R1, R1, #0
	
	LEA R0, BUSYMACHINE1
	PUTS
	
	LD	R0, SUB_PRINT_NUMBER
	JSRR R0
	
	LEA R0, BUSYMACHINE2
	PUTS

	BRnzp BOTTOM_OF_LOOP
;=================================================================================================================
OPTION_4
	ADD R0, R1, #-4
	BRp OPTION_5

	LD	R0, SUB_NUM_FREE_MACHINES
	JSRR R0
	
	ADD R1, R1, #0
	
	LEA R0, FREEMACHINE1
	PUTS
	
	LD R0, SUB_PRINT_NUMBER
	JSRR R0
	
	LEA R0, FREEMACHINE2
	PUTS
	
	BRnzp BOTTOM_OF_LOOP
;=================================================================================================================
OPTION_5
	ADD R0, R1, #-5
	BRp OPTION_6
	
	LD	R0, SUB_GET_MACHINE_NUMBER
	JSRR R0
	
	LD	R0, SUB_MACHINE_STATUS
	JSRR R0
	
	LEA R0, STATUS1
	PUTS
	
	LD	R0, SUB_PRINT_NUMBER
	JSRR R0

	LEA R0, STATUS2
	
	ADD R2, R2, #0
	BRz OPTION_5_PRINT_OUTPUT
	
	LEA R0, STATUS3

OPTION_5_PRINT_OUTPUT
	PUTS

	BRnzp BOTTOM_OF_LOOP
;=================================================================================================================
OPTION_6
	ADD R0, R1, #-6
	BRp QUIT
	
	LD	R0, SUB_FIRST_FREE
	JSRR R0
	
	LEA R0, FIRSTFREE1
	
	ADD R1, R1, #0
	BRzp OPTION_6_PRINT_OUTPUT_1
	
	LEA R0, FIRSTFREE2
	BRzp OPTION_6_PRINT_OUTPUT_2

OPTION_6_PRINT_OUTPUT_1
	PUTS
	
	LD	R0, SUB_PRINT_NUMBER
	JSRR R0
	
	BRnzp BOTTOM_OF_LOOP
	 
OPTION_6_PRINT_OUTPUT_2
	PUTS
		
;=================================================================================================================
BOTTOM_OF_LOOP
	LD	R0, NEWLINE
	OUT

	LD	R0, LOOP_START
	JMP R0
;=================================================================================================================

QUIT
	LEA R0, GOODBYE
	PUTS
	
	LD	R0, NEWLINE
	OUT
	
HALT
;-----------------------------------------------------------------------------------------------------------------
; Local Data

LOOP_START							.FILL		x3000

;Subroutines
SUB_MENU							.FILL		x3200
SUB_ALL_MACHINES_BUSY				.FILL		x3400
SUB_ALL_MACHINES_FREE				.FILL		x3600
SUB_NUM_BUSY_MACHINES				.FILL		x3800
SUB_NUM_FREE_MACHINES				.FILL		x4000
SUB_MACHINE_STATUS					.FILL		x4200
SUB_FIRST_FREE						.FILL		x4400
SUB_PRINT_NUMBER					.FILL		x4600
SUB_GET_MACHINE_NUMBER				.FILL		x4800

NEWLINE								.FILL 		'\n'

;Strings for options
ALLNOTBUSY							.STRINGZ	"Not all machines are busy"
ALLBUSY								.STRINGZ	"All machines are busy"
FREE								.STRINGZ	"All machines are free"
NOTFREE								.STRINGZ	"Not all machines are free"
BUSYMACHINE1						.STRINGZ	"There are "
BUSYMACHINE2						.STRINGZ	" busy machines"
FREEMACHINE1						.STRINGZ	"There are "
FREEMACHINE2						.STRINGZ	" free machines"
STATUS1								.STRINGZ	"Machine "
STATUS2								.STRINGZ	" is busy"
STATUS3								.STRINGZ	" is free"
FIRSTFREE1							.STRINGZ	"The first available machine is number "
FIRSTFREE2							.STRINGZ	"No machines are free"
GOODBYE								.STRINGZ	"Goodbye!"
;=================================================================================================================


;=================================================================================================================
; Subroutine	|	MENU
;-----------------------------------------------------------------------------------------------------------------
; Inputs		|	None
;-----------------------------------------------------------------------------------------------------------------
; Postcondition	|	The subroutine has printed out a menu with numerical options, allowed the
;				|	user to select an option, and returned the selected option.
;-----------------------------------------------------------------------------------------------------------------
; Return Value	|	(R1) <- The option selected:  #1, #2, #3, #4, #5, #6 or #7
;				|	no other return value is possible
;-----------------------------------------------------------------------------------------------------------------
.ORIG x3200

	ST	R0, BACKUP_R0_3200
	ST	R2, BACKUP_R2_3200
	ST	R3, BACKUP_R3_3200
	ST	R7, BACKUP_R7_3200

RESET_MENU
	LD	R0, MENU_STRING_ADDR
	PUTS
	
	LD	R2, SUB_VALIDATE_CHAR_3200
	LD	R3, ASCII_TO_DECIMAL_3200
	
	GETC
	OUT
	
	ST	R0, TEMP
	
	AND R0, R0, #0
	ADD R0, R0, x000A
	OUT
	
	LD	R0, TEMP
	
	JSRR R2
	
	ADD R0, R0, #0
	BRn PRINT_ERROR_MESSAGE_3200

	ADD R1, R0, R3
	BRnz PRINT_ERROR_MESSAGE_3200
	
	ADD R0, R1, #-7
	BRp PRINT_ERROR_MESSAGE_3200
	
	BRnzp GOOD_INPUT

PRINT_ERROR_MESSAGE_3200
	
	LEA R0, ERROR_MESSAGE_1
	PUTS
	BRnzp RESET_MENU
	
GOOD_INPUT
	
	LD	R0, BACKUP_R0_3200
	LD	R2, BACKUP_R2_3200
	LD	R3, BACKUP_R3_3200
	LD	R7, BACKUP_R7_3200
	
RET
;-----------------------------------------------------------------------------------------------------------------
; Data for subroutine MENU

ERROR_MESSAGE_1						.STRINGZ	"INVALID INPUT\n"

ASCII_TO_DECIMAL_3200				.FILL		#-48

MENU_STRING_ADDR					.FILL		x6000

SUB_VALIDATE_CHAR_3200				.FILL		x5000

BACKUP_R0_3200						.BLKW		#1
BACKUP_R2_3200						.BLKW		#1
BACKUP_R3_3200						.BLKW		#1
BACKUP_R7_3200						.BLKW		#1

TEMP								.BLKW		#1

;=================================================================================================================


;=================================================================================================================
; Subroutine	|	ALL_MACHINES_BUSY
;-----------------------------------------------------------------------------------------------------------------
; Inputs		|	None
;-----------------------------------------------------------------------------------------------------------------
; Postcondition	|	The subroutine has returned a value indicating whether all machines are busy
;-----------------------------------------------------------------------------------------------------------------
; Return value	|	(R2) <- 1 if all machines are busy, 0 otherwise
;-----------------------------------------------------------------------------------------------------------------
.ORIG x3400
	
	ST	R0, BACKUP_R0_3400
	ST	R7, BACKUP_R7_3400

	AND R2, R2, #0
	ADD R2, R2, #1
	
	LD	R0, BUSYNESS_ADDR_ALL_MACHINES_BUSY
	LDR R0, R0, #0
	
	BRz DONE_CHECKING_3400

	ADD R2, R2, #-1

DONE_CHECKING_3400

	LD	R0, BACKUP_R0_3400
	LD	R7, BACKUP_R7_3400

RET
;-----------------------------------------------------------------------------------------------------------------
; Data for subroutine ALL_MACHINES_BUSY

BUSYNESS_ADDR_ALL_MACHINES_BUSY		.FILL 		xCE00

BACKUP_R0_3400						.BLKW		#1
BACKUP_R7_3400						.BLKW		#1

;=================================================================================================================


;=================================================================================================================
; Subroutine	|	ALL_MACHINES_FREE
;-----------------------------------------------------------------------------------------------------------------
; Inputs		|	None
;-----------------------------------------------------------------------------------------------------------------
; Postcondition	|	The subroutine has returned a value indicating whether all machines are free
;-----------------------------------------------------------------------------------------------------------------
; Return value	|	(R2) <- 1 if all machines are free, 0 otherwise
;-----------------------------------------------------------------------------------------------------------------
.ORIG x3600

	ST	R0, BACKUP_R0_3600

	LD	R0, BUSYNESS_ADDR_ALL_MACHINES_FREE
	LDR R0, R0, #0
	
	AND	R2, R2, #0
	ADD R2, R2, #1
	
	ADD R0, R0, #1
	BRz DONE_CHECKING_3600
	
	ADD R2, R2, #-1

DONE_CHECKING_3600

	LD	R0, BACKUP_R0_3600
	
RET
;-----------------------------------------------------------------------------------------------------------------
; Data for subroutine ALL_MACHINES_FREE

BUSYNESS_ADDR_ALL_MACHINES_FREE		.FILL		xCE00

BACKUP_R0_3600						.BLKW		#1

;=================================================================================================================


;=================================================================================================================
; Subroutine	|	NUM_BUSY_MACHINES
;-----------------------------------------------------------------------------------------------------------------
; Inputs		|	None
;-----------------------------------------------------------------------------------------------------------------
; Postcondition	|	The subroutine has returned the number of busy machines.
;-----------------------------------------------------------------------------------------------------------------
; Return Value	|	(R1) <- The number of machines that are busy
;-----------------------------------------------------------------------------------------------------------------
.ORIG x3800

	ST	R0, BACKUP_R0_3800
	ST	R2, BACKUP_R2_3800
	ST	R3, BACKUP_R3_3800

	LD	R0, BUSYNESS_ADDR_NUM_BUSY_MACHINES
	LDR R0, R0, #0
	
	AND R2, R2, #0
	ADD R2, R2, #1
	
	AND R1, R1, #0
	
CHECK_MACHINE_LOOP_3800
	AND R3, R0, R2
		
	BRnp NO_INCREMENT
	
	ADD R1, R1, #1
	
	NO_INCREMENT
		
		ADD R2, R2, R2
		BRz DONE_CHECKING_3800
	
		BRnzp CHECK_MACHINE_LOOP_3800

DONE_CHECKING_3800

	LD	R0, BACKUP_R0_3800
	LD	R2, BACKUP_R2_3800
	LD	R3, BACKUP_R3_3800

RET
;-----------------------------------------------------------------------------------------------------------------
; Data for subroutine NUM_BUSY_MACHINES

BUSYNESS_ADDR_NUM_BUSY_MACHINES		.FILL		xCE00

BACKUP_R0_3800						.BLKW		#1
BACKUP_R2_3800						.BLKW		#1
BACKUP_R3_3800						.BLKW		#1

;=================================================================================================================


;=================================================================================================================
; Subroutine	|	NUM_FREE_MACHINES
;-----------------------------------------------------------------------------------------------------------------
; Inputs		|	None
;-----------------------------------------------------------------------------------------------------------------
; Postcondition	|	The subroutine has returned the number of free machines
;-----------------------------------------------------------------------------------------------------------------
; Return Value	|	(R1) <- The number of machines that are free 
;-----------------------------------------------------------------------------------------------------------------
.ORIG x4000

	ST	R0, BACKUP_R0_4000
	ST	R7, BACKUP_R7_4000
	
	LD	R0, SUB_NUM_BUSY_MACHINES_4000
	JSRR R0
	
	ADD R1, R1, #-16
	
	NOT R1, R1
	ADD R1, R1, #1
	
	LD	R0, BACKUP_R0_4000
	LD	R7, BACKUP_R7_4000

RET
;-----------------------------------------------------------------------------------------------------------------
; Data for subroutine NUM_FREE_MACHINES

BUSYNESS_ADDR_NUM_FREE_MACHINES		.FILL		xCE00

SUB_NUM_BUSY_MACHINES_4000			.FILL		x3800

BACKUP_R0_4000						.BLKW		#1
BACKUP_R7_4000						.BLKW		#1

;=================================================================================================================


;=================================================================================================================
; Subroutine	|	MACHINE_STATUS
;-----------------------------------------------------------------------------------------------------------------
; Input			|	(R1) <- Which machine to check
;-----------------------------------------------------------------------------------------------------------------
; Postcondition	|	The subroutine has returned a value indicating whether the machine indicated
;				|	by (R1) is busy or not.
;-----------------------------------------------------------------------------------------------------------------
; Return Value	|	(R2) <- 0 if machine (R1) is busy, 1 if it is free
;-----------------------------------------------------------------------------------------------------------------
.ORIG x4200

	ST	R0, BACKUP_R0_4200
	ST	R1, BACKUP_R1_4200
	ST	R3, BACKUP_R3_4200

	LD	R0, BUSYNESS_ADDR_MACHINE_STATUS
	LDR R0, R0, #0
	
	AND R2, R2, #0
	ADD R2, R2, #1
	
	AND R3, R3, #0
	ADD R3, R3, #1

	ADD R1, R1, #0
	BRz CHECK_MACHINE_STATUS
	
MACHINE_STATUS_LOOP
	ADD R3, R3, R3
	
	ADD R1, R1, #-1
	BRp MACHINE_STATUS_LOOP

CHECK_MACHINE_STATUS
	AND R1, R0, R3
	BRnp DONE_CHECKING_4200
	
	ADD R2, R2, #-1
		
DONE_CHECKING_4200

	LD	R0, BACKUP_R0_4200
	LD	R1, BACKUP_R1_4200
	LD	R3, BACKUP_R3_4200

RET
;-----------------------------------------------------------------------------------------------------------------
; Data for subroutine MACHINE_STATUS

BUSYNESS_ADDR_MACHINE_STATUS		.FILL		xCE00

BACKUP_R0_4200						.BLKW		#1
BACKUP_R1_4200						.BLKW		#1
BACKUP_R3_4200						.BLKW		#1

;=================================================================================================================
; Subroutine	|	FIRST_FREE
;-----------------------------------------------------------------------------------------------------------------
; Inputs		|	None
;-----------------------------------------------------------------------------------------------------------------
; Postcondition	|	The subroutine has returned a value indicating the lowest numbered free machine
;-----------------------------------------------------------------------------------------------------------------
; Return Value	|	(R1) <- the number of the free machine
;-----------------------------------------------------------------------------------------------------------------
.ORIG x4400

	ST	R0, BACKUP_R0_4400
	ST	R2, BACKUP_R2_4400
	ST	R3, BACKUP_R3_4400
	ST	R7, BACKUP_R7_4400
	
	LD	R0, BUSYNESS_ADDR_FIRST_FREE
	LDR R0, R0, #0
	
	AND R2, R2, #0
	ADD R2, R2, #1
	
	AND R1, R1, #0
	
CHECK_FIRST_FREE_LOOP
	AND R3, R0, R2
	BRnp DONE_CHECKING_4400
	
	ADD R3, R1, #-16
	BRz NO_FREE_MACHINES
	
	ADD R2, R2, R2
	ADD R1, R1, #1
	
	BRnzp CHECK_FIRST_FREE_LOOP
	
NO_FREE_MACHINES
	AND R1, R1, #0
	ADD R1, R1, #-1

DONE_CHECKING_4400
	
	LD	R0, BACKUP_R0_4400
	LD	R2, BACKUP_R2_4400
	LD	R3, BACKUP_R3_4400
	LD	R7, BACKUP_R7_4400
	
RET
;-----------------------------------------------------------------------------------------------------------------
; Data for subroutine FIRST_FREE

BUSYNESS_ADDR_FIRST_FREE			.FILL		xCE00

SUB_ALL_MACHINES_BUSY_4400			.FILL		x3400
SUB_MACHINE_STATUS_4400				.FILL		x4200

BACKUP_R0_4400						.BLKW		#1
BACKUP_R2_4400						.BLKW		#1
BACKUP_R3_4400						.BLKW		#1
BACKUP_R7_4400						.BLKW		#1

;=================================================================================================================
	

;=================================================================================================================
; Subroutine	|	PRINT_NUMBER
;=================================================================================================================
; Inputs		|	None
;-----------------------------------------------------------------------------------------------------------------
; Postcondition	|	The subroutine has printed the number that is in R1, as a decimal ascii string, 
;				|	WITHOUT leading 0's, a leading sign, or a trailing newline.
;-----------------------------------------------------------------------------------------------------------------
; Note			|	That number is guaranteed to be in the range {#0, #15}, 
;				|	i.e. either a single digit, or '1' followed by a single digit.
;-----------------------------------------------------------------------------------------------------------------
; Return Value	|	None; the value in R1 is unchanged
;-----------------------------------------------------------------------------------------------------------------
.ORIG x4600

	ST	R0, BACKUP_R0_4600
	ST	R1, BACKUP_R1_4600
	ST	R2, BACKUP_R2_4600
	ST	R3, BACKUP_R3_4600
	ST	R4, BACKUP_R4_4600
	ST	R7, BACKUP_R7_4600
		
	ADD R1, R1, #0
	BRnp NONZERO
	
	LD	R3, DEC_TO_ASCII
	ADD R0, R1, R3
	OUT
	BRnzp BREAK_LOOP

NONZERO

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
		
		ADD R0, R3, #-1
		BRz STILL_PRINT
		
		ADD R4, R4, #0
		BRz NO_PRINT

	STILL_PRINT
		LD 	R0, DEC_TO_ASCII
		ADD R0, R0, R4
		OUT
		
	NO_PRINT
		
		ADD R2, R2, #1
		
		AND R4, R4, #0
		BRnzp SUB_LOOP
		
BREAK_LOOP

	LD	R0, BACKUP_R0_4600
	LD	R1, BACKUP_R1_4600
	LD	R2, BACKUP_R2_4600
	LD	R3, BACKUP_R3_4600
	LD	R4, BACKUP_R4_4600
	LD	R7, BACKUP_R7_4600

RET
;-----------------------------------------------------------------------------------------------------------------
; Data for subroutine PRINT_NUMBER

BACKUP_R0_4600						.BLKW		#1
BACKUP_R1_4600						.BLKW		#1
BACKUP_R2_4600						.BLKW		#1
BACKUP_R3_4600						.BLKW		#1
BACKUP_R4_4600						.BLKW		#1
BACKUP_R7_4600						.BLKW		#1

DEC_TO_ASCII						.FILL		x0030

FACTORS								.FILL		#-10
									.FILL		#-1

;=================================================================================================================


;=================================================================================================================
; Subroutine	|	GET_MACHINE_NUM
;-----------------------------------------------------------------------------------------------------------------
; Inputs		|	None
;-----------------------------------------------------------------------------------------------------------------
; Postcondition	|	The number entered by the user at the keyboard has been converted into binary
;				|	and stored in R1. The number has been validated to be in the range {0, 15}
;-----------------------------------------------------------------------------------------------------------------
; Return Value	|	(R1) <- The binary equivalent of the numeric keyboard entry.
;-----------------------------------------------------------------------------------------------------------------
; NOTE			|	This subroutine should be the same as the one that you did in assignment 4
;				|	to get input from the user, except the prompt is different.
;-----------------------------------------------------------------------------------------------------------------
.ORIG x4800
	
	ST	R0, BACKUP_R0_4800
	ST	R2, BACKUP_R2_4800
	ST	R3, BACKUP_R3_4800
	ST	R4, BACKUP_R4_4800
	ST	R5, BACKUP_R5_4800
	ST	R7, BACKUP_R7_4800
		
GET_MACHINE_NUM_RESET
	LD	R2, SUB_VALIDATE_CHAR_4800
	LD	R3, SUB_MULT_BY_TEN
	LD	R4, ASCII_TO_DECIMAL_4800 

	AND R1, R1, #0
	
	LEA R0, PROMPT
	PUTS
	
	GETC
	OUT
	JSRR R2
	
	ADD R0, R0, #0
	BRn PRINT_ERROR_MESSAGE_4800

	ADD	R5, R0, R4				; (R5) <- R0 - 48
	BRn PRINT_ERROR_MESSAGE_4800
	
	ADD R1, R1, R5
	
GET_MACHINE_NUM_LOOP
	GETC
	OUT
	JSRR R2
	
	ADD R0, R0, #0
	BRn PRINT_ERROR_MESSAGE_4800_NO_NEWLINE
	
	ADD R5, R0, R4
	BRn GOT_MACHINE_NUM
	
	JSRR R3
	ADD R1, R1, R5
	
	BRnzp GET_MACHINE_NUM_LOOP

PRINT_ERROR_MESSAGE_4800
	AND R0, R0, #0
	ADD R0, R0, x000A
	OUT
PRINT_ERROR_MESSAGE_4800_NO_NEWLINE
	LEA R0, ERROR_MESSAGE_2
	PUTS
	BRnzp GET_MACHINE_NUM_RESET
	
GOT_MACHINE_NUM
	ADD R2, R1, #-15
	BRp PRINT_ERROR_MESSAGE_4800

	LD	R0, BACKUP_R0_4800
	LD	R2, BACKUP_R2_4800
	LD	R3, BACKUP_R3_4800
	LD	R4, BACKUP_R4_4800
	LD	R5, BACKUP_R5_4800
	LD	R7, BACKUP_R7_4800

RET
;-----------------------------------------------------------------------------------------------------------------
; Data for subroutine GET_MACHINE_NUM

PROMPT								.STRINGZ	"Enter which machine you want the status of (0 - 15), followed by ENTER: "
ERROR_MESSAGE_2						.STRINGZ	"ERROR INVALID INPUT\n"

ASCII_TO_DECIMAL_4800				.FILL		#-48

BACKUP_R0_4800						.BLKW		#1
BACKUP_R2_4800						.BLKW		#1
BACKUP_R3_4800						.BLKW		#1
BACKUP_R4_4800						.BLKW		#1
BACKUP_R5_4800						.BLKW		#1
BACKUP_R7_4800						.BLKW		#1

SUB_VALIDATE_CHAR_4800				.FILL		x5000
SUB_MULT_BY_TEN						.FILL		x5200

;=================================================================================================================	


;=================================================================================================================
; Subroutine	|	VALIDATE_CHAR
;-----------------------------------------------------------------------------------------------------------------
; Parameter 	|	(R0) <- character to check
;-----------------------------------------------------------------------------------------------------------------
; Postcondition	|	R0 retains its value if it contains a valid character
;-----------------------------------------------------------------------------------------------------------------
; Return value	|	(R0) <- retains value if valid, else #-1
;-----------------------------------------------------------------------------------------------------------------
.ORIG x5000

	ST	R1, BACKUP_R1_5000
	ST	R2, BACKUP_R2_5000
	ST	R3, BACKUP_R3_5000
	ST	R7, BACKUP_R7_5000
	
	LEA R1, VALID_CHARS

DO_WHILE_VALID_CHAR
	CHECK_LOOP
		NOT R2, R0	
		ADD R2, R2, #1				;R2 = -1 * R0

		LDR R3, R1, #0			
		BRz BAD_CHAR	
		
		ADD R2, R3, R2			
		BRz GOOD_CHAR

		ADD R1, R1, #1
		BRnzp CHECK_LOOP
		
	BAD_CHAR
		AND	R0, R0, #0
		ADD	R0, R0, #-1
		
GOOD_CHAR
	LD	R1, BACKUP_R1_5000
	LD	R2, BACKUP_R2_5000
	LD	R3, BACKUP_R3_5000
	LD	R7, BACKUP_R7_5000
	
RET
;-----------------------------------------------------------------------------------------------------------------
; Data for subroutine VALIDATE_CHAR

VALID_CHARS							.STRINGZ	"0123456789\n"

BACKUP_R1_5000						.BLKW		#1
BACKUP_R2_5000						.BLKW		#1
BACKUP_R3_5000						.BLKW		#1
BACKUP_R7_5000						.BLKW		#1

;=================================================================================================================


;=================================================================================================================
; Subroutine	|	MULT_BY_TEN
;-----------------------------------------------------------------------------------------------------------------
; Inputs		|	(R1) <- The value to be multiplied by 10
;-----------------------------------------------------------------------------------------------------------------
; Postcondition	|	The subroutine has finished multiplying R1 by 10
;-----------------------------------------------------------------------------------------------------------------
; Return Value	|	(R1) <- (R1) * 10
;-----------------------------------------------------------------------------------------------------------------
.ORIG x5200

	ST	R2, BACKUP_R2_5200
	
	ADD R2, R1, #0
	
	ADD R1, R1, R1
	ADD	R1, R1, R1
	ADD R1, R1, R1			;R1 * 8
	
	ADD R1, R1, R2
	ADD R1, R1, R2			;R1 * 8 + 2 * R1
	
	LD	R2, BACKUP_R2_5200
	
RET
;-----------------------------------------------------------------------------------------------------------------
; Data for subroutine MULT_BY_TEN

BACKUP_R2_5200						.BLKW		#1

;=================================================================================================================


;-----------------------------------------------------------------------------------------------------------------
; Remote Data 

.ORIG x6000
MENUSTRING							.STRINGZ	"**********************\n* The Busyness Server *\n**********************\n1. Check to see whether all machines are busy\n2. Check to see whether all machines are free\n3. Report the number of busy machines\n4. Report the number of free machines\n5. Report the status of machine n\n6. Report the number of the first available machine\n7. Quit\n"

.ORIG xCE00
BUSYNESS							.FILL		x0000		; <----!!!BUSYNESS VECTOR!!! Change this value to test your program.

;=================================================================================================================
.END
