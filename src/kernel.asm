[BITS 16]
[ORG 0x7c00]
mov ah, 0x0e ; display char
mov al, 'k'
int 0x10 ; print k(ernel)
main:
	jmp main
db "somestring123123"