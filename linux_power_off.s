# On my machine, segfaults if runs from a regular user.
# Turns off the computer if runs from root.
#
# In the cloud, segfaults in both cases.

.section .text
.globl _start
_start:
	mov $169,        %rax # SYS_reboot
	mov $0xfee1dead, %rdi # LINUX_REBOOT_MAGIC1
	mov $672274793,  %rsi # LINUX_REBOOT_MAGIC2
	mov $0x4321fedc, %rdx # LINUX_REBOOT_CMD_POWER_OFF
	syscall
