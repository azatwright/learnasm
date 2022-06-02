.include "def.s"
.include "linux_64.s"

.section .bss

.lcomm BUF, USER_SIZE

.section .data

file: .ascii "records.bin\0"

ERR_file_not_opened: .ascii "file not opened\n"
ERR_file_not_opened_len = . - ERR_file_not_opened

ERR_corrupt_data: .ascii "corrupt data\n"
ERR_corrupt_data_len = . - ERR_corrupt_data

.section .text

.globl _start
.set _err, -8
.set _nerr, -16
.set _fd, -24
.set _nread, -32
_start:
	mov %rsp, %rbp
	sub $32, %rsp

	push $0
	push $O_RDWR
	push $file
	call sys_open
	add $24, %rsp

	cmp $0, %rax
	jl errFileNotOpened

	mov %rax, _fd(%rbp)

ioloop:
	push $USER_SIZE
	push $BUF
	push _fd(%rbp)
	call sys_read
	add $24, %rsp

	cmp $0, %rax
	je ioloopEnd

	cmp $USER_SIZE, %rax
	jl errCorruptData

	push $USER_SIZE-USER_CHKSUM_SIZE
	push $BUF
	call lib_strhash
	add $16, %rsp

	cmp %rax, USER_CHKSUM+BUF
	jne errCorruptData

	push $SEEK_CUR
	push $-USER_SIZE
	push _fd(%rbp)
	call sys_lseek
	add $24, %rsp

	decq USER_AGE + BUF

	push $USER_SIZE-USER_CHKSUM_SIZE
	push $BUF
	call lib_strhash
	add $16, %rsp
	mov %rax, USER_CHKSUM+BUF

	push $USER_SIZE
	push $BUF
	push _fd(%rbp)
	call sys_write
	add $24, %rsp

	jmp ioloop

ioloopEnd:
	push _fd(%rbp)
	call sys_close

	push $0
	call sys_exit

errFileNotOpened:
	movq $ERR_file_not_opened, _err(%rbp)
	movq $ERR_file_not_opened_len, _nerr(%rbp)
	jmp failure

errCorruptData:
	movq $ERR_corrupt_data, _err(%rbp)
	movq $ERR_corrupt_data_len, _nerr(%rbp)
	jmp failure

failure:
	push _nerr(%rbp)
	push _err(%rbp)
	push $2
	call sys_write

	push $1
	call sys_exit
