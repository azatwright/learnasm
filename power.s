.section .text
.globl _start

_start:
	push $3
	push $2
	call power # pow(2 3)
	add $16, %rsp
	push %rax

	push $4
	push $3
	call power # pow(3 4)
	add $16, %rsp

	# sum
	add %rax, (%rsp)

	mov $60,    %rax # SYS_exit
	mov (%rsp), %rdi # status
	syscall

# registers used:
#
# %r8   base
# %r9   power
# %r10  current result
# %rax  return
#
# args:
#
# 16(%rsp)  base
# 24(%rsp)  power
#
.type power, @function
power:
	push %rbp
	mov %rsp, %rbp

	mov 16(%rbp), %r8
	mov 24(%rbp), %r9
	mov %r8, %r10

powerLoop:
	cmp $1, %r9
	je powerLoopStop
	imul %r8, %r10
	dec %r9
	jmp powerLoop
powerLoopStop:
	mov %r10, %rax
	mov %rbp, %rsp
	pop %rbp
	ret