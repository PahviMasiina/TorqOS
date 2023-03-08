[BITS 32]
[ORG 0x7e00]

;int 0x16 ; crash test
call putchar
;mov byte [0x000b8000], 'X' ; puts 'X' (as a byte (obv)) into first address of video memory chars
;mov byte [0x000b8001], 0x10 ; colour (as a byte (obv))

main:

	;mov ah, 0x0e ; func = display char ; KERNEL WAS TOO BIG
	;mov al, 'b' ; char b (from word bootloader)
	;int 0x10 ; perform bios video service
	
	jmp main
	
; USEFUL FUNCTIONS
	
putchar:
	
	;int 0x16 ; crash test
	
	mov byte [0x000b8000], 'X' ; puts 'X' (as a byte (obv)) into first address of video memory chars
	mov byte [0x000b8001], 0x10 ; colour (as a byte (obv))
	
	ret ; return

