# registers used:
#
# %r8 - index
# %r9 - current value
# %r10 - max value's index

# Why is `arr(, $0, 4)` invalid?

# Note that for a .long array the following instruction must be used
# in order to correctly access its elements:
#
#         mov arr(, r8, 4), %r9d

.section .data

arr:
	.quad 12, 5, -20, 22, 5, 9, 19, 9810, 8, 19, 70, 0

.section .text

.globl _start

_start:
	mov $0, %r8
	mov $0, %r10

loopStart:
	mov arr(, %r8, 8), %r9
	cmp $0, %r9
	je loopStop
	cmp %r9, arr(, %r10, 8)
	jl loopNewMax
	inc %r8
	jmp loopStart
loopNewMax:
	mov %r8, %r10
	inc %r8
	jmp loopStart
loopStop:
	mov $60, %rax
	mov %r10, %rdi
	mov $0, %r8
	mov $0, %r9
	mov $0, %r10
	syscall