# Note that for a .long array the following instructions must be used:
#
#         mov arr(%r8, %r9, 4), %r10d
#         cmp %r10d, (%r8, %rax, 4)
#
# I have no idea why is the 'd' suffix necessary.

.section .data

arr:
	.quad 12, 5, -20, 22, 5, 9, 19, 9810, 8, 19, 70, 0
negatives:
	.quad -7, -59, -15, -83, -1, -45, 0

.section .text
.globl _start

_start:
	push $negatives
	call arrmax
	add $8, %rsp
	push %rax

	mov $60, %rax
	mov (%rsp), %rdi
	syscall

# registers used:
#
# r8   array address
# r9   index
# r10  current value
# rax  max value's index & return
#
# args:
#
# 16(%rsp)  array address
#
.type arrmax, @function
arrmax:
	push %rbp
	mov %rsp, %rbp
	mov 16(%rbp), %r8

	mov $0, %r9
	mov $0, %rax

arrmaxLoop:
	mov (%r8, %r9, 8), %r10
	cmp $0, %r10
	je arrmaxEnd
	cmp %r10, (%r8, %rax, 8)
	jl arrmaxLoopNewMax
	inc %r9
	jmp arrmaxLoop
arrmaxLoopNewMax:
	mov %r9, %rax
	inc %r9
	jmp arrmaxLoop

arrmaxEnd:
	mov %rbp, %rsp
	pop %rbp
	ret
