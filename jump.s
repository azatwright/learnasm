.section .text
.globl _start

_start:
	mov $40, %r8

	mov $39, %r9
	cmp %r8, %r9
	jl end       # if (r9 < r8)

	mov $222, %r9
end:
	mov $60, %rax
	mov %r9, %rdi
	mov $0, %r8
	mov $0, %r9
	syscall
