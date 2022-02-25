all: kernel.v1

kernel.v1: kmain.o boot.o
	ld -m elf_i386 -Ttext 0x1000 -e startup boot.o kmain.o -o kernel.v1

kmain.o:
	gcc -m32 -c kmain.c -o kmain.o

boot.o:
	nasm -f elf32 boot.s -o boot.o

qemu:
	qemu-system-i386 -m 4G -kernel kernel.v1

clean:
	rm -rf kmain.o boot.o

objdump:
	objdump -d kernel.v1 >kernel.v1.s