[BITS 16]
[ORG 0x7c00]

segment .code

cli ; no interrupts anymore

mov ah, 0x0e ; func = display char ; KERNEL WAS TOO BIG
mov al, 'b' ; char b (from word bootloader)
int 0x10 ; perform bios video service

mov ah, 0x41 ; verify extended services
mov bx, 0x55aa
mov dl, 0x80 ; 1st hard drive
int 0x13 ; perform bios extended disk services check

cmp ah, 0x00 ; compare error code register to zero ; KERNEL WAS TOO BIG
je onError ; jump if error to onerror

mov ah, 0x42 ; read sectors
mov dl, 0x80 ; 1st hard drive
mov si, dap ; move dap to si
int 0x13 ; perform bios disk services

mov ah, 0x00 ; func = set video mode(clear screen, reset video output)
mov al, 0x03 ; video mode (check http://www.columbia.edu/~em36/wpdos/videomodes.txt), 80x25 text mode
int 0x10 ; perform bios video service

lgdt [gdt] ; load gdt

mov eax, cr0  ; move control register to eax
or al, 1 ; set PE (Protection Enable) bit in CR0 (Control Register 0)
mov cr0, eax ; move eax to control register

jmp 0x7e00 ; jump to the kernel

onError:

	mov ah, 0x0e ; func = display char
	mov al, 'e' ; char e (from word error)
	int 0x10 ; perform bios video service

	jmp main
	
main:
    jmp main

segment .data ; MUST BE BEFORE THE "FILLER" PART

align 4
dap:
    .dapSize db 10h ; dap size (16 bytes)
    .dapZero db 0 ; dap reserved
    .dapSectors dw 0x7f ; dap copied 127 segments
    .dapOffset dw 0 ; zero offset?
    .dapSegment dw 0x7e0 ; dap start memory address (right after bootloader)
    .dapStartLow dd 0x00000001 ; dap "skipped" sectors, pt1
    .dapStartHigh dd 0x00000000 ; dap "skipped" sectors, pt2

align 4
gdt:
    .nullDescriptorBase dd 0x00000000 ; null descriptor table, REQUIRED PERHAPS
	.nullDescriptorLimit dd 0x00000000
	.nullDescriptorAccessByte db 0x00
	.nullDescriptorFlags db 0x00
	
	.kernelCodeBase dd 0x00400000 ; kernel mode code segment table
	.kernelCodeLimit dd 0x003fffff
	.kernelCodeAccessByte db 0x9a
	.kernelCodeFlags db 0x0c
	
	.kernelDataBase dd 0x00800000 ; kernel mode data segment table
	.kernelDataLimit dd 0x003fffff
	.kernelDataAccessByte db 0x92
    .kernelDataFlags db 0x00
	
	.taskStateBase dd 0x009b0000 ; task state segment table
	.taskStateLimit dd 0x003fffff ; maybe bit too small
	.taskStateAccessByte db 0x89 ; 
    .taskStateFlags db 0x00

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

