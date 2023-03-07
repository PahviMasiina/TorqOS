[BITS 16]
[ORG 0x7c00]
cli ; no interrupts anymore

mov ah, 0x0e ; func = display char
mov al, 'b' ; char b (from word bootloader)
int 0x10 ; perform bios video service

mov ah, 0x41 ; verify extended services
mov bx, 0x55aa
mov dl, 0x80 ; 1st hard drive
int 0x13 ; perform bios extended disk services check

cmp ah, 0 ; compare error code register to zero
je onerror ; jump if error to onerror

mov ah, 0x42 ; read sectors
mov dl, 0x80 ; 1st hard drive
mov si, dap ; move dap to si
int 0x13 ; perform bios disk services

jmp 0x7e00 ; jump to the kernel
;jmp main

onerror:

	mov ah, 0x0e ; func = display char
	mov al, 'e' ; char e (from word error)
	int 0x10 ; perform bios video service

	jmp main
	
main:
    jmp main

align 4
dap:
    .dapSize db 10h ; dap size (16 bytes)
    .dapZero db 0 ; dap reserved
    .dapSectors dw 0x7f ; dap copied 127 segments
    .dapOffset dw 0 ; zero offset?
    .dapSegment dw 0x7e0 ; dap start memory address (right after bootloader)
    .dapStartLow dd 0x00000001 ; dap "skipped" sectors, pt1
    .dapStartHigh dd 0x00000000 ; dap "skipped" sectors, pt2

times 440-($-$$) db 0 ; fills the rest of the bootloader with zeroes
db 0x00 ; disk signature = 1 (4 byte)
db 0x00
db 0x00
db 0x01
db 0x5a ; reserved?, set to read only
db 0x5a
times 16 db 0 ; bootsector 1
times 16 db 0 ; bootsector 2
times 16 db 0 ; bootsector 3
times 16 db 0 ; bootsector 4
db 0x55 ; adds "valid bootsector" identifiers
db 0xaa