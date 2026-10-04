#!/bin/bash
#
# Universal cmake build script
#
set -e
if [ "$1" = "system" ]; then
	PREFIX=/opt/local
else
	PREFIX=${HOME}/local
fi
VENDOR_INFO=$(whoami)@$(uname -n)
CFLAGS_LTO="-flto=auto -fuse-linker-plugin"
CFLAGS_EXTRA="-march=native -mtune=native -Werror ${CFLAGS_LTO}"
cmake -DCMAKE_C_FLAGS="${CFLAGS_EXTRA}" -DCMAKE_INSTALL_PREFIX=${PREFIX} \
	-DCMAKE_BUILD_TYPE=RelWithDebInfo \
	-DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
	-DSDL_VENDOR_INFO=${VENDOR_INFO} -DSDL_TEST_LIBRARY=OFF \
	-S . -B build
cmake --build build --parallel $(($(nproc)/2))
if [ "$1" = "install" ]; then
	cmake --install build
elif [ "$1" = "system" ]; then
	echo "Need credentials to install to ${PREFIX}"
	sudo cmake --install build
else
	echo -e "\nTo install to '${PREFIX}': cmake --install build"
fi
# pkg-config --modversion sdl3
