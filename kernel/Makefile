all: kernel.v1

kernel.v1: kmain.o boot.o
	ld -m elf_i386 -Ttext 0x100000 -e _start kmain.o boot.o -o kernel.v1

kmain.o:
	gcc -m32 -c kmain.c -o kmain.o

boot.o:
	nasm -f elf32 boot.s -o boot.o

qemu:
	qemu-system-i386 -kernel kernel.v1

clean:
	rm -rf kmain.o boot.o