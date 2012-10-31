#include <stdio.h>
#include <stdint.h>
#include <linux/input.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>

#include <pthread.h>
#include <sys/types.h>
#include <sys/inotify.h>
#include <sys/stat.h>
#include <limits.h>
#include <sys/errno.h>


#include <sys/socket.h>
#include <sys/ioctl.h>
#include <linux/types.h>
#include <net/if.h>
#include <linux/sockios.h>

#ifndef EV_SYN
#define EV_SYN 0
#endif

#define BITS_PER_LONG (sizeof(long) * 8)
#define NBITS(x) ((((x)-1)/BITS_PER_LONG)+1)
#define OFF(x)  ((x)%BITS_PER_LONG)
#define BIT(x)  (1UL<<OFF(x))
#define LONG(x) ((x)/BITS_PER_LONG)

pthread_t hotplug_thrdid;
pthread_t network_thrdid;
#define EVENT_SIZE  ( sizeof (struct inotify_event) )

void report_dev_name(const char *name, int is_create)
{
	if (strlen(name) == 3) {
		if (strcmp("sda", name) ||
		    strcmp("sdb", name) ||
		    strcmp("sdc", name) ||
		    strcmp("sdd", name) ||
		    strcmp("sde", name) ||
		    strcmp("sdf", name) ||
		    strcmp("sdg", name)) {
			if (is_create)
				printf("mon: %s create\n", name);
			else
				printf("mon: %s delete\n", name);

                    if (!access("/test/ir-runner/storage.sh", X_OK))
                        system("/test/ir-runner/storage.sh");

		}
	} else if (strlen(name) == 7) {
		if (strcmp("mmcblk0", name) ||
		    strcmp("mmcblk1", name) ||
		    strcmp("mmcblk2", name) ||
		    strcmp("mmcblk3", name)) {
			if (is_create)
				printf("mon: %s create\n", name);
			else
				printf("mon: %s delete\n", name);

                     if (!access("/test/ir-runner/storage.sh", X_OK))
                         system("/test/ir-runner/storage.sh");
		}
	}
}

struct mii_data {
	__u16 phy_id;
	__u16 reg_num;
	__u16 val_in;
	__u16 val_out;
};

void network_report_fail()
{
	if (!access("/test/ir-runner/network.sh", X_OK))
          system("/test/ir-runner/network.sh linkerror");
}

void *network_monitor(void *arg)
{
	int skfd = 0;
	struct ifreq ifr;
	struct mii_data* mii = NULL;

repeat:
	sleep(1);

	if((skfd = socket( AF_INET, SOCK_DGRAM, 0)) < 0 ) {
		//perror("socket");
		network_report_fail();
		goto repeat;
	}


	while(1) {
		sleep(1);

		bzero(&ifr, sizeof(ifr));
		strncpy(ifr.ifr_name, "eth0", IFNAMSIZ - 1);
		ifr.ifr_name[IFNAMSIZ - 1] = 0;
		if(ioctl(skfd, SIOCGMIIPHY, &ifr) < 0) {
			//perror("ioctl");
			network_report_fail();
			close(skfd);
			goto repeat;
		}

		mii = (struct mii_data*)&ifr.ifr_data;
		mii->reg_num = 0x01;

		if(ioctl(skfd, SIOCGMIIREG, &ifr ) < 0) {
			//perror("ioctl2");
			network_report_fail();
			close(skfd);
			goto repeat;
		}

		if( mii->val_out & 0x0004 ) {
			if (!access("/test/ir-runner/network.sh", X_OK))
				system("/test/ir-runner/network.sh linkup");
		}
		else {
			if (!access("/test/ir-runner/network.sh", X_OK))
				system("/test/ir-runner/network.sh linkdown");
		}

	}

	close(skfd);
	return NULL;
}

void *hotplug_monitor(void *arg)
{
	int wd, i, len;
	int fd;
	char buffer[1024];

	fd = inotify_init();
	if (fd < 0) {
		perror("inotify_init");
		return NULL;
	}

	wd = inotify_add_watch(fd, "/dev", IN_CREATE|IN_DELETE);
	if (wd == -1) {
		perror("inotify_add_watch");
		return NULL;
	}

	while(1) {
		i = 0;
		len = read(fd, buffer, sizeof(buffer));
		if (len < 0) {
			if (errno == EINTR)
				continue;
			perror("read");
		}

		while (i<len) {
			struct inotify_event *event = (struct inotify_event *)
				buffer;
			if (event->len) {
				if (event->mask & IN_CREATE) {
					report_dev_name(event->name, 1);
				} else if (event->mask & IN_DELETE) {
					report_dev_name(event->name, 0);
				}
			}
			
			i += EVENT_SIZE + event->len;
		}
		
	}

	inotify_rm_watch(fd, wd);
	close(fd);

	ruturn NULL;
}

int main (int argc, char **argv)
{
	int fd, rd, i, j, k;
	struct input_event ev[64];
	int version;
	unsigned short id[4];
	unsigned long bit[EV_MAX][NBITS(KEY_MAX)];
	char name[256] = "Unknown";
	int abs[5];

	pid_t pid, sid;

	if (argc < 2) {
		printf("Usage: ir-runner /dev/input/eventX\n");
		printf("Where X = input device number\n");
		return 1;
	}

	pid = fork();
	if (pid < 0) {
		exit(EXIT_FAILURE);
	}
	if (pid >0) {
		exit(EXIT_SUCCESS);
	}
	umask(0);
	sid = setsid();
	if (sid < 0) {
		exit(EXIT_FAILURE);
	}


	if ((fd = open(argv[argc - 1], O_RDONLY)) < 0) {
		perror("evtest");
		return 1;
	}

	ioctl(fd, EVIOCGNAME(sizeof(name)), name);
	printf("Input device name: \"%s\"\n", name);

	daemon(0, 1);

	pthread_create(&hotplug_thrdid, NULL, hotplug_monitor, NULL);
	pthread_create(&network_thrdid, NULL, network_monitor, NULL);

	while (1) {
		rd = read(fd, ev, sizeof(struct input_event) * 64);

		if (rd < (int) sizeof(struct input_event)) {
			printf("yyy\n");
			perror("\nevtest: error reading");
			return 1;
		}

		for (i = 0; i < rd / sizeof(struct input_event); i++) {
			if (ev[i].type == 1 && ev[i].value == 1) {
				printf("IR: code=%d\n", ev[i].code);
				char test_program[32];
				memset(test_program, 0, sizeof(test_program));
				sprintf(test_program, "/test/ir-runner/%d.sh", ev[i].code);
				if (!access(test_program, X_OK)) {
					printf("run hook %s\n", test_program);
					system(test_program);
				}
			}
		}
	}
}
