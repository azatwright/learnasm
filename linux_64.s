# ref:
#
# https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/x86/entry/syscalls/syscall_64.tbl
#
.set SYS_read,  0
.set SYS_write, 1
.set SYS_open,  2
.set SYS_close, 3
.set SYS_exit,  60

# ref:
#
# https://git.musl-libc.org/cgit/musl/tree/include/fcntl.h
# https://git.musl-libc.org/cgit/musl/tree/arch/generic/bits/fcntl.h
#
.equ O_RDONLY,    00
.equ O_WRONLY,    01
.equ O_CREAT,   0100
.equ O_TRUNC,  01000
