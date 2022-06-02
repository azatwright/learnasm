.section .text
.globl _start

_start:
	push $4
	call lib_fact
	add $8, %rsp

	push %rax
	call sys_exit
