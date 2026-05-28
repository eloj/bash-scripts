#!/bin/bash
VER=$1
if [ -z "${VER}" ]; then
	echo "Usage: $0 kernel-version"
else
	echo "Need admin to remove kernel ${VER} and its modules."
	sudo sh -c "rm -f /boot/*-${VER} && rm -rf /lib/modules/${VER} && update-grub"
fi
