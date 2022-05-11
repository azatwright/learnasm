.section .data
.section .text
.globl _start
_start:
	mov $60, %rax
	mov $23, %rdi
	syscall