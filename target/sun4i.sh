#!/bin/sh

MY_TARGET_DIR=$1

cp -r target/skel/* ${MY_TARGET_DIR}/

rm -rf ${MY_TARGET_DIR}/init
(cd ${MY_TARGET_DIR} && ln -s bin/busybox init)


cat > ${MY_TARGET_DIR}/etc/init.d/rcS << EOF
#!/bin/sh

mount -t devtmpfs none /dev
mkdir /dev/pts
mount -t devpts none /dev/pts
mknod /dev/mali c 230 0
hostname cubiebox
mkdir -p /boot

EOF

