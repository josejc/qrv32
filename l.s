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
TEXT set_sstatus_bit(SB), $-4
	CSRRS 	CSR(sstatus), R8, R0
	RET

TEXT get_rdtime(SB), 1, $-4
	MOVW CSR(rdtime), R8
	RET

TEXT set_sie_bit(SB), $-4		
	CSRRS 	CSR(sie), R8, R0
	RET

TEXT clr_sip_bit(SB), $-4
	CSRRC	CSR(sip), R8, R0
	RET

#define UREG_field(x) (UREGADDR + 4*(x))(R0)

TEXT trap_handler(SB), 1, $-4
	// new, NEW version
	MOVW R4, CSR(sscratch) //WIP hack

	MOVW R1, UREG_field(1)
	MOVW R2, UREG_field(2)
	MOVW R3, UREG_field(3)
	// not R4
	MOVW R5, UREG_field(5)
	MOVW R6, UREG_field(6)
	MOVW R7, UREG_field(7)
	MOVW R8, UREG_field(8)
	MOVW R9, UREG_field(9)
	MOVW R10, UREG_field(10)
	MOVW R11, UREG_field(11)
	MOVW R12, UREG_field(12)
	MOVW R13, UREG_field(13)
	MOVW R14, UREG_field(14)
	MOVW R15, UREG_field(15)
	MOVW R16, UREG_field(16)
	MOVW R17, UREG_field(17)
	MOVW R18, UREG_field(18)
	MOVW R19, UREG_field(19)
	MOVW R20, UREG_field(20)
	MOVW R21, UREG_field(21)
	MOVW R22, UREG_field(22)
	MOVW R23, UREG_field(23)
	MOVW R24, UREG_field(24)
	MOVW R25, UREG_field(25)
	MOVW R26, UREG_field(26)
	MOVW R27, UREG_field(27)
	MOVW R28, UREG_field(28)
	MOVW R29, UREG_field(29)
	MOVW R30, UREG_field(30)
	MOVW R31, UREG_field(31)

	MOVW CSR(sscratch), R1 //WIP hack
	MOVW R1, UREG_field(4) //WIP hack

	MOVW CSR(sepc), R1
	MOVW R1, UREG_field(0)

	MOVW CSR(sstatus), R1
	MOVW R1, UREG_field(32)

	MOVW CSR(sie), R1
	MOVW R1, UREG_field(33)

	MOVW CSR(scause), R1
	MOVW R1, UREG_field(34)

	MOVW CSR(stval), R1
	MOVW R1, UREG_field(35)

	// TODO ureg curmode even though sstatus already has SPP?

	// Are we handling a trap from S-mode?
	// Faults may occur in S-mode while handling syscalls using the
	// per-process kernel stack, so we have a separate stack for this

	MOVW CSR(sstatus), R10

	MOVW $(0x100), R9
	AND R9, R10, R10
	BEQ R9, R10, use_smode_stack

	/* Fall through */
use_process_kstack: // Load mach->proc->kstack
	MOVW $(MACHADDR), R9
	MOVW 12(R9), R10 // proc* in R10
	MOVW 4(R10), R2
	ADD $(KSTACK - 4), R2
	JMP goto_c

use_smode_stack: // Use the S-mode trap stack
	MOVW $(INTR_STK_TOP), R2

	/* Fall through */
goto_c:
    // call C handler (void s_mode_interrupt_handler(void))
    MOVW $setSB(SB), R3
    JAL R1, s_mode_interrupt_handler(SB)

	// The Ureg address we should recover from is now in R8
	
	// Load (optionally) modified pc value from Ureg
	MOVW (0)(R8), R1
	MOVW R1, CSR(sepc)

	// Recover regs
	MOVW (4 * 1)(R8), R1
	MOVW (4 * 2)(R8), R2
	MOVW (4 * 3)(R8), R3
	MOVW (4 * 4)(R8), R4
	MOVW (4 * 5)(R8), R5
	MOVW (4 * 6)(R8), R6
	MOVW (4 * 7)(R8), R7
	// not R8
	MOVW (4 * 9)(R8), R9
	MOVW (4 * 10)(R8), R10
	MOVW (4 * 11)(R8), R11
	MOVW (4 * 12)(R8), R12
	MOVW (4 * 13)(R8), R13
	MOVW (4 * 14)(R8), R14
	MOVW (4 * 15)(R8), R15
	MOVW (4 * 16)(R8), R16
	MOVW (4 * 17)(R8), R17
	MOVW (4 * 18)(R8), R18
	MOVW (4 * 19)(R8), R19
	MOVW (4 * 20)(R8), R20
	MOVW (4 * 21)(R8), R21
	MOVW (4 * 22)(R8), R22
	MOVW (4 * 23)(R8), R23
	MOVW (4 * 24)(R8), R24
	MOVW (4 * 25)(R8), R25
	MOVW (4 * 26)(R8), R26
	MOVW (4 * 27)(R8), R27
	MOVW (4 * 28)(R8), R28
	MOVW (4 * 29)(R8), R29
	MOVW (4 * 30)(R8), R30
	MOVW (4 * 31)(R8), R31

	MOVW (4 * 8)(R8), R8

    SRET                         // return from trap

