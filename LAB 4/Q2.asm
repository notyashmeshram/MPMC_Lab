#ORG C050H
#BEGIN C050H

	LXI SP, 2499H
START:	MVI A,41H
	OUT 10
	MVI B,0FH
	CALL DELAY
	
	MVI A, 84H
	OUT 10
	MVI B,05H
	CALL DELAY

	MVI A,90H
	OUT 10
	MVI B,14H
	CALL DELAY
	JMP START

DELAY:	PUSH D
	PUSH PSW
SECOND: 	LXI D, 0003H
LOOP2: 	DCX D
	MOV A,E
	ORA D 
	JNZ LOOP2
	DCR B
	JNZ SECOND
	POP PSW
	POP D
	RET