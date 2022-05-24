# NOTE: I cannot reproduce the case when write(2) writes less than `count` bytes.

# ref:
#
# https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/entry/syscalls/syscall_64.tbl
#
.equ SYS_read,  0
.equ SYS_write, 1
.equ SYS_open,  2
.equ SYS_close, 3
.equ SYS_exit,  60

# ref:
#
# https://git.musl-libc.org/cgit/musl/tree/include/fcntl.h
# https://git.musl-libc.org/cgit/musl/tree/arch/generic/bits/fcntl.h
#
.equ O_RDONLY,   00
.equ O_WRONLY,   01
.equ O_CREAT,  0100
.equ O_TRUNC, 01000

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

_start:
	mov %rsp, %rbp
	sub $32, %rsp

	movq $0, -8(%rbp)  # errmsg
	movq $0, -16(%rbp) # errmsglen
	movq $0, -24(%rbp) # input fd
	movq $0, -32(%rbp) # output fd

	cmp $1, (%rbp)
	je use_standard_streams

	cmp $3, (%rbp)
	je use_files

	movq $ERR_bad_args, -8(%rbp)
	movq $ERR_bad_args_len, -16(%rbp)
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
	mov %rax, -24(%rbp)

	mov $SYS_open, %rax
	mov 24(%rbp),  %rdi
	mov $O_CREAT,  %rsi
	or $O_WRONLY,  %rsi
	or $O_TRUNC,   %rsi
	mov $0666,     %rdx
	syscall
	cmp $0, %rax
	jl file_not_open
	mov %rax, -32(%rbp)

	push -32(%rbp)
	push -24(%rbp)
	call ioToLower
	add $16, %rsp

	mov $SYS_close, %rax
	mov -24(%rbp),  %rdi
	syscall

	mov $SYS_close, %rax
	mov -32(%rbp),  %rdi
	syscall

	jmp goodbye

file_not_open:
	movq $ERR_file_not_open, -8(%rbp)
	movq $ERR_file_not_open_len, -16(%rbp)
	jmp failure

goodbye:
	mov $SYS_exit, %rax
	mov $0,        %rdi
	syscall

failure:
	mov $SYS_write, %rax
	mov $2,         %rdi
	mov -8(%rbp),   %rsi
	mov -16(%rbp),  %rdx
	syscall

	mov $SYS_exit, %rax
	mov $1,        %rdi
	syscall

# args:
#
# 16(%rbp)  input fd
# 24(%rbp)  output fd
#
.type ioToLower, @function
ioToLower:
	push %rbp
	mov %rsp, %rbp
	sub $8, %rsp

	movq $0, -8(%rbp) # nread

ioloop:
	mov $SYS_read, %rax
	mov 16(%rbp),  %rdi
	mov $BUF,      %rsi
	mov $NBUF,     %rdx
	syscall
	mov %rax, -8(%rbp)

	cmp $0, -8(%rbp)
	je ioloopStop

	push -8(%rbp)
	push $BUF
	call strToLower
	add $16, %rsp

	mov $SYS_write, %rax
	mov 24(%rbp),   %rdi
	mov $BUF,       %rsi
	mov -8(%rbp),   %rdx
	syscall

	jmp ioloop
ioloopStop:
	mov %rbp, %rsp
	pop %rbp
	ret

# args:
#
# 16(%rbp)  str
# 24(%rbp)  len
#
# registers used:
#
# r12  str
# r13  i
#
.type strToLower, @function
strToLower:
	push %rbp
	mov %rsp, %rbp

	mov 16(%rbp), %r12

	mov $0, %r13
strToLowerLoop:
	cmp 24(%rbp), %r13
	jge strToLowerLoopStop

	cmpb $'A', (%r12, %r13, 1)
	jl strToLowerLoopContinue
	cmpb $'Z', (%r12, %r13, 1)
	jg strToLowerLoopContinue

	sub $'A', (%r12, %r13, 1)
	add $'a', (%r12, %r13, 1)

strToLowerLoopContinue:
	inc %r13
	jmp strToLowerLoop
strToLowerLoopStop:

	mov %rbp, %rsp
	pop %rbp
	ret