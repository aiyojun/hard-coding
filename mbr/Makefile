all: image_write image_create mbr

image_write: image_create mbr
	@echo "-- write image"
	@dd if=mbr of=disk.img >/dev/null 2>&1

image_create:
	@echo "-- create image"
	@qemu-img create disk.img 10M >/dev/null 2>&1

mbr:
	@echo "-- compile"
	@nasm mbr.nasm

clean: 
	@echo "-- clean build file"
	@rm -rf mbr disk.img
