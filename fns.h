#define PTR2UINT(p)	((uintptr)(p))
#define UINT2PTR(i)	((void*)(i))

#define KADDR(p) ((uintptr) p)
#define PADDR(p) ((uintptr) p)

#define BIT(n) (1u << (n))

// SBI
#define SBI_ECALL(__eid, __fid, __a0, __a1, __a2) opensbi_ecall(__a0, __a1, __a2, __fid, __eid)
int opensbi_ecall(unsigned long a0, unsigned long a1, unsigned long a2, unsigned long fid, unsigned long eid);
int sbi_debug_console_write(sbiret *m);
void sbi_set_timer(sbiret *m);

// Low level asm
void write_stvec(uintptr);
void set_sstatus_bit(ulong bit);
int get_rdtime(void);
void set_sie_bit(ulong bit);
void clr_sip_bit(ulong bit);
void trap_handler(void);
void uartputc(char c);
void printstr(char *s);
