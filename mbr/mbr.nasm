	jmp _start

_start:
	mov ax, 0x1000
	mov ss, ax
	mov ax, 0
	mov bp, ax
	mov sp, ax
	call clear
	mov ax, 0xb800
	mov es, ax
	mov byte [es:0x00], 'H'
	mov byte [es:0x01], 0x07
	mov byte [es:0x02], 'e'
	mov byte [es:0x03], 0x07
	mov byte [es:0x04], 'l'
	mov byte [es:0x05], 0x07
	mov byte [es:0x06], 'l'
	mov byte [es:0x07], 0x07
	mov byte [es:0x08], 'o'
	mov byte [es:0x09], 0x07
	mov byte [es:0x0a], ' '
	mov byte [es:0x0b], 0x07
	mov byte [es:0x0c], 'W'
	mov byte [es:0x0d], 0x07
	mov byte [es:0x0e], 'o'
	mov byte [es:0x0f], 0x07
	mov byte [es:0x10], 'r'
	mov byte [es:0x11], 0x07
	mov byte [es:0x12], 'l'
	mov byte [es:0x13], 0x07
	mov byte [es:0x14], 'd'
	mov byte [es:0x15], 0x07
	mov byte [es:0x16], '!'
	mov byte [es:0x17], 0x07
	mov ax, 0x41
	push ax
	pop ax
	mov byte [es:0x18], al
	mov byte [es:0x19], 0x07
	mov byte [es:0x1a], ah
	mov byte [es:0x1b], 0x07

@1:
    jmp @1


clear:
    mov ah, 0x06
    mov al, 0   ;清窗口
    mov ch, 0   ;左上角的行号
    mov cl, 0   ;左上角的列号
    mov dh, 25  ;右下角的行号
    mov dl, 80  ;右下角的行号
    mov bh, 0x07;属性为蓝底白字
    int 0x10
    ret

    times 510-($-$$) db 0
    db 0x55,0xaa