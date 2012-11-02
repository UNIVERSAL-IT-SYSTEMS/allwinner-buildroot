#!/bin/ash
cd /dev/snd
rm pcmC0D0p pcmC1D0p
mknod pcmC0D0p c 116 48
mknod pcmC1D0p c 116 16
