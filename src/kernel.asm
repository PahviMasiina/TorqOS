[BITS 16]
[ORG 0x7e00]

mov ah, 0x0e ; func = display char
mov al, 'k' ; char k (from word kernel)
int 0x10 ; perform bios video service

main:
	jmp main