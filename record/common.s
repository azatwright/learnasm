.include "def.s"
.include "linux_64.s"

.section .text

.type writeUser, @function
.globl writeUser
.set _fd, 16
.set _buf, 24
writeUser:
	push %rbp
	mov %rsp, %rbp

	mov $SYS_write, %rax
	mov _fd(%rbp),  %rdi
	mov _buf(%rbp), %rsi
	mov $USER_SIZE, %rdx
	syscall

	mov %rbp, %rsp
	pop %rbp
	ret

.type readUser, @function
.globl readUser
.set _fd, 16
.set _buf, 24
readUser:
	push %rbp
	mov %rsp, %rbp

	mov $SYS_read,  %rax
	mov _fd(%rbp),  %rdi
	mov _buf(%rbp), %rsi
	mov $USER_SIZE, %rdx
	syscall

	mov %rbp, %rsp
	push %rbp
	ret