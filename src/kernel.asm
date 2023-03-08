[BITS 32]
[ORG 0x7e00]

segment .code

call putchar

main:
	jmp main
	
; USEFUL FUNCTIONS
	
putchar:
	
	;int 0x16 ; crash test
	
	mov byte [0x000b8000], 'X' ; puts 'h' (as a byte (obv)) into first address of video memory chars
	mov byte [0x000b8001], 0x10 ; colour (as a byte (obv))
	
	ret ; return

section .data

