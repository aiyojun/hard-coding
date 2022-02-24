MAGIC equ 0x1badb002
FLAGS equ 0x00

	section .text

grubBoot:
	dd MAGIC
	dd FLAGS
	dd -(MAGIC + FLAGS)

; -----------------------------------------------
; Strange grubBoot!
; I find the following bytes by disassembly!
; After that, I find the writing way of grubBoot!
; db 0x02,0xb0,0xad,0x1b
; db 0x00,0x00,0x00,0x00
; db 0xfe,0x4f,0x52,0xe4
; -----------------------------------------------

	global _start
	extern kmain
_start:
	; cli
	call kmain
	hlt