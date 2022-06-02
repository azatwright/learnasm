.section .text

# registers used:
#
# r12  number
# r13  s
# r14  i
#
.type lib_itoa, @function
.globl lib_itoa
.set _n, 16
.set _s, 24
.set _len, -8
.set _nabs, -16
lib_itoa:
	push %rbp
	mov %rsp, %rbp
	sub $16, %rsp

	mov _n(%rbp), %r12
	mov _s(%rbp), %r13
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
.type lib_strlen, @function
.globl lib_strlen
.set _s, 16
lib_strlen:
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

# registers used:
#
# r8   n
# rax  !n
#
.type lib_fact, @function
.globl lib_fact
.set _n, 16
lib_fact:
	push %rbp
	mov %rsp, %rbp
	mov _n(%rbp), %r8

	cmp $0, %r8
	je factStopRecursion
	jl factPanic

	# preserve registers
	push %r8

	push %r8
	decq (%rsp)
	call lib_fact
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

# registers used:
#
# r8   array address
# r9   index
# r10  current value
# rax  max value's index & return
#
# Note that for a .long array the following instructions must be used:
#
#         mov (%r8, %r9, 4), %r10d
#         cmp %r10d, (%r8, %rax, 4)
#
# I have no idea why is the 'd' suffix necessary.
#
.type lib_arrmaxq, @function
.globl lib_arrmaxq
.set _arr, 16
lib_arrmaxq:
	push %rbp
	mov %rsp, %rbp
	mov _arr(%rbp), %r8

	mov $0, %r9
	mov $0, %rax

arrmaxqLoop:
	mov (%r8, %r9, 8), %r10
	cmp $0, %r10
	je arrmaxqEnd
	cmp %r10, (%r8, %rax, 8)
	jl arrmaxqLoopNewMax
	inc %r9
	jmp arrmaxqLoop
arrmaxqLoopNewMax:
	mov %r9, %rax
	inc %r9
	jmp arrmaxqLoop

arrmaxqEnd:
	mov %rbp, %rsp
	pop %rbp
	ret

# registers used:
#
# %rax  return
#
.type lib_power, @function
.globl lib_power
.set _base, 16
.set _power, 24
lib_power:
	push %rbp
	mov %rsp, %rbp

	mov _base(%rbp), %rax

powerLoop:
	cmp $1, _power(%rbp)
	je powerLoopStop
	imul _base(%rbp), %rax
	decq _power(%rbp)
	jmp powerLoop

powerLoopStop:
	mov %rbp, %rsp
	pop %rbp
	ret

# registers used:
#
# r12  str
# r13  i
#
.type lib_tolower, @function
.globl lib_tolower
.set _str, 16
.set _len, 24
lib_tolower:
	push %rbp
	mov %rsp, %rbp

	mov _str(%rbp), %r12

	mov $0, %r13
tolower:
	cmp _len(%rbp), %r13
	jge tolowerEnd

	cmpb $'A', (%r12, %r13, 1)
	jl tolowerContinue
	cmpb $'Z', (%r12, %r13, 1)
	jg tolowerContinue

	sub $'A', (%r12, %r13, 1)
	add $'a', (%r12, %r13, 1)

tolowerContinue:
	inc %r13
	jmp tolower

tolowerEnd:
	mov %rbp, %rsp
	pop %rbp
	ret

# registers used:
#
# r12  *s
# r13  i
# rax  hash
#
.type lib_strhash, @function
.globl lib_strhash
.set _s, 16
.set _n, 24
lib_strhash:
	push %rbp
	mov %rsp, %rbp
	sub $16, %rsp

	mov _s(%rbp), %r12
	mov $0, %r13
	mov $0, %rax

strhashLoop:
	cmp _n(%rbp), %r13
	je strhashLoopEnd

	addb (%r12, %r13, 1), %al
	imul $23, %rax

	inc %r13
	jmp strhashLoop

strhashLoopEnd:
	mov %rbp, %rsp
	pop %rbp
	ret
