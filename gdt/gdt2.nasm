%macro Descriptor 3
	dw %2 & 0xffff
	dw %1 & 0xffff
	db (%1 >> 16) & 0xff
	dw ((%2 >> 8) & 0xf00) | (%3 & 0xf0ff)
	db (%1 >> 24) & 0xff
%endmacro

DA_32   equ 0x4000
DA_DR   equ 0x90
DA_DRW  equ 0x92
DA_DRWA equ 0x93
DA_C    equ 0x98
SA_TIG  equ 0
SA_RPL0 equ 0

org 07c00h

	jmp _start

gdt_entry: 			Descriptor 0, 0, 0
descriptor_code32: 	Descriptor 0, (code32_len-1), (DA_C+DA_32)
descriptor_video: 	Descriptor 0xb8000, 0xffff, (DA_DRW+DA_32)
gdt_len equ $ - gdt_entry
gdt_ptr:
	dw gdt_len - 1
	dd 0

selector_code32 equ (0x0001<<3)+SA_TIG+SA_RPL0
selector_video equ (0x0002<<3)+SA_TIG+SA_RPL0


_start:
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
	call clear

	mov ax, 0xb800
	mov es, ax
	mov byte [es:0x00], 'A'
	mov byte [es:0x01], 0x07
	mov byte [es:0x02], 'K'
	mov byte [es:0x03], 0x07

;	xor eax, eax
;	mov edi, eax
;	mov ax, 0x7c00
;	mov di, ax

	xor eax, eax
	mov ax, cs
	shl eax, 4
	add eax, code32
;	add eax, 0x7c00
	mov word [descriptor_code32 + 2], ax
	shr eax, 16
	mov byte [descriptor_code32 + 4], al
	mov byte [descriptor_code32 + 7], ah

	mov eax, 0
	mov ax, ds
	shl eax, 4
;	add eax, 0x7c00
	add eax, gdt_entry
	mov dword [gdt_ptr + 2], eax

	lgdt [gdt_ptr]

	cli

	call enable_A20_way2

	mov eax, cr0
	or eax, 0x01
	mov cr0, eax
	;jmp $
	jmp dword selector_code32:0


enable_A20_way2:
	in al, 0x92
	or al, 00000010b ; disable: and al, 11111101b
	out 0x92, al
	ret


enable_A20:
	call wait_8042free
	mov al, 0xd1
	mov dx, 0x64
	out dx, al
	call wait_8042free
	mov al, 0xdf
	mov dx, 0x60
	out dx, al
	ret

wait_8042free:
.ll_begin:
	in al, 0x64
	test al, 0x02
	jnz .ll_begin
	ret

clear:
    mov ah, 0x06
    mov al, 0
    mov ch, 0
    mov cl, 0
    mov dh, 25
    mov dl, 80
    mov bh, 0x07
    int 0x10
    ret

_x0: dw 0

bits 32

code32:
	mov eax, selector_video
	mov gs, ax
	mov byte [gs:0x08], 'Z'
	mov byte [gs:0x09], 0x07
	mov byte [gs:0x0a], 'X'
	mov byte [gs:0x0b], 0x07
	jmp $

code32_len equ $-code32

    times 510-($-$$) db 0
    db 0x55,0xaa