#!/bin/bash
#
# Universal CMake build script
#
#	no args - just build, no install
#	install - build and install locally (~/local)
#	system  - build and install system-wide (/opt/local)
#
set -e
if [ "$1" = "system" ]; then
	PREFIX=/opt/local
else
	PREFIX=${HOME}/local
fi
BUILDDIR=build
VENDOR_INFO=$(whoami)@$(uname -n)
CFLAGS_LTO="-flto=auto -fuse-linker-plugin"
CFLAGS_EXTRA="-march=native -mtune=native -Werror ${CFLAGS_LTO}"
cmake -DCMAKE_C_FLAGS="${CFLAGS_EXTRA}" -DCMAKE_INSTALL_PREFIX=${PREFIX} \
	-DCMAKE_BUILD_TYPE=RelWithDebInfo \
	-DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
	-DSDL_VENDOR_INFO=${VENDOR_INFO} -DSDL_TEST_LIBRARY=OFF \
	-S . -B ${BUILDDIR}
cmake --build ${BUILDDIR} --parallel $(($(nproc)/2))
if [ "$1" = "install" ]; then
	cmake --install ${BUILDDIR}
elif [ "$1" = "system" ]; then
	echo "Need credentials to install to ${PREFIX}"
	sudo cmake --install ${BUILDDIR}
else
	echo -e "\nTo install to '${PREFIX}': cmake --install ${BUILDDIR}"
fi
# pkg-config --modversion sdl3
