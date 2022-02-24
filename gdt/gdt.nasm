%macro Descriptor 3
	dw %2 & 0xffff
	dw %1 & 0xffff
	db (%1 >> 16) & 0xff
	dw ((%2 >> 8) & 0xf00) | (%3 & 0xf0ff)
	db (%1 >> 24) & 0xff
%endmacro

	jmp _start


gdt_entry:
	Descriptor 0, 0, 0
descriptor_code32:
	Descriptor 0, code32_len - 1, DA_C + DA_32
descriptor_video:
	Descriptor 0xb8000, 0x07fff, DA_DRW + DA_32
descriptor_data32:
	Descriptor 0, data32_len - 1, DA_DR + DA_32
descriptor_stack32:
	Descriptor 0, stack32_top, DA_DRWA + DA_32
gdt_len equ $ - gdt_entry
gdt_ptr:
	dw gdt_len - 1
	dd 0

DA_32   equ 0x4000
DA_DR   equ 0x90
DA_DRW  equ 0x92
DA_DRWA equ 0x93
DA_C    equ 0x98
SA_TIG  equ 0
SA_RPL0 equ 0

selector_code32  equ (0x0001 << 3) + SA_TIG + SA_RPL0
selector_video   equ (0x0002 << 3) + SA_TIG + SA_RPL0
selector_data32  equ (0x0003 << 3) + SA_TIG + SA_RPL0
selector_stack32 equ (0x0004 << 3) + SA_TIG + SA_RPL0

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

	mov esi, code32
	mov edi, descriptor_code32
	call init_descriptor

	mov esi, data32
	mov edi, descriptor_data32
	call init_descriptor

	mov esi, stack32
	mov edi, descriptor_stack32
	call init_descriptor

	mov eax, 0
	mov ax, ds
	shl eax, 4
	add eax, gdt_entry
	mov dword [gdt_ptr + 2], eax

	lgdt [gdt_ptr]

	cli

	in al, 0x92
	or al, 00000010b
	out 0x92, al

	mov eax, cr0
	or eax, 0x01
	mov cr0, eax

@1:
    jmp @1

	jmp dword selector_code32:0


; init_descriptor(position: esi, descriptor_pos: edi)
init_descriptor:
	push eax
	mov eax, 0
	mov ax, cs
	shl eax, 4
	add eax, esi
	mov word [edi + 2], ax
	shr eax, 16
	mov byte [edi + 4], al
	mov byte [edi + 7], ah
	pop eax
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


code32:
	mov ax, selector_video
	mov gs, ax
	mov ax, selector_data32
	mov ds, ax
	mov ax, selector_stack32
	mov ss, ax
	mov eax, stack32_top
	mov esp, eax

	call print




;x0 equ 0
;x1 equ 0
;x2 equ 0
;x3 equ 0
;x4 equ 0
;x5 equ 0

code32_len equ $ - code32

print:
	mov byte [gs:0x00], 'H'
	mov byte [gs:0x01], 0x07
	mov byte [gs:0x02], 'e'
	mov byte [gs:0x03], 0x07
	mov byte [gs:0x04], 'l'
	mov byte [gs:0x05], 0x07
	mov byte [gs:0x06], 'l'
	mov byte [gs:0x07], 0x07
	mov byte [gs:0x08], 'o'
	mov byte [gs:0x09], 0x07
	mov byte [gs:0x0a], ' '
	mov byte [gs:0x0b], 0x07
	mov byte [gs:0x0c], 'D'
	mov byte [gs:0x0d], 0x07
	mov byte [gs:0x0e], 'J'
	mov byte [gs:0x0f], 0x07
	mov byte [gs:0x10], 'u'
	mov byte [gs:0x11], 0x07
	mov byte [gs:0x12], 'n'
	mov byte [gs:0x13], 0x07
	mov byte [gs:0x14], '!'
	mov byte [gs:0x15], 0x07
	ret

data32:
	CONTEXT db "Hello DJun!", 0
	CONTEXT_OFFSET equ $$ - CONTEXT

data32_len equ $ - data32

stack32:
	times 1024 * 4 db 0

stack32_len equ $ - stack32
stack32_top equ stack32_len - 1


	

    ;times 510-($-$$) db 0
    ;db 0x55,0xaa