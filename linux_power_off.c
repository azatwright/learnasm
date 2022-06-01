#include <linux/reboot.h>
#include <sys/syscall.h>
#include <unistd.h>

/*
	On my machine, does nothing if runs from a regular user.
	Turns off the computer if runs from root.

	In the cloud, does nothing in both cases.
*/

int
main(void)
{
	syscall
	(SYS_reboot,
	LINUX_REBOOT_MAGIC1,
	LINUX_REBOOT_MAGIC2,
	LINUX_REBOOT_CMD_POWER_OFF);

	return 0;
}
