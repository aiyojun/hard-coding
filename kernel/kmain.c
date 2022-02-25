#define MEMORY_VGA 0xb8000
#define VGA_WIDTH 80
#define VGA_HEIGHT 25

#define TOCH(e) e < 10 ? 48 + e : 87 + e

static int vga_c = 0, vga_l = 0;

void clear();
void print_logo();
void print8bytes(int value);
void print(char *ptr, unsigned int length);
void println(char *ptr, unsigned int length);
void print_int(int *p, unsigned int length);

void print_logo() {
	println("DJun.OS", 7);
}

void print8bytes(int value) {
	char buf[25] = {0};
	buf[7] = TOCH((unsigned char) (value & 0x0f));
	buf[6] = TOCH((unsigned char) ((value >> 4) & 0x0f));
	buf[5] = TOCH((unsigned char) ((value >> 8) & 0x0f));
	buf[4] = TOCH((unsigned char) ((value >> 12) & 0x0f));
	buf[3] = TOCH((unsigned char) ((value >> 16) & 0x0f));
	buf[2] = TOCH((unsigned char) ((value >> 20) & 0x0f));
	buf[1] = TOCH((unsigned char) ((value >> 24) & 0x0f));
	buf[0] = TOCH((unsigned char) ((value >> 28) & 0x0f));
	println(buf, 8);
}

void print_int(int *p, unsigned int length) {
	for (unsigned int i = 0; i < length; i++) {
		print("0x", 2);
		print8bytes(p[i]);
	}
}

void clear() {
	char *p_vga = (char *) MEMORY_VGA;
	for (unsigned int j = 0; j < VGA_HEIGHT; j++) {
		for (unsigned int i = 0; i < VGA_WIDTH; i++) {
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

void println(char *ptr, unsigned int length) {
	print(ptr, length);
	print("\n", 1);
}