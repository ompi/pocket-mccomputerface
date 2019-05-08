.ORIGIN: 8000
.BYTE
	55 00 $L $O $L 0D 00 00	; 00 - 07
	00 00 9A 9A 9A 9A 9A 9A ; 08 - 0f
	9A 9A 9A 9A 9A 9A 9A 9A ; 10 - 17
	9A 9A 9A 9A 9A C4 AF FF ; 18 - 1f

	00 00 00 00 00 00 00 00
	00 00 00 00 00 00 00 00
	00 00 00 00 00 00 00 00
	00 00 00 00 00 00 00 00

	00 00 00 00 00 00 00 00
	00 00 00 00 00 00 00 00
        00 00 00 00

.KEYWORD
	"LOLWUT"

.CODE
.DEFINE: "LOLWUT" = AUTO.I N
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
        LDA 0F
        STA ([+2]uartBase)

	LDA FA
	CALL sendHex
	LDA 52
	CALL sendHex

.BYTE
	CD 2E
.CODE
	LDA (7A00)
	CALL sendHex
	LDA (7A01)
	CALL sendHex
	LDA (7A02)
	CALL sendHex
	LDA (7A03)
	CALL sendHex
	LDA (7A04)
	CALL sendHex
	LDA (7A05)
	CALL sendHex
	LDA (7A06)
	CALL sendHex
	LDA (7A07)
	CALL sendHex

	LDA 20
	CALL sendChar

	LDA (7A04)
	XOR D0
	JR NZ, error

	LDA (7A05)
	STA H
	LDA (7A06)
	STA L
	LDA (7A07)
	STA C

loop:
	LDA (HL)
	CALL sendChar
	INC HL
	DEC C
	JR NZ, loop

	CALL sendNewLine
	RST

error:
	CALL sendNewLine
	ERR1

sendNewLine:
	LDA 0D
	CALL sendChar
	LDA 0A
	CALL sendChar
	RET

sendHex:
	STA B
	AEX
	AND 0F
	CALL sendNibble
	LDA B
	AND 0F
	CALL sendNibble
	RET

sendNibble:
	CPA 09
	JR NC, lessThanA
	ADC 06
lessThanA:
	ADC $0
	CALL sendChar
	RET

sendChar:
        STA (uartBase)
waitSend:
        LDA ([+5]uartBase)
        AND 20
        JR Z, waitSend
        RET
.END

uartBase: .EQU 0000
