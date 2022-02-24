all: image_write image_create gdt

image_write: image_create gdt
	@echo "-- write image"
	@dd if=gdt of=disk.img >/dev/null 2>&1

image_create:
	@echo "-- create image"
	@qemu-img create disk.img 10M >/dev/null 2>&1

gdt:
	@echo "-- compile"
	@nasm mbr.nasm -o gdt

clean: 
	@echo "-- clean build file"
	@rm -rf gdt disk.img
