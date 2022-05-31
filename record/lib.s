.include "linux_64.s"

.section .text

# registers used:
#
# r12  number
# r13  s
# r14  i
#
.type itoa, @function
.globl itoa
.set _n, 16
.set _s, 24
.set _len, -8
.set _nabs, -16
itoa:
	push %rbp
	mov %rsp, %rbp
	sub $16, %rsp

	mov 16(%rbp), %r12
	mov 24(%rbp), %r13
	mov $0, %r14

	movq $0, _len(%rbp)
	mov %r12, _nabs(%rbp)

	cmp $0, %r12
	jge itoaLoop1

	movb $'-', (%r13, %r14, 1)
	incq _len(%rbp)
	imul $-1, %r12
	mov %r12, _nabs(%rbp)

itoaLoop1:
	mov $0, %rdx
	mov %r12, %rax
	mov $10, %rbx
	idiv %rbx

	incq _len(%rbp)

	mov %rax, %r12
	cmp $0, %r12
	jne itoaLoop1

	mov _nabs(%rbp), %r12
	mov _len(%rbp), %r14
	dec %r14

itoaLoop2:
	mov $0, %rdx
	mov %r12, %rax
	mov $10, %rbx
	idiv %rbx

	mov %dl, (%r13, %r14, 1)
	add $'0', (%r13, %r14, 1)
	dec %r14

	mov %rax, %r12
	cmp $0, %r12
	jne itoaLoop2

	mov _len(%rbp), %rax

	mov %rbp, %rsp
	pop %rbp
	ret

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