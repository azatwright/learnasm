.section .text
.globl _start

_start:
	push $4
	call lib_fact
	add $8, %rsp

	push %rax

	mov $60, %rax    # SYS_exit
	mov (%rsp), %rdi # status
	syscall
	push (%rsp)
