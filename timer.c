#include <u.h>
#include "mem.h"
#include "csr.h"
#include "dat.h"
#include "fns.h"

#define MSG_INI 	"Hello world!\n"
#define MSG_TIMER 	"Timer interrupt\n"
#define MSG_MAIN 	"Main thread running\n"
#define MSG_NO_DBCN 	"OpenSBI debug console not available\n"

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

void 
s_mode_interrupt_handler(void)
{
	struct sbiret message;

	// We only expect the timer interrupt to happen here, no need to inspect the cause
	clr_sip_bit(BIT(b_stip));			// clear timer pending bit (stip)
	set_timer_in_near_future();

	message.error = 16;
	message.value = (ulong) MSG_TIMER;
	sbi_debug_console_write(&message);
}

void
main(void)
{
	struct sbiret message;

	message.error = 13;
	message.value = (ulong) MSG_INI;
	message.error = sbi_debug_console_write(&message);

	if (message.error != 0)
	{
		/* SBI debug console not available, fall back to direct UART */
		uartputs(MSG_NO_DBCN);
		for(;;);
	}

	setup_s_mode_interrupt();
	set_timer_in_near_future();
	set_sie_bit(BIT(b_stie));			// enable s-mode timer interrupt (bit stie)

	while (1)
	{
		message.error = 20;
		message.value = (ulong) MSG_MAIN;
		sbi_debug_console_write(&message);

		for (int i = 0; i < 300000000; i++); // Simulate a delay
	}
}

