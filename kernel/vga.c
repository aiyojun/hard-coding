#define MEMORY_VGA 0xb8000
#define VGA_WIDTH 80
#define VGA_HEIGHT 25

static int vga_c = 0, vga_l = 0;

void clear()
{
	char *p_vga = (char *) MEMORY_VGA;
	for (unsigned int j = 0; j < VGA_HEIGHT; j++)
	{
		for (unsigned int i = 0; i < VGA_WIDTH; i++)
		{
			p_vga[2 * (j * VGA_WIDTH + i)] = 0;
			p_vga[2 * (j * VGA_WIDTH + i) + 1] = 0x07;
		}
	}
}

void print(char *ptr, unsigned int length)
{
	char *p_vga = (char *) MEMORY_VGA;
	unsigned int j = vga_c, k = vga_l;
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
		p_vga[2 * (k * VGA_WIDTH + j)] = ptr[i];
		p_vga[2 * (k * VGA_WIDTH + j) + 1] = 0x07;
		j++;
	}
	vga_c = j >= VGA_WIDTH ? 0 : j;
	vga_l = j >= VGA_WIDTH ? (k + 1) : k;
}

void println(char *ptr, unsigned int length)
{
	print(ptr, length);
	print("\n", 1);
}