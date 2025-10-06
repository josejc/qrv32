loadaddr=0x80400000

objtype=riscv
</$objtype/mkfile
OBJ=\
	l.$O\
	sbi.$O\
	uartvirt.$O\
	timer.$O\

OBJ_M=\
	main.$O\

CFLAGS=-FVw
LDFLAGS=-l -a -u -H5 -R4096 -T$loadaddr

hq32.bin: $OBJ $OBJ_M
	$LD $LDFLAGS -o $target $prereq > hq32.asm

%.$O: %.c 
	$CC $CFLAGS $prereq

%.$O: %.s
	$AS $prereq

clean:
	rm -f $OBJ $OBJ_M hq32.asm hq32.bin
