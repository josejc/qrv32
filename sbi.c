#include <u.h>
#include "sbi.h"
#include "dat.h"
#include "fns.h"
	
int sbi_debug_console_write(sbiret *m) 
{
	return SBI_ECALL(EID_DBCN, FID_DBCN_WRITE, m->error, m->value, 0);
}

void sbi_set_timer(sbiret *m) 
{
	SBI_ECALL(EID_TIME, FID_TIME_SET_TIMER, m->error, 0, 0);
}
