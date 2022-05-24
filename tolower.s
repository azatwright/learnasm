# NOTE: I cannot reproduce the case when write(2) writes less than `count` bytes.

.equ SYS_read,  0
.equ SYS_write, 1
.equ SYS_exit,  60

.equ NBUF, 5

.section .bss
.lcomm BUF, NBUF

.section .text
.globl _start

_start:
	mov %rsp, %rbp
	sub $16, %rsp

	movq $0, -8(%rbp)  # nread
	movq $0, -16(%rbp) # i

mainloop:
	mov $SYS_read, %rax
	mov $0,        %rdi
	mov $BUF,      %rsi
	mov $NBUF,     %rdx
	syscall
	mov %rax, -8(%rbp)

	cmp $0, -8(%rbp)
	je mainloopStop

	movq $0, -16(%rbp)
strconvLoop:
	mov -16(%rbp), %rax
	cmp -8(%rbp), %rax
	jge strcovnLoopStop

	cmpb $65, BUF(, %rax, 1)
	jl strconvLoopContinue
	cmpb $90, BUF(, %rax, 1)
	jg strconvLoopContinue

	sub $65, BUF(, %rax, 1)
	add $97, BUF(, %rax, 1)

strconvLoopContinue:
	incq -16(%rbp)
	jmp strconvLoop

strcovnLoopStop:
	mov $SYS_write, %rax
	mov $1,         %rdi
	mov $BUF,       %rsi
	mov -8(%rbp),   %rdx
	syscall

	jmp mainloop
mainloopStop:
	mov $SYS_exit, %rax
	mov $0,        %rdi
	syscall