.ORIGIN: 8000
.CODE
	LDA 83
	STA ([+3]uartBase)
	LDA 01
	STA (uartBase)
	LDA 00
	STA ([+1]uartBase)
	LDA 03
	STA ([+3]uartBase)
	LDA 22
	STA ([+4]uartBase)
	LDA 0f
	STA ([+2]uartBase)

	LDA <userRam
	STA H
	LDA >userRam
	STA L

readLoop:
	LDA ([+5]uartBase)
	AND 01
	JR NZ, recvChar

	PUSH HL
	CALL E42C
	POP HL
	XOR 20
	JR NZ, readLoop

	RET

recvChar:
	LDA (uartBase)	; get char

	STA C

	XOR 0A		; print on newline
	JR Z, dumpLine

	CP L, 1A	; receive at most 26 chars in a line
	JR Z, readLoop
	
	LDA C

	STA (HL)
	INC HL
	JR readLoop

dumpLine:
	LDA L
	STA C
	LDA <userRam
	STA H
	LDA >userRam
	STA L
	CALL ED3B
	LDA <userRam
	STA H
	LDA >userRam
	STA L
	JR readLoop

uartBase: .EQU 0000
userRam: .EQU 4100
