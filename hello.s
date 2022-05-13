.section .data

str: .ascii "hello, america\n"
strlen = . - str

.section .text
.globl _start

_start:
	mov $1,      %rax # SYS_write
	mov $1,      %rdi # fd
	mov $str,    %rsi # buf
	mov $strlen, %rdx # count
	syscall

	mov $60, %rax # SYS_exit
	mov $0,  %rdi # status
	syscall