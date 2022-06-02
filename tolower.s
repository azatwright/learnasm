# NOTE: I cannot reproduce the case when write(2) writes less than `count` bytes.

.include "linux_64.s"

.equ NBUF, 5

.section .bss
.lcomm BUF, NBUF

.section .data

ERR_bad_args: .ascii "incorrect command line argument usage\n"
ERR_bad_args_len = . - ERR_bad_args

ERR_file_not_open: .ascii "failed to open file\n"
ERR_file_not_open_len = . - ERR_file_not_open

.section .text
.globl _start

.set _errmsg,    -8
.set _errmsglen, -16
.set _infd,      -24
.set _outfd,     -32
_start:
	mov %rsp, %rbp
	sub $32, %rsp

	movq $0, _errmsg(%rbp)
	movq $0, _errmsglen(%rbp)
	movq $0, _infd(%rbp)
	movq $0, _outfd(%rbp)

	cmp $1, (%rbp)
	je use_standard_streams

	cmp $3, (%rbp)
	je use_files

	movq $ERR_bad_args, _errmsg(%rbp)
	movq $ERR_bad_args_len, _errmsglen(%rbp)
	jmp failure

use_standard_streams:
	push $1
	push $0
	call ioToLower
	add $16, %rsp
	jmp goodbye

use_files:
	mov $SYS_open, %rax
	mov 16(%rbp),  %rdi
	mov $O_RDONLY, %rsi
	mov $0,        %rdx
	syscall
	cmp $0, %rax
	jl file_not_open
	mov %rax, _infd(%rbp)

	mov $SYS_open, %rax
	mov 24(%rbp),  %rdi
	mov $O_CREAT,  %rsi
	or $O_WRONLY,  %rsi
	or $O_TRUNC,   %rsi
	mov $0666,     %rdx
	syscall
	cmp $0, %rax
	jl file_not_open
	mov %rax, _outfd(%rbp)

	push _outfd(%rbp)
	push _infd(%rbp)
	call ioToLower
	add $16, %rsp

	mov $SYS_close, %rax
	mov _infd(%rbp),  %rdi
	syscall

	mov $SYS_close, %rax
	mov _outfd(%rbp),  %rdi
	syscall

	jmp goodbye

file_not_open:
	movq $ERR_file_not_open, _errmsg(%rbp)
	movq $ERR_file_not_open_len, _errmsglen(%rbp)
	jmp failure

goodbye:
	mov $SYS_exit, %rax
	mov $0,        %rdi
	syscall

failure:
	mov $SYS_write,       %rax
	mov $2,               %rdi
	mov _errmsg(%rbp),    %rsi
	mov _errmsglen(%rbp), %rdx
	syscall

	mov $SYS_exit, %rax
	mov $1,        %rdi
	syscall

.set _infd, 16
.set _outfd, 24
.set _nread, -8
.type ioToLower, @function
ioToLower:
	push %rbp
	mov %rsp, %rbp
	sub $8, %rsp

	movq $0, _nread(%rbp)

ioloop:
	mov $SYS_read,   %rax
	mov _infd(%rbp), %rdi
	mov $BUF,        %rsi
	mov $NBUF,       %rdx
	syscall
	mov %rax, _nread(%rbp)

	cmp $0, _nread(%rbp)
	je ioloopStop

	push _nread(%rbp)
	push $BUF
	call lib_tolower
	add $16, %rsp

	mov $SYS_write,   %rax
	mov _outfd(%rbp), %rdi
	mov $BUF,         %rsi
	mov _nread(%rbp), %rdx
	syscall

	jmp ioloop
ioloopStop:
	mov %rbp, %rsp
	pop %rbp
	ret
