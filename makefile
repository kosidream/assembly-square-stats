# CS 218 Assignment #6
# Simple make file for asst #6

OBJS	= ast6.o
ASM	= yasm -g dwarf2 -f elf64
LD	= ld -g

all: ast6

ast6.o: ast6.asm 
	$(ASM) ast6.asm -l ast6.lst

ast6: ast6.o
	$(LD) -o ast6 $(OBJS)

# -----
# clean by removing object file.

clean:
	rm	$(OBJS)
	rm	ast6.lst
