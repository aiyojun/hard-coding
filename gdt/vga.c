// 32 bits
#define MEMORY_VGA 0xb8000
#define VGA_WIDTH 80
#define VGA_HEIGHT 25

void print(char *ptr, unsigned int length)
{
	char *p_vga = MEMORY_VGA;
	unsigned int j = 0, k = 0;
	for (unsigned int i = 0; i < length; i++) {
		if (j >= VGA_WIDTH) {
			j = 0;
			k = (k + 1 >= VGA_HEIGHT) ? 0 : k + 1;
		}
		switch (ptr[i]) {
			case '\r':
				j = 0;
				continue;
			case '\n':
				j = 0;
				k = (k + 1 >= VGA_HEIGHT) ? 0 : k + 1;
				continue;
			default:;
		}
		*(p_vga + k * VGA_WIDTH + i) = ptr[i];
	}
}