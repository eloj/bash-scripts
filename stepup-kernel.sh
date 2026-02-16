#!/bin/bash
#
# Upgrade linux-x.y.z to linux-x.y.z+1
# by el0j -- https://github.com/eloj/bash-scripts/blob/master/stepup-kernel.sh
#
# Uses running kernel as base version. Override by passing version triplet as argument.
#
BASE_URL=https://cdn.kernel.org/pub/linux/kernel
R_VER=${1:-$(uname -r)}
# Strip any -customtag
R_VER=${R_VER%%-*}
R_MAJOR=${R_VER%%.*}
R_LEVEL=${R_VER##*.}
D_LEVEL=$((${R_LEVEL} + 1))
NEXT_VER=${R_VER%.*}.$D_LEVEL

[ ! -z $R_VER ] || { echo "Couldn't get running current kernel version" && exit 1; }

echo "Upgrading from kernel $R_VER to $NEXT_VER"

if [ "$R_LEVEL" -eq 0 ]; then
	# Full patch
	PATCH_FILE=patch-${NEXT_VER}.xz
	PATCH_URL=${BASE_URL}/v${R_MAJOR}.x/${PATCH_FILE}
	# Rewrite R_VER without .0
	R_VER=${R_VER%%.0}
else
	# Incremential patch
	PATCH_FILE=patch-${R_VER}-${D_LEVEL}.xz
	PATCH_URL=${BASE_URL}/v${R_MAJOR}.x/incr/${PATCH_FILE}
fi

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

echo "Suggest: sudo ./kinstall.sh $NEXT_VER"
