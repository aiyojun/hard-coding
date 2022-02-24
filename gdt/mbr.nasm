;;; Memory limitation: 512 bytes. Code start from 0x0000:0x7c00.
;;; Tasks: 1. Copy the next program from disk.
;;;        2. 

	org 07c00h

	jmp _start

; GDT begin
; 
; GDT end

	bits 16

_start:
	mov ax, 0x5000
	mov ss, ax
	mov sp, 0x08
	mov bp, sp
	mov ax, 0xa9bc
	push ax
	push ax
	jmp $

times 510-($-$$) db 0
    db 0x55,0xaa