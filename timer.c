#include <u.h>
#include "mem.h"
#include "dat.h"
#include "fns.h"

#define MSG1 "Hello world!\n"
#define MSG2 "Timer interrupt\n"
#define MSG3 "Main thread running\n"

void 
set_timer_in_near_future(void)
{
	struct sbiret sret;

	sret.error = get_rdtime();
	sret.error += 10000000;
	
	sbi_set_timer(&sret);
}

void 
setup_s_mode_interrupt(void *handler_ptr) 
{
	write_stvec((ulong) handler_ptr);	// set the interrupt addr. for s-mode
	set_sstatus_sie_bit();			// enable flag s-mode interrupt
}

void 
s_mode_interrupt_handler(void)
{
	struct sbiret message;

	clr_sip_bit(1<<5);			// clear timer pending bit
	set_timer_in_near_future();

	message.error = 16;
	message.value = (ulong) MSG2;
	sbi_debug_console_write(&message);
}

void
main(void)
{
	struct sbiret message;

	message.error = 13;
	message.value = (ulong) MSG1;
	sbi_debug_console_write(&message);

	setup_s_mode_interrupt(&s_mode_interrupt_handler);
	set_timer_in_near_future();
	set_sie_stie_bit();			// enable s-mode timer interrupt

	while (1)
	{
		message.error = 20;
		message.value = (ulong) MSG3;
		sbi_debug_console_write(&message);

		for (int i = 0; i < 300000000; i++); // Simulate a delay
	}
}






