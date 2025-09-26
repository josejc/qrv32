#include <u.h>
#include "mem.h"
#include "dat.h"
#include "fns.h"

#define MSG1 "Hello world,\n"
#define MSG2 "take me to your leader\n"

void
main(void)
{
	struct sbiret message;

	message.error = 13;
	message.value = (ulong) MSG1;
	sbi_debug_console_write(&message);
	message.error = 23;
	message.value = (ulong) MSG2;
	sbi_debug_console_write(&message);
	for (;;);
}


