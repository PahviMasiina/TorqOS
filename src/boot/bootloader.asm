cli ; no interrupts anymore

mov ah, 0x0E ; func = display char
mov al, 'b' ; char b (from word bootloader)
int 0x10 ; perform bios video service

mov ah, 0x41 ; verify extended services
mov bx, 0x55AA
mov dl, 0x80 ; 1st hard drive
int 0x13 ; perform bios extended disk services check

cmp ah, 0 ; compare error code register to zero
je onerror ; jump if error to onerror

push dword 0x00 ; push 4 empty bytes
push dword 0x00000001 ; dap "skipped" sectors, pt2, REVERSE ORDER
push dword 0x00000000 ; dap "skipped" sectors, pt1, REVERSE ORDER
push dword 0x00007e00 ; dap start memory address (right after bootloader), REVERSE ORDER
push word 0x7f ; dap copied segments (127 pcs), REVERSE ORDER, MAY NOT WORK IN SOME PHOENIX BIOSES
push byte 0x00 ; dap reserved, REVERSE ORDER
push byte 0x10 ; dap size (16 bytes), REVERSE ORDER

mov ah, 0x42 ; read sectors
mov dl, 0x80 ; 1st hard drive
mov si, sp ; move stack pointer to si
int 0x13 ; perform bios disk services

jmp 0x00007e00 ; jump to the kernel

onerror:

	mov ah, 0x0E ; func = display char
	mov al, 'e' ; char e (from word error)
	int 0x10 ; perform bios video service

	jmp main
	
main:
    jmp main
 
times 440-($-$$) db 0 ; fills the rest of the bootloader with zeroes
db 0x00 ; disk signature = 1 (4 byte)
db 0x00
db 0x00
db 0x01
db 0x5A ; reserved?, set to read only
db 0x5A
times 16 db 0 ; bootsector 1
times 16 db 0 ; bootsector 2
times 16 db 0 ; bootsector 3
times 16 db 0 ; bootsector 4
db 0x55 ; adds "valid bootsector" identifiers
db 0xAA