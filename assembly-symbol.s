.section .data

str: .ascii "/\n"

.section .text
.globl _start

_start:

.set chr, 'A'
	mov $str, %rax
	movb $chr, (%rax)
	call printstr

.set chr, 'B'
	mov $str, %rax
	movb $chr, (%rax)
	call printstr

.set chr, 'C'
	mov $str, %rax
	movb $chr, (%rax)
	call printstr

	mov $60, %rax
	mov $0, %rdi
	syscall

.type printstr, @function
printstr:
	push %rbp
	mov %rsp, %rbp

	mov $1, %rax
	mov $1, %rdi
	mov $str, %rsi
	mov $2, %rdx
	syscall

	mov %rbp, %rsp
	pop %rbp
	ret
