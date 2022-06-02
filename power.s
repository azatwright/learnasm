.section .text
.globl _start

_start:
	push $3 # power
	push $2 # base
	call lib_power
	add $16, %rsp
	push %rax

	push $4 # power
	push $3 # base
	call lib_power
	add $16, %rsp

	# sum
	add %rax, (%rsp)

	mov $60,    %rax # SYS_exit
	mov (%rsp), %rdi # status
	syscall
