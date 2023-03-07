[BITS 16]
[ORG 0x7e00]

mov ah, 0x00 ; func = set video mode(clear screen, reset video output)
mov al, 0x02 ; video mode (check http://www.columbia.edu/~em36/wpdos/videomodes.txt)
int 0x10 ; perform bios video service

mov cx, 0x45 ; length, 69
mov bp, welcometext ; string
call printstring ; print welcome message

call newline ; makes newline

main:

	call keytoscreen
	
	jmp main

; Useful functions below

printstring: ; useful utility for printing strings

	mov ah, 0x13 ; func = print string
	mov al, 0x01 ; subservice, (check http://vitaly_filatov.tripod.com/ng/asm/asm_023.20.html)
	mov bh, 0x00 ; page number
	mov bl, 0x02 ; attribute, color 02 = green-on-black
	mov dh, 0x00 ; row
	mov dl, 0x00 ; column
	int 0x10 ; perform bios video service
	
	ret ; return back to the call
	
newline:

	mov ah, 0x03 ; func = get cursor pos
	mov bh, 0x00 ; page number
	int 0x10 ; perform bios video service
	
	inc dh ; increments row number

	mov ah, 0x02 ; func = set cursor pos
	mov bh, 0x00 ; page number
	mov dl, 0x00 ; column
	int 0x10 ; perform bios video service

	ret ; return back to the call

keytoscreen:
	
	mov al, 0 ; making sure it is 0
	
	mov ah, 0x00 ; func = read char, blocking
	int 0x16 ; perform bios keyboard service
	
	cmp al, 0
	je ktsend
	
	mov ah, 0x0e ; func = display char
	int 0x10 ; perform bios video service, al got "inherited" from previous step
	
	inc byte [lineptr] ; incrementing linepointer
	
	
	mov al, 0 ; resetting it to 0
	
	ktsend
	ret ; return back to the call

section .data
welcometext db "Welcome to TorqOS kernel command line utility (Tkcli), write help" ; welcoming text, max 80 chars
currentline times 80 db 0 ; current text line
lineptr

