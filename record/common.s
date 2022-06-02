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

.type usrConsistent, @function
.globl usrConsistent
.set _buf, 16
usrConsistent:
	push %rbp
	mov %rsp, %rbp

	push $USER_SIZE-USER_CHKSUM_SIZE
	push _buf(%rbp)
	call lib_strhash
	add $16, %rsp

	mov _buf(%rbp), %r12
	mov USER_CHKSUM(%r12), %r12

	cmp %rax, %r12
	jne usrConsistentFalse
	jmp usrConsistentTrue

usrConsistentFalse:
	mov $0, %rax
	mov %rbp, %rsp
	pop %rbp
	ret

usrConsistentTrue:
	mov $1, %rax
	mov %rbp, %rsp
	pop %rbp
	ret

.type usrRehash, @function
.globl usrRehash
.set _buf, 16
usrRehash:
	push %rbp
	mov %rsp, %rbp

	push $USER_SIZE-USER_CHKSUM_SIZE
	push _buf(%rbp)
	call lib_strhash
	add $16, %rsp

	mov _buf(%rbp), %r12
	mov %rax, USER_CHKSUM(%r12)

	mov %rbp, %rsp
	pop %rbp
	ret
