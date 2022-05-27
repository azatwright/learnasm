.include "def.s"
.include "linux_64.s"

.section .bss

.lcomm BUF, USER_SIZE

.section .data

file: .ascii "records.bin\0"

sep: .ascii "-----\n"
nsep = . - sep

.section .text

.globl _start
.set _fd, -8
_start:
	mov %rsp, %rbp
	sub $8, %rsp

	movq $0, _fd(%rbp)

	mov $SYS_open, %rax
	mov $file,     %rdi
	mov $O_RDONLY, %rsi
	mov $0,        %rdx
	syscall
	mov %rax, _fd(%rbp)

loop:
	push $USER_SIZE
	push $BUF
	push _fd(%rbp)
	call read2
	add $24, %rsp
	cmp $0, %rax
	je loopEnd

	push $BUF
	call debugUser
	add $8, %rsp

	push $nsep
	push $sep
	push $1
	call write2
	add $24, %rsp

	jmp loop

loopEnd:
	mov $SYS_exit, %rax
	mov $0,        %rdi
	syscall