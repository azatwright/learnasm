.section .text
.globl _start

_start:
	mov $60, %rax # SYS_exit
	mov $23, %rdi # status
	syscall
