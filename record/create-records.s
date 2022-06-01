.include "def.s"
.include "linux_64.s"

.section .data

file: .ascii "records.bin\0"

azat:
	.ascii "Azat"
	.rept USER_NAME_SIZE - (. - azat)
		.byte 0
	.endr
	.ascii "Wright"
	.rept USER_NAME_SIZE+USER_SURNAME_SIZE - (. - azat)
		.byte 0
	.endr
	.ascii "4899 Sumner Street\nLos Angeles\nCA\n"
	.rept USER_NAME_SIZE+USER_SURNAME_SIZE+USER_ADDRESS_SIZE - (. - azat)
		.byte 0
	.endr
	.quad 23

linus:
	.ascii "Linus"
	.rept USER_NAME_SIZE - (. - linus)
		.byte 0
	.endr
	.ascii "Torvalds"
	.rept USER_NAME_SIZE+USER_SURNAME_SIZE - (. - linus)
		.byte 0
	.endr
	.ascii "2831 Beechwood Avenue\nFreehold\nNJ\n"
	.rept USER_NAME_SIZE+USER_SURNAME_SIZE+USER_ADDRESS_SIZE - (. - linus)
		.byte 0
	.endr
	.quad 52

.section .text

.globl _start
.set _fd, -8
_start:
	mov %rsp, %rbp
	sub $8, %rsp

	movq $0, _fd(%rbp)

	mov $SYS_open, %rax
	mov $file,     %rdi
	mov $O_WRONLY, %rsi
	or $O_CREAT,   %rsi
	or $O_TRUNC,   %rsi
	mov $0666,     %rdx
	syscall
	mov %rax, _fd(%rbp)

	push $USER_SIZE
	push $azat
	push _fd(%rbp)
	call sys_write
	add $24, %rsp

	push $USER_SIZE
	push $linus
	push _fd(%rbp)
	call sys_write
	add $24, %rsp

	mov $SYS_close, %rax
	mov _fd(%rbp),  %rdi
	syscall

	mov $SYS_exit, %rax
	mov $0,        %rdi
	syscall
