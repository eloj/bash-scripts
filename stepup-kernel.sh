#!/bin/bash
#
# Upgrade linux-x.y.z to linux-x.y.z+1
#
# Uses running kernel as base version. Override by passing version triplet as argument.
#
K_BASE_URL=https://cdn.kernel.org/pub/linux/kernel/vR_MAJOR.x/incr/
K_BASE_NAME=patch-R_VER-D_LEVEL.xz
R_VER=${1:-$(uname -r)}
R_MAJOR=${R_VER%%.*}
D_LEVEL=$((${R_VER##*.} + 1))
NEXT_VER=${R_VER%.*}.$D_LEVEL

[ ! -z $R_VER ] || { echo "Couldn't get running current kernel version" && exit 1; }

echo "Upgrading from kernel $R_VER to $NEXT_VER"

# Substitute R_VER and D_LEVEL into K_BASE
PATCH_FILE=${K_BASE_NAME/R_VER/$R_VER}
PATCH_FILE=${PATCH_FILE/D_LEVEL/$D_LEVEL}
PATCH_URL=${K_BASE_URL/R_MAJOR/$R_MAJOR}${PATCH_FILE}

# Download file, if missing.
if [ ! -f $PATCH_FILE ]; then
	wget $PATCH_URL
	if [ $? -ne 0 ]; then
		echo "Failed to download kernel patch."
		exit 2
	fi
fi

# Patch source tree
pushd .
cd linux-$R_VER
if [ $? -ne 0 ]; then
	echo "Couldn't change into kernel source tree."
	exit 3
fi

pwd
xzcat ../${PATCH_FILE} | patch -p1 --forward --batch --silent --dry-run
if [ $? -eq 0 ]; then
	echo "Dry-run successful, applying kernel patches..."
	xzcat ../${PATCH_FILE} | patch --forward -p1
else
	echo "Patching failed, source tree untouched"
	exit 4
fi

popd
echo "Renaming source tree"
mv linux-$R_VER linux-$NEXT_VER
echo "Removing patch file"
rm ${PATCH_FILE}

echo "Suggest: sudo ./kinstall $NEXT_VER"
