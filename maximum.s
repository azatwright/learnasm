.section .data

arr:
	.quad 12, 5, -20, 22, 5, 9, 19, 9810, 8, 19, 70, 0
negatives:
	.quad -7, -59, -15, -83, -1, -45, 0

.section .text
.globl _start

_start:
	push $arr
	call lib_arrmaxq
	add $8, %rsp

	push %rax
	call sys_exit
