#include <u.h>

#define UART_BASE		0x10000000

void 
uartputc(char c)
{
	*((volatile ulong *) UART_BASE) = c;
}		

void
printstr(char *s)
{
        while (*s)
                uartputc(*s++);
}

void
main(void)
{
        printstr("Hello world\n");
	for (;;);
}
