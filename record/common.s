.include "def.s"
.include "linux_64.s"

.section .data

dbgName: .ascii "Name: "
dbgNameLen = . - dbgName

dbgSurname: .ascii "Surname: "
dbgSurnameLen = . - dbgSurname

dbgAddress: .ascii "Address: "
dbgAddressLen = . - dbgAddress

newline: .ascii "\n"

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

.type debugUser, @function
.globl debugUser
.set _buf, 16
debugUser:
	push %rbp
	mov %rsp, %rbp

	push $dbgNameLen
	push $dbgName
	push $1
	call write2
	add $24, %rsp

	push _buf(%rbp)
	call strlen
	add $8, %rsp

	push %rax
	push _buf(%rbp)
	push $1
	call write2
	add $24, %rsp

	push $1
	push $newline
	push $1
	call write2
	add $24, %rsp

	push $dbgSurnameLen
	push $dbgSurname
	push $1
	call write2
	add $24, %rsp

	push _buf(%rbp)
	add $USER_SURNAME, (%rsp)
	call strlen
	add $8, %rsp

	push %rax
	push _buf(%rbp)
	add $USER_SURNAME, (%rsp)
	push $1
	call write2
	add $24, %rsp

	push $1
	push $newline
	push $1
	call write2
	add $24, %rsp

	push $dbgAddressLen
	push $dbgAddress
	push $1
	call write2
	add $24, %rsp

	push $1
	push $newline
	push $1
	call write2
	add $24, %rsp

	push _buf(%rbp)
	add $USER_ADDRESS, (%rsp)
	call strlen
	add $8, %rsp

	push %rax
	push _buf(%rbp)
	add $USER_ADDRESS, (%rsp)
	push $1
	call write2
	add $24, %rsp

	push $1
	push $newline
	push $1
	call write2
	add $24, %rsp

	mov %rbp, %rsp
	pop %rbp
	ret