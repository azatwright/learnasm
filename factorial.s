.section .text
.globl _start

_start:
	push $4
	call fact
	add $8, %rsp

	push %rax

	mov $60, %rax    # SYS_exit
	mov (%rsp), %rdi # status
	syscall

# registers used:
#
# %r8   current number
# %rax  return
#
# args:
#
# 16(%rsp)  number
#
.type fact, @function
fact:
	push %rbp
	mov %rsp, %rbp
	mov 16(%rbp), %r8

	cmp $0, %r8
	je factStopRecursion
	jl factPanic # if (r8 < 0)

	# preserve registers
	push %r8

	push %r8
	decq (%rsp)
	call fact
	add $8, %rsp

	# restore registers
	pop %r8

	imul %r8, %rax
	jmp factEnd

factStopRecursion:
	mov $1, %rax
	jmp factEnd
factPanic:
	mov $69, %rax
	jmp factEnd

# assume %rax is set
factEnd:
	mov %rbp, %rsp
	pop %rbp
	ret
