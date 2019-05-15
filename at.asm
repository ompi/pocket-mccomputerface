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
	"AT"

.CODE
.DEFINE: "AT" = AUTO.I N
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

.BYTE
	CD 2E
.CODE

	LDA $A
	LDA $A
	LDA $A
	LDA $A
	LDA $A
	LDA $A
	CALL sendChar
	LDA $T
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

sendLoop:
	LDA (HL)
	CALL sendChar
	INC HL
	DEC C
	JR NZ, sendLoop

	CALL sendNewLine

        LDA <recvBuffer
        STA H
        LDA >recvBuffer
        STA L

	LDA 00
	STA (state)

recvLoop:
	LDA ([+5]uartBase)
	AND 01
	JR NZ, recvChar

exit:
	RST


recvChar:
        LDA (uartBase)

	STA C

	LDA (state)
	CPA, 00
	JR Z, zeroState

	LDA (state)
	CPA, 01
	JR Z, oneState

	LDA (state)
	CPA, 02
	JR Z, twoState

	LDA (state)
	CPA, 03
	JR Z, threeState
back:
	LDA C
	STA (HL)
	INC HL
	JR recvLoop

zeroState:
	LDA C
	XOR $O
	JR Z, goOneState
	JR reset
goOneState:
	LDA 01
	STA (state)
	JR back

oneState:
	LDA C
	XOR $K
	JR Z, goTwoState
	JR reset
goTwoState:
	LDA 02
	STA (state)
	JR back

twoState:
	LDA C
	XOR 0D
	JR Z, goThreeState
	JR reset
goThreeState:
	LDA 03
	STA (state)
	JR back

reset:
	LDA 00
	STA (state)
	JR back

threeState:
	LDA C
	XOR 0A
	JR Z, dumpLine
	JR reset

dumpLine:
	LDA L
        STA C
        LDA <recvBuffer
        STA H
        LDA >recvBuffer
        STA L
        CALL ED3B
	CALL E88C
	JR exit

error:
	CALL sendNewLine
	ERR1

sendNewLine:
	LDA 0D
	CALL sendChar
	LDA 0A
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
state: .EQU 40F0
recvBuffer: .EQU 4100
