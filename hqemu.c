#include <u.h>

#define	DEV_CONS_ADDRESS		0x10000000

void 
main(void)
{
	*((volatile ulong *) DEV_CONS_ADDRESS) = 0x68ul;
	*((volatile ulong *) DEV_CONS_ADDRESS) = 0x65ul;
	*((volatile ulong *) DEV_CONS_ADDRESS) = 0x65ul;
	*((volatile ulong *) DEV_CONS_ADDRESS) = 0x6ful;
	for(;;);
}		

