.section .text

.globl _start
.set _sum, -8
_start:
	mov %rsp, %rbp
	sub $8, %rsp

	movq $0, _sum(%rbp)

	push $3 # power
	push $2 # base
	call lib_power
	add $16, %rsp
	
	add %rax, _sum(%rbp)

	push $4 # power
	push $3 # base
	call lib_power
	add $16, %rsp

	add %rax, _sum(%rbp)

	mov $60,        %rax # SYS_exit
	mov _sum(%rbp), %rdi # status
	syscall
