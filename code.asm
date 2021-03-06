ORG 00H
	RW EQU P2.1 
	RS EQU P2.0
	E EQU P2.2
	MOV TMOD,#60H ; SETTING COUNTER 1 AND OPERATING IN MODE 2
	SETB P3.5 ; TO CHECK EVENTS
	MOV TL1,#00H
	MOV TH1,#00H
	
MOV P1,#38H ; TWO LINES AND 5*7 MATRIX
ACALL SEND_COMMAND

MOV P1,#0EH ; TURN ON DISPLAY AND KEEP CURSOR BLINKING
ACALL SEND_COMMAND

MOV P1,#01H ;CLEAR SCREEN
ACALL SEND_COMMAND
 
SETB TR1; SETTING TIMER ON

HERE:

MOV P1,#80H ;FORCE CURSOR TO THE FIRST LINE
ACALL SEND_COMMAND

MOV P1,TL1
MOV A,P1
CJNE A,#100,NORMAL

NORMAL: JNC NORMAL1
	MOV B,#10
	DIV AB
	ACALL DELAY
	
	  ADD A,#30H
	  MOV P1,A
	ACALL SEND_DATA
	ACALL DELAY
	MOV A,#30H
	ADD A,B
	MOV P1,A
	ACALL SEND_DATA
	ACALL DELAY
	JNB TF1,HERE 
	CLR TF1
	CLR TR1

NORMAL1: 
MOV B,#10
DIV AB
MOV R7,B
MOV B,#10
DIV AB
ADD A,#30H
	  MOV P1,A
	ACALL SEND_DATA
	ACALL DELAY
	MOV A,#30H
	ADD A,B
	MOV P1,A
	ACALL SEND_DATA
	ACALL DELAY
	MOV A,#30H
	ADD A,R7
	MOV P1,A
	ACALL SEND_DATA
	ACALL DELAY
	
JNB TF1,HERE 
CLR TF1
CLR TR1

SEND_COMMAND: CLR RS ;MOVE TO INSTRUCTION REGISTER
			  CLR RW
		      SETB E
			  ACALL DELAY
			  CLR E
			  RET

SEND_DATA:	SETB RS ;MOVE TO DATA REGISTER
			CLR RW
		    SETB E
			ACALL DELAY
			CLR E
			RET
			
DELAY: MOV R1,#10
HERE1: MOV R2,#255
HERE2: DJNZ R2,HERE2
	DJNZ R1, HERE1
	RET
END