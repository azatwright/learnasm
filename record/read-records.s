.include "def.s"
.include "linux_64.s"

.section .bss

.lcomm BUF, USER_SIZE

.section .data

file: .ascii "records.bin\0"

sep: .ascii "-----\n"
nsep = . - sep

ERR_file_not_opened: .ascii "failed to open file\n"
ERR_file_not_opened_len = . - ERR_file_not_opened

ERR_corrupted_data: .ascii "data is corrupted\n"
ERR_corrupted_data_len = . - ERR_corrupted_data

.section .text

.globl _start
.set _fd, -8
.set _err, -16
.set _nerr, -24
_start:
	mov %rsp, %rbp
	sub $24, %rsp

	movq $0, _fd(%rbp)
	movq $0, _err(%rbp)
	movq $0, _nerr(%rbp)

	mov $SYS_open, %rax
	mov $file,     %rdi
	mov $O_RDONLY, %rsi
	mov $0,        %rdx
	syscall

	cmp $0, %rax
	jl errFileNotOpened

	mov %rax, _fd(%rbp)

loop:
	push $USER_SIZE
	push $BUF
	push _fd(%rbp)
	call sys_read
	add $24, %rsp

	cmp $0, %rax
	je loopEnd

	cmp $USER_SIZE, %rax
	jl errCorruptedData

	push $BUF
	call usrConsistent
	add $8, %rsp

	cmp $0, %rax
	je errCorruptedData

	push $BUF
	call debugUser
	add $8, %rsp

	push $nsep
	push $sep
	push $1
	call sys_write
	add $24, %rsp

	jmp loop

loopEnd:
	mov $SYS_exit, %rax
	mov $0,        %rdi
	syscall

errFileNotOpened:
	movq $ERR_file_not_opened, _err(%rbp)
	movq $ERR_file_not_opened_len, _nerr(%rbp)
	jmp epicfail

errCorruptedData:
	movq $ERR_corrupted_data, _err(%rbp)
	movq $ERR_corrupted_data_len, _nerr(%rbp)
	jmp epicfail

epicfail:
	push _nerr(%rbp)
	push _err(%rbp)
	push $2
	call sys_write
	add $24, %rsp

	mov $SYS_exit, %rax
	mov $1,        %rdi
	syscall
