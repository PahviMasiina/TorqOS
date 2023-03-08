[BITS 16]
[ORG 0x7e00]

call performBiosCalls ; performs screen reset, welcometext and waits for any key
call goProtected ; go into protected mode

main:

	

	jmp main
	
; USEFUL FUNCTIONS

performBiosCalls:

	mov ah, 0x00 ; func = set video mode(clear screen, reset video output)
	mov al, 0x02 ; video mode (check http://www.columbia.edu/~em36/wpdos/videomodes.txt)
	int 0x10 ; perform bios video service
	
	mov ah, 0x13 ; func = print string
	mov al, 0x01 ; subservice, (check http://vitaly_filatov.tripod.com/ng/asm/asm_023.20.html)
	mov bh, 0x00 ; page number
	mov bl, 0x02 ; attribute, color 02 = green-on-black
	mov dh, 0x00 ; row
	mov dl, 0x00 ; column
	mov cx, 0x36 ; length, 55
	mov bp, welcometext ; string
	int 0x10 ; perform bios video service
	
	mov ah, 0x00 ; func = read char, blocking
	int 0x16 ; perform bios keyboard service

	ret ; return

goProtected: ; go into protected mode, WORKS
	
	cli ; no interrupts anymore
	
	lgdt [gdt] ; load gdt
	
	mov eax, cr0  ; move control register to eax
	or al, 1 ; set PE (Protection Enable) bit in CR0 (Control Register 0)
	mov cr0, eax ; move eax to control register
	
	ret ; return

section .data
welcometext db "Welcome to TorqOS kernel, press any key to continue..." ; welcoming text, max 80 chars

align 4
gdt:
    .nullDescriptorBase dw 0x00000000 ; null descriptor table, REQUIRED PERHAPS
	.nullDescriptorLimit dw 0x00000000
	.nullDescriptorAccessByte db 0x00
	.nullDescriptorFlags db 0x00
	
	.kernelCodeBase dw 0x00400000 ; kernel mode code segment table
	.kernelCodeLimit dw 0x003fffff
	.kernelCodeAccessByte db 0x9a
	.kernelCodeFlags db 0x0c
	
	.kernelDataBase dw 0x00800000 ; kernel mode data segment table
	.kernelDataLimit dw 0x003fffff
	.kernelDataAccessByte db 0x92
    .kernelDataFlags db 0x00
	
	.taskStateBase dw 0x009b0000 ; task state segment table
	.taskStateLimit dw 0x003fffff ; maybe bit too small
	.taskStateAccessByte db 0x89 ; 
    .taskStateFlags db 0x00
