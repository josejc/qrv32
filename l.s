#include "mem.h"
#include "csr.h"

#define SRET    WORD $0x10200073      /* return from supervisor mode handling */

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
	CSRRC	CSR(sip), R8, R0
	RET

TEXT trap_handler(SB), 1, $-32   // allocate 32 bytes stack frame
    MOVW    R1, 0(SP)            // save return address (RA = R1)
    MOVW    R5, 4(SP)            // save t0 (R5)
    MOVW    R6, 8(SP)            // save t1 (R6)
    MOVW    R7, 12(SP)           // save t2 (R7)

    // call C handler (void s_mode_interrupt_handler(void))
    MOVW $setSB(SB), R3
    JAL R1, s_mode_interrupt_handler(SB)

    ADD     $4, R6               // advance SEPC
    MOVW    CSR(sepc), R6

    MOVW    0(SP), R1            // restore RA
    MOVW    4(SP), R5            // restore t0
    MOVW    8(SP), R6            // restore t1
    MOVW    12(SP), R7           // restore t2

    SRET                         // return from trap

