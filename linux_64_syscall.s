.include "linux_64.s"

.section .text

.type sys_read, @function
.globl sys_read
.set _fd, 16
.set _buf, 24
.set _count, 32
sys_read:
	push %rbp
	mov %rsp, %rbp

	mov $SYS_read,    %rax
	mov _fd(%rbp),    %rdi
	mov _buf(%rbp),   %rsi
	mov _count(%rbp), %rdx
	syscall

	mov %rbp, %rsp
	pop %rbp
	ret

.type sys_write, @function
.globl sys_write
.set _fd, 16
.set _buf, 24
.set _count, 32
sys_write:
	push %rbp
	mov %rsp, %rbp

	mov $SYS_write,   %rax
	mov _fd(%rbp),    %rdi
	mov _buf(%rbp),   %rsi
	mov _count(%rbp), %rdx
	syscall

	mov %rbp, %rsp
	pop %rbp
	ret

.type sys_open, @function
.globl sys_open
.set _pathname, 16
.set _flags, 24
.set _mode, 32
sys_open:
	push %rbp
	mov %rsp, %rbp

	mov $SYS_open,       %rax
	mov _pathname(%rbp), %rdi
	mov _flags(%rbp),    %rsi
	mov _mode(%rbp),     %rdx
	syscall

	mov %rbp, %rsp
	pop %rbp
	ret

.type sys_close, @function
.globl sys_close
.set _fd, 16
sys_close:
	push %rbp
	mov %rsp, %rbp

	mov $SYS_close, %rax
	mov _fd(%rbp),  %rdi
	syscall

	mov %rbp, %rsp
	pop %rbp
	ret

.type sys_lseek, @function
.globl sys_lseek
.set _fd, 16
.set _offset, 24
.set _whence, 32
sys_lseek:
	push %rbp
	mov %rsp, %rbp

	mov $SYS_lseek,    %rax
	mov _fd(%rbp),     %rdi
	mov _offset(%rbp), %rsi
	mov _whence(%rbp), %rdx
	syscall

	mov %rbp, %rsp
	pop %rbp
	ret

.type sys_exit, @function
.globl sys_exit
.set _status, 16
sys_exit:
	push %rbp
	mov %rsp, %rbp

	mov $SYS_exit,     %rax
	mov _status(%rbp), %rdi
	syscall
