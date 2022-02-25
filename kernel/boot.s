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
extern print
extern println
extern print_logo
extern print8bytes
extern print_int

startup:
	; cld
	; Here, I can't change value of esp! Why???
	; And it's sometimes!!!
	mov esp, 0x50000
	mov ebp, esp

	call clear
	call print_logo

	push L_START_LEN
	push L_START
	call print
	add esp, 0x8
	xor eax, eax
	mov eax, startup
	push eax
	call print8bytes
	add esp, 0x4

	push 6
	push L_ESP
	call print
	add esp, 0x8
	xor eax, eax
	mov eax, esp
	push eax
	call print8bytes
	add esp, 0x4

	push 6
	push L_ESP
	call print
	add esp, 0x8
	xor eax, eax
	mov eax, esp
	push eax
	call print8bytes
	add esp, 0x4

	push 6
	push L_EBP
	call print
	add esp, 0x8
	xor eax, eax
	mov eax, ebp
	push eax
	call print8bytes
	add esp, 0x4

	push L_CS_LEN
	push L_CS
	call print
	add esp, 0x8
	xor eax, eax
	mov ax, cs
	push eax
	call print8bytes
	add esp, 0x4

	push 6
	push L_SS
	call print
	add esp, 0x8
	xor eax, eax
	mov ax, cs
	push eax
	call print8bytes
	add esp, 0x4

	push 6
	push L_DS
	call print
	add esp, 0x8
	xor eax, eax
	mov ax, cs
	push eax
	call print8bytes
	add esp, 0x4

	push 6
	push L_ES
	call print
	add esp, 0x8
	xor eax, eax
	mov ax, es
	push eax
	call print8bytes
	add esp, 0x4

	push 6
	push L_GS
	call print
	add esp, 0x8
	xor eax, eax
	mov ax, gs
	push eax
	call print8bytes
	add esp, 0x4

	push 6
	push L_CR0
	call print
	add esp, 0x8
	xor eax, eax
	mov eax, cr0
	push eax
	call print8bytes
	add esp, 0x4

	push 6
	push L_A20
	call print
	add esp, 0x8
	xor eax, eax
	in al, 0x92
	push eax
	call print8bytes
	add esp, 0x4

	mov eax, [ask_addr_begin]
	push eax
	mov eax, [ask_addr_begin + 1]
	push eax
	mov eax, [ask_addr_begin + 2]
	push eax
	mov eax, [ask_addr_begin + 3]
	push eax
	push 4
	mov eax, esp
	add eax, 4
	push eax
	call print_int
	add esp, 24

	hlt

section .data
L_CS:  db " cs:0x"
L_CS_LEN equ $ - L_CS
L_SS:  db " ss:0x"
L_DS:  db " ds:0x"
L_ES:  db " es:0x"
L_GS:  db " gs:0x"
L_ESP: db "esp:0x"
L_EBP: db "ebp:0x"
L_CR0: db "cr0:0x"
L_A20: db "A20:0x"
L_MAG: db "MAGIC:0x"
L_START: db "start address:0x"
L_START_LEN equ $ - L_START

ask_addr_begin equ 0x8000


