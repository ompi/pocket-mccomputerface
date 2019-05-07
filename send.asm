.ORIGIN: 8000
.CODE
	LDA 00
	STA (7875)
	LDA <myMessage
	STA H
	LDA >myMessage
	STA L
	LDA 0c
	CALL ED00

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
	AND 20
	JR Z, waitSend
	RET

uartBase: .EQU 0000

myMessage:
.TEXT
"Hello World! 0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef\00"
