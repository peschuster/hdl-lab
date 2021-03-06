# Example makefile for HDL Lab
# Integrated Electronic Systems Lab
# TU Darmstadt
#
# Author:	Dipl.-Ing. Boris Traskov
# Email: 	boris.traskov@ies.tu-darmstadt.de
#
# Usage:
# Invoke from shell with "make <target>"
# For example, to compile count32.c run:
# make count32
# To generate utf8-encoded binary (for documentation) run:
# make text
GCC				:= /cad/mentor/tools/gnuarm/install/bin/arm-elf-gcc
SIZE			:= /cad/mentor/tools/gnuarm/install/bin/arm-elf-size
STRIP			:= /cad/mentor/tools/gnuarm/install/bin/arm-elf-strip
OBJDUMP			:= /cad/mentor/tools/gnuarm/install/bin/arm-elf-objdump

### OPTIONS SWITCHING STD-LIB FUNCTIONS ON/OFF
OPT_NOSTDLIBS	:=  -nodefaultlibs -fno-builtin -nostdlib 

### OPTIONS CONTROLLING CODE GENERATION
#-mlittle-endian	Generate code for a processor running in little-endian mode.
#-mthumb or -marm	Select between generating code that executes in ARM and Thumb states.
#-O0				Reduce compilation time and make debugging produce the expected results.
#-T default.ld		specify default linker script
OPT_CODEGEN		:= -mlittle-endian -mthumb -O0 -T default.ld

### OPTIONS CONTROLLING DISASSEMBLY
#-d, --disassemble        Display assembler contents of executable sections
#-s, --full-contents      Display the full contents of all sections requested
#-S, --source             Intermix source code with disassembly
#-x, --all-headers        Display the contents of all headers
#-z, --disassemble-zeroes       Do not skip blocks of zeroes when disassembling
OPT_DASM		:= -dsSxz

SOURCES			:= $(wildcard *.c)
TARGETS			:= $(basename $(SOURCES))
BINS			:= $(wildcard *.bin)
GOLDS			:= $(wildcard *.gold)
LATEX_BINS		:= $(patsubst %.bin, %.bintxt, $(BINS))
LATEX_GOLDS		:= $(patsubst %.gold, %.goldtxt, $(GOLDS))

.PHONY: all clean $(TARGETS) text

##################################################################
#COMPILE
##################################################################
all :
	make $(TARGETS)
	make text

$(TARGETS) :
	make $@.bin $@.dasm

#used to convert binary data to utf8 for the lab manual
text : $(BINS) $(GOLDS)
	make $(LATEX_BINS) $(LATEX_GOLDS)

.SECONDARY:
%.elf : %.c
	$(GCC) $(OPT_NOSTDLIBS) $(OPT_CODEGEN)  $^ -o $@
	$(SIZE) $@
	echo $(TARGETS)

%.dasm:	%.elf
	$(OBJDUMP) $(OPT_DASM) --prefix-addresses --show-raw-insn $^ > $@
	
%.bin: %.elf
	$(STRIP) -O binary $^ -o $@
	
%.bintxt : %.bin
	xxd $^ > $@

%.goldtxt : %.gold
	xxd $^ > $@
##################################################################
#REMOVE ALL INTERMEDIATE FILES
##################################################################
clean:
	rm -f *.elf *.asm *.dasm *.bin *.s *.o *txt
