loadaddr=0x80400000

objtype=riscv
</$objtype/mkfile
OBJ=\
	l.$O\
	sbi.$O\
	uart.$O\

OBJ_M=\
	main.$O\

OBJ_T=\
	timer.$O\

CFLAGS=-FVw
LDFLAGS=-l -a -u -H5 -R4096 -T$loadaddr

hq32.bin: $OBJ $OBJ_M
	$LD $LDFLAGS -o $target $prereq > hq32.asm

timer.bin: $OBJ $OBJ_T
	$LD $LDFLAGS -o $target $prereq > timer.asm

%.$O: %.c 
	$CC $CFLAGS $prereq

%.$O: %.s
	$AS $prereq

clean:
	rm -f $OBJ $OBJ_M $OBJ_T hq32.asm hq32.bin timer.asm timer.bin
