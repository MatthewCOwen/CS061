;=================================================
; Name: 	Matthew Owen
; Email:	mowen011@ucr.edu
; 
; Lab: lab 1, ex 0
; Lab section: 023
; TA: Nikhil
; 
;=================================================

.ORIG x3000
;-------------------------------------------------
;Instructions
;-------------------------------------------------
	LEA R0, MSG_TO_PRINT 	;R0 <-- the location of the label: MSG_TO_PRINT
	PUTS					;Prints string defined at MSG_TO_PRINT
	
	HALT
;-------------------------------------------------
;Local Data
;-------------------------------------------------
	MSG_TO_PRINT	.STRINGZ	"Hello World!\n"	; store 'H' in an address
													; labelled MSG_TO_PRINT
													; and then each character
													; ('e', 'l', 'l', 'o', ...)
													; in it's own (consecutive)
													; memory address, followed
													; by a null terminating 
													; character at the end of
													; the string
;-------------------------------------------------
.END
