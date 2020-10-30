;============================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: 	Matthew Owen
; Email: 	mowen011@ucr.edu
; 
; Assignment name: Assignment 1
; Lab section: 	023
; TA: 			Nikhil Gowda
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;============================================================================

;----------------------------------------------------------------------------
;BUILD TABLE HERE
;----------------------------------------------------------------------------
;Reg Values	R0      R1      R2      R3      R4      R5      R6      R7		
;----------------------------------------------------------------------------
;Pre-Loop	x0000	x0006	x000C	x0000	x0000	x0000	x0000	x0490
;Iter 1		x0000	x0005	x000C	x000C	x0000	x0000	x0000	x0490
;Iter 2		x0000	x0004	x000C	x0018	x0000	x0000	x0000	x0490
;Iter 3		x0000	x0003	x000C	x0024	x0000	x0000	x0000	x0490
;Iter 4		x0000	x0002	x000C	x0030	x0000	x0000	x0000	x0490
;Iter 5		x0000	x0001	x000C	x003C	x0000	x0000	x0000	x0490
;Halt		x0000	x0000	x000C	x0048	x0000	x0000	x0000	x3007
;---------------------------------------------------------------------------

.ORIG x3000				;Program begins here
;-------------
;Instructions: CODE GOES HERE
;-------------
LD	R1, DEC_6			;R1 <-- 6
LD	R2, DEC_12			;R2 <-- 12
LD 	R3, DEC_0			;R3 <-- 0

DO_WHILE	
	ADD R3, R3, R2		;R3 <-- R3 + R2
	ADD R1, R1, #-1		;R1 <-- R1 - 1
	BRp DO_WHILE		;if (LMR > 0) goto DO_WHILE

HALT					;terminate the program
;---------------	
;Data (.FILL, .STRINGZ, .BLKW)
;---------------
DEC_0 	.FILL	#0
DEC_6	.FILL 	#6
DEC_12	.FILL	#12
;---------------	
;END of PROGRAM
;---------------	
.END


