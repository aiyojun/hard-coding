#include "vga.h"
#define CONST_STR(s) s, sizeof(s) - 1
#define TOCH(e) e < 10 ? 48 + e : 87 + e
#define GDT_LEN 16

static char gdt[GDT_LEN] = {0};

unsigned int b2a(char* ptr, unsigned int length, char buf[])
{
	unsigned int j = 0;
	for (unsigned int i = 0; i < length; i++) {
		buf[j++] = TOCH((unsigned char) ((ptr[i] >> 4) & 0x0f));
		buf[j++] = TOCH((unsigned char) (ptr[i] & 0x0f));
		if (i % 2 == 1) buf[j++] = ' ';
	}
	return j;
}

void i2a(int i, char buf[])
{
	for (unsigned int j = 0; j < 8; j++) 
		buf[j] = TOCH((unsigned char) ((i >> (32 - 4 * (j + 1))) & 0x0f));
}

void print_logo()
{
	println(CONST_STR("DJun.OS"));
}

void print_info() 
{
	int i = 0; short w; char b; char buf[512] = {0};
	println(CONST_STR("Inner registers:"));
	print(CONST_STR("[    esp]: 0x"));
	__asm__("movl %%esp, %0\n" : "=r" (i) : : );
	i2a(i, buf); println(buf, 8);

	print(CONST_STR("[    ebp]: 0x"));
	__asm__("movl %%ebp, %0\n" : "=r" (i) : : );
	i2a(i, buf); println(buf, 8);

	print(CONST_STR("[     cs]: 0x"));
	// __asm__("movl %%cs, %0\n" : "=r" (i) : : );
	__asm__("movw %%cs, %0\n" : "=r" (w) : : );
	i2a(w, buf); println(buf, 8);

	print(CONST_STR("[     ds]: 0x"));
	__asm__("movw %%ds, %0\n" : "=r" (w) : : );
	i2a(w, buf); println(buf, 8);

	print(CONST_STR("[     ss]: 0x"));
	__asm__("movw %%ss, %0\n" : "=r" (w) : : );
	i2a(w, buf); println(buf, 8);

	print(CONST_STR("[     es]: 0x"));
	__asm__("movw %%es, %0\n" : "=r" (w) : : );
	i2a(w, buf); println(buf, 8);

	print(CONST_STR("[     gs]: 0x"));
	__asm__("movw %%gs, %0\n" : "=r" (w) : : );
	i2a(w, buf); println(buf, 8);

	print(CONST_STR("[    cr0]: 0x"));
	__asm__("movl %%cr0, %0\n" : "=r" (i) : : );
	i2a(i, buf); println(buf, 8);

	print(CONST_STR("[    A20]: 0x"));
	__asm__("inb $0x92, %0\n" : "=r" (b) : : );
	i2a(b, buf); println(buf, 8);

	print(CONST_STR("[    GDT]: "));
	__asm__("sgdt (gdt)\n");
	int r = b2a(gdt, GDT_LEN, buf);
	println(buf, r);

	print(CONST_STR("[0x10000]: "));
	r = b2a((char *) 0x10000, 16, buf);
	println(buf, r);
}

