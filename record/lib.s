.include "linux_64.s"

.section .text

# registers used:
#
# rax  length of the string, returned
# r12  string address, preserved
#
.type strlen, @function
.globl strlen
.set _s, 16
strlen:
	push %rbp
	mov %rsp, %rbp

	# preserve registers
	push %r12

	mov $0, %rax
	mov _s(%rbp), %r12
strlenLoop:
	cmpb $0, (%r12, %rax, 1)
	je strlenLoopEnd
	inc %rax
	jmp strlenLoop

strlenLoopEnd:

	# restore registers
	pop %r12

	mov %rbp, %rsp
	pop %rbp
	ret

.type read2, @function
.globl read2
.set _fd, 16
.set _buf, 24
.set _count, 32
read2:
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

.type write2, @function
.globl write2
.set _fd, 16
.set _buf, 24
.set _count, 32
write2:
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