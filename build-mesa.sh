#!/bin/bash
#
# Building Mesa on Linux Mint (Ubuntu LTS) for AMDGPU
#
# Req: Meson >= 1.4.0
# https://github.com/mesonbuild/meson/releases
# Unpack archive from github and path it.
#
# Req: LLVM >= 18.0.0
# https://github.com/llvm/llvm-project/releases
# Unpack archive from github and path it,
# then add its 'lib' dir to your ld.so.conf
#
# You also need Python 3.12+ and the Vulkan SDK
#
# Package dependencies include, but are not limited to:
# libxml2-dev libglvnd-dev libxcb-dri2-0-dev libxcb-randr0-dev libxcb-glx0-dev libxcb-shm0-dev \
# libx11-xcb-dev libxcb-dri3-dev libxcb-present-dev libxshmfence-dev libxcb-keysyms1-dev
#
EXTRA_VERSION="mine"
PREFIX=$HOME/build/mesa
CONFNAME=amd

if [[ "${EXTRA_VERSION}" != "" ]]; then
	VERSION="$(cat VERSION)"
	if [[ ${VERSION} != *-${EXTRA_VERSION} ]]; then
		echo "Updating VERSION with EXTRA_VERSION"
		VERSION="${VERSION}-${EXTRA_VERSION}"
		echo ${VERSION} > VERSION
	fi
fi

BUILDID="$(whoami)@$(uname -n)-${VERSION}"
# CFLAGS_LTO="-flto=auto -fuse-linker-plugin"
CFLAGS_EXTRA="-O3 -march=native -mtune=native -pipe -DNDEBUG ${CFLAGS_LTO}"

# meson setup --wipe build/${CONFNAME}
# rm -rf build/${CONFNAME}/*

meson setup build/${CONFNAME} --libdir lib64 --prefix ${PREFIX} --buildtype=release \
	-Dgallium-drivers=radeonsi \
	-Dvulkan-drivers=amd \
	-Dvideo-codecs=all \
	-Dplatforms=x11 \
	-Dglvnd=enabled \
	-Dglx=auto \
	-Dvalgrind=disabled \
	-Dlibunwind=disabled \
	-Dshared-llvm=disabled \
	-Dcpp_rtti=false \
	-Dradv-build-id="${BUILDID}" -Dradeonsi-build-id="${BUILDID}" \
	-Dc_args="${CFLAGS_EXTRA}" -Dcpp_args="${CFLAGS_EXTRA}"

if [ $? -eq 0 ]; then
	NUMCPU=$(($(nproc)/2))
	echo "Running 'meson compile --jobs ${NUMCPU} -C build/${CONFNAME}':"
	meson compile --jobs ${NUMCPU} -C build/${CONFNAME}
	if [ $? -eq 0 ]; then
		echo "Run 'meson install -C build/${CONFNAME}' to install."
	fi
fi
