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
	push $1
	push $0
	call ioToLower
	add $16, %rsp

	mov $SYS_exit, %rax
	mov $0,        %rdi
	syscall

# args:
#
# 16(%rbp)  input fd
# 24(%rbp)  output fd
#
.type ioToLower, @function
ioToLower:
	push %rbp
	mov %rsp, %rbp
	sub $8, %rsp

	movq $0, -8(%rbp) # nread

ioloop:
	mov $SYS_read, %rax
	mov 16(%rbp),  %rdi
	mov $BUF,      %rsi
	mov $NBUF,     %rdx
	syscall
	mov %rax, -8(%rbp)

	cmp $0, -8(%rbp)
	je ioloopStop

	push -8(%rbp)
	push $BUF
	call strToLower
	add $16, %rsp

	mov $SYS_write, %rax
	mov 24(%rbp),   %rdi
	mov $BUF,       %rsi
	mov -8(%rbp),   %rdx
	syscall

	jmp ioloop
ioloopStop:
	mov %rbp, %rsp
	pop %rbp
	ret

# args:
#
# 16(%rbp)  str
# 24(%rbp)  len
#
# registers used:
#
# r12  str
# r13  i
#
.type strToLower, @function
strToLower:
	push %rbp
	mov %rsp, %rbp

	mov 16(%rbp), %r12

	mov $0, %r13
strToLowerLoop:
	cmp 24(%rbp), %r13
	jge strToLowerLoopStop

	cmpb $'A', (%r12, %r13, 1)
	jl strToLowerLoopContinue
	cmpb $'Z', (%r12, %r13, 1)
	jg strToLowerLoopContinue

	sub $'A', (%r12, %r13, 1)
	add $'a', (%r12, %r13, 1)

strToLowerLoopContinue:
	inc %r13
	jmp strToLowerLoop
strToLowerLoopStop:

	mov %rbp, %rsp
	pop %rbp
	ret