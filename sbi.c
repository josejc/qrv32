#include <u.h>
#include "sbi.h"
#include "dat.h"
#include "fns.h"

void sbi_debug_console_write(sbiret *m) {
	SBI_ECALL(EID_DBCN, FID_DBCN_WRITE, m->error, m->value, 0);
}
	
