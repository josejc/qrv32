#include "mem.h"
#include "csr.h"

// Special purpose registers (ureg.h):
// R1: link register
// R2: stack pointer
// R3: static base SB
// R8: first arg/ret value

TEXT _start(SB), $-4
	// set static base	
	MOVW $setSB(SB), R3

	// set stack pointer
	MOVW $(KSTACK_LOW_END), R2
	ADD $(KSTKSIZE), R2, R2
	ADD $-16, R2 // sp should point to next available, so need -4, 16 is for nice alignment and maybe unnecessary

	// set frame pointer
	ADD R0, R2, R8

	// call main
	JAL R1, main(SB)
	RET

	
// Don't profile (1 bit) https://9p.io/sys/doc/asm.html
// opensbi_ecall(__a0, __a1, __a2, __fid, __eid)
TEXT opensbi_ecall(SB), 1, $-4
	MOVW R8, R10 // __a0
	MOVW 4(FP), R11 // __a1
	MOVW 8(FP), R12 // __a2
	MOVW 12(FP), R16 // __fid a6
	MOVW 16(FP), R17 // __eid a7
	ECALL
	MOVW R10, R8 // a0 to ret.
	RET

TEXT write_stvec(SB), $-4
	MOVW R8, CSR(stvec)
	RET

TEXT set_sstatus_sie_bit(SB), $-4
	MOVW CSR(sstatus), R8
	OR $2, R8			// bit 2 in register sstatus
	MOVW R8, CSR(sstatus)
	RET

TEXT get_rdtime(SB), 1, $-4
	MOVW CSR(rdtime), R8
	RET

TEXT set_sie_stie_bit(SB), $-4
	MOVW CSR(sie), R8
	OR $32, R8			// bit 5 in register sie
	MOVW R8, CSR(sie)
	RET

TEXT clr_sip_bit(SB), $-4
//	MOVW CSR(sip), R8
//	// Warning... sign extension? better use a temporary reg?
//	AND $˜(32), R8			// bit 5 (stip) in register sip (s-mode time pending)
//	MOVW R8, CSR(sip)
	CSRRC	CSR(sip), R8, R0
	RET
