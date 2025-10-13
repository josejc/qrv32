#include <u.h>
#include "mem.h"
#include "csr.h"
#include "dat.h"
#include "fns.h"

#define MSG_TIMER 	"Timer interrupt\n"

void 
set_timer_in_near_future(void)
{
	struct sbiret sret;

	sret.error = get_rdtime();
	sret.error += 10000000;
	
	sbi_set_timer(&sret);
}

void 
setup_s_mode_interrupt(void) 
{
	write_stvec((ulong) trap_handler);	// set the interrupt addr. for s-mode
	set_sstatus_bit(BIT(b_sie));		// enable flag s-mode interrupt (bit sie)
}

Ureg * 
s_mode_interrupt_handler(void)
{
	Ureg *ureg = (Ureg *) UREGADDR;
	struct sbiret message;

	// We only expect the timer interrupt to happen here, no need to inspect the cause
	clr_sip_bit(BIT(b_stip));			// clear timer pending bit (stip)
	set_timer_in_near_future();

	message.error = 16;
	message.value = (ulong) MSG_TIMER;
	sbi_debug_console_write(&message);

	return ureg;
}

