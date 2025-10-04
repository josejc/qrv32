#define UART0_BASE  0x10000000UL   /* UART base address */

enum {
    RBR = 0x00,   /* Receiver Buffer Register (read) */
    THR = 0x00,   /* Transmitter Holding Register (write) */
    LSR = 0x05,   /* Line Status Register */
    LSR_DR  = 0x01,   /* Data Ready */
    LSR_THRE = 0x20,  /* Transmitter Holding Register Empty */
};

/* MMIO access */
static unsigned char*
reg(unsigned int off)
{
    return (unsigned char*)(UART0_BASE + off);
}

void
uartputc(char c)
{
    while((*reg(LSR) & LSR_THRE) == 0)
        ;   /* wait until TX is empty */
    *reg(THR) = c;
}

void
uartputs(char *s)
{
    for(; *s; s++){
        uartputc(*s);
    }
}

int
uartgetc(void)
{
    while((*reg(LSR) & LSR_DR) == 0)
        ;   /* wait until data is available */
    return *reg(RBR);
}

