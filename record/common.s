.include "def.s"
.include "linux_64.s"

.section .bss
.lcomm dbgAgeBuf, 50

.section .data

dbgName: .ascii "Name: "
dbgNameLen = . - dbgName

dbgSurname: .ascii "Surname: "
dbgSurnameLen = . - dbgSurname

dbgAddress: .ascii "Address: "
dbgAddressLen = . - dbgAddress

dbgAge: .ascii "Age: "
dbgAgeLen = . - dbgAge

newline: .ascii "\n"

.section .text

.type debugUser, @function
.globl debugUser
.set _buf, 16
debugUser:
	push %rbp
	mov %rsp, %rbp

	push $dbgNameLen
	push $dbgName
	push $1
	call sys_write
	add $24, %rsp

	push _buf(%rbp)
	call lib_strlen
	add $8, %rsp

	push %rax
	push _buf(%rbp)
	push $1
	call sys_write
	add $24, %rsp

	push $1
	push $newline
	push $1
	call sys_write
	add $24, %rsp

	push $dbgSurnameLen
	push $dbgSurname
	push $1
	call sys_write
	add $24, %rsp

	push _buf(%rbp)
	add $USER_SURNAME, (%rsp)
	call lib_strlen
	add $8, %rsp

	push %rax
	push _buf(%rbp)
	add $USER_SURNAME, (%rsp)
	push $1
	call sys_write
	add $24, %rsp

	push $1
	push $newline
	push $1
	call sys_write
	add $24, %rsp

	push $dbgAddressLen
	push $dbgAddress
	push $1
	call sys_write
	add $24, %rsp

	push $1
	push $newline
	push $1
	call sys_write
	add $24, %rsp

	push _buf(%rbp)
	add $USER_ADDRESS, (%rsp)
	call lib_strlen
	add $8, %rsp

	push %rax
	push _buf(%rbp)
	add $USER_ADDRESS, (%rsp)
	push $1
	call sys_write
	add $24, %rsp

	push $1
	push $newline
	push $1
	call sys_write
	add $24, %rsp

	push $dbgAgeLen
	push $dbgAge
	push $1
	call sys_write
	add $24, %rsp

	mov _buf(%rbp), %r12
	add $USER_AGE, %r12

	push $dbgAgeBuf
	push (%r12)
	call lib_itoa
	add $16, %rsp

	push %rax
	push $dbgAgeBuf
	push $1
	call sys_write
	add $24, %rsp

	push $1
	push $newline
	push $1
	call sys_write
	add $24, %rsp

	mov %rbp, %rsp
	pop %rbp
	ret
