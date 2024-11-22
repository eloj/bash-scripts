#!/bin/bash
#
# Linux kernel build and install helper script
# by el0j -- https://github.com/eloj/bash-scripts/blob/master/kinstall.sh
#
VERSION=$1

if [ -z "$VERSION" ]; then
	echo "Usage: $0 <kernel-version-number>"
	exit 1
fi

pushd linux-$VERSION 2>/dev/null
if [ $? -ne 0 ]; then
	echo "Couldn't CD into kernel source directory"
	exit 1
fi

make oldconfig
make -j3 bzImage
if [ $? -ne 0 ]; then
	echo "Build failed"
	exit 1
fi
make -j3 modules && make modules_install

# Special handling of two-part version numbers, like "6.12"
if [[ ${VERSION} =~ ^[0-9]+\.[0-9]+$ ]]; then
	VERSION=${VERSION}.0
	echo "Non-patch version detected, using ${VERSION} for output."
fi

KCONFIG=/boot/config-$VERSION
echo "Installing $KCONFIG"
cp .config $KCONFIG

KKERNEL=/boot/vmlinuz-$VERSION
echo "Installing kernel image $KKERNEL"
cp arch/x86_64/boot/bzImage $KKERNEL

cd /boot && update-initramfs -c -k $VERSION && update-grub

echo "All done"

popd
