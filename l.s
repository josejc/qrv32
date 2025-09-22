TEXT start(SB), $-4
	/* set static base */
	MOVW 	$setSB(SB), R3

	/* set stack pointer */
	MOVW	$0x80020000, R2

	/* set frame pointer */
	ADD 	R0, R2, R8

	/* call main */
	JAL	R1, main(SB)
