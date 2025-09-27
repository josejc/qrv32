#include <u.h>
#include "mem.h"
#include "dat.h"
#include "fns.h"

#define MSG1 "Hello world!\n"
#define MSG2 "Timer interrupt\n"
#define MSG3 "Main thread running\n"

void
main(void)
{
	struct sbiret message;

	message.error = 13;
	message.value = (ulong) MSG1;
	sbi_debug_console_write(&message);
	message.error = 16;
	message.value = (ulong) MSG2;
	sbi_debug_console_write(&message);
	message.error = 20;
	message.value = (ulong) MSG3;
	sbi_debug_console_write(&message);
	for (;;);
}


