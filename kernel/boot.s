MAGIC equ 0x1badb002
FLAGS equ 0x00

section .text
global startup

;grubBoot:
	dd MAGIC
	dd FLAGS
	dd -(MAGIC + FLAGS)

; -----------------------------------------------
; Strange grubBoot!
; I find the following bytes by disassembly!
; After that, I find the writing way of grubBoot!
; db 0x02,0xb0,0xad,0x1b
; db 0x00,0x00,0x00,0x00
; db 0xfe,0x4f,0x62,0xe4
; -----------------------------------------------

extern clear
extern print_logo
extern print_info
extern printbytes

startup:
	; cld
	; Here, I can't change value of esp! Why???
	; And it's sometimes!!!
	mov esp, 0x50000
	mov ebp, esp

	call clear
	call print_logo
	call print_info

	; sgdt [tmp]
	; push 0x08
	; push tmp
	; call printbytes
	; add esp, 0x08

	hlt

section .data
; tmp:
; 	db 0, 0, 0, 0, 0, 0, 0, 0