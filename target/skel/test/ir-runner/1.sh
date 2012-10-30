#!/bin/ash

if lsmod |grep gpio_test
then
     rmmod gpio_test
else
      insmod /lib/modules/`uname -r`/kernel/drivers/misc/gpio-test.ko
fi
