[BITS 32]
[ORG 0x7e00]

;call putchar
jmp main
main:
	;hlt ; disabling causes crash
	jmp main
	
; USEFUL FUNCTIONS
	
putchar:
	
	mov byte [0x000b8000], 'X' ; puts 'X' (as a byte (obv)) into first address of video memory chars
	mov byte [0x000b8001], 0x10 ; colour (as a byte (obv))
	
	ret ; return

