#include <u.h>
#include "sbi.h"
#include "fns.h"

void sbi_debug_console_write(char *str, int len) {
	SBI_ECALL(EID_DBCN, FID_DBCN_WRITE, len, (ulong) str, 0);
}
	
