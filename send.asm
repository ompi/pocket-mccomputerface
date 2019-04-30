.ORIGIN: 0
.CODE
	LDA 83
	STA ([+3]uartBase)
	LDA 01
	STA (uartBase)
	LDA 00
	STA ([+1]uartBase)
	LDA 03
	STA ([+3]uartBase)

	LDA <myMessage
	STA H
	LDA >myMessage
	STA L
	CALL sendString
	RET

sendString:
	LDA (HL)
	JR Z, sendOver
	CALL sendChar
	INC HL
	JR sendString
sendOver:	
	RET

sendChar:
	STA (uartBase)
waitSend:
	LDA ([+5]uartBase)
	AND 40
	JR NZ, waitSend
	RET

uartBase: .EQU 8000

myMessage:
.TEXT
"Hello World!\00"
