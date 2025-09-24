#include <u.h>
#include "mem.h"
#include "fns.h"

void
main(void)
{
	sbi_debug_console_write("Hello world\n", 12);
	for (;;);
}


