#!/usr/bin/env bash
#
# Hacky script to install the latest amdgpu firmware
#
# Redirect to 'install.sh' file.
#
SRCDIR=${1:-$HOME/dev/EXT/linux-firmware-git/amdgpu}
DSTDIR=/lib/firmware/amdgpu

# Optionally git pull the source directory if possible
echo -n "Updating ${SRCDIR}... " >&2
if [ -d "${SRCDIR}/../.git" ]; then
	pushd . > /dev/null
	cd ${SRCDIR}/..
	git pull >/dev/null
	popd > /dev/null
	echo "Done." >&2
else
	echo "(skipped)" >&2
fi

echo -n "Scanning ${SRCDIR}... " >&2
for FILE in ${SRCDIR}/*.bin; do
	#echo -n "Processing '${FILE}'... "
	TARGET=${DSTDIR}/`basename ${FILE}`
	if [ -f "${TARGET}" ]; then
		if [ ${FILE} -nt "${TARGET}" ]; then
			echo "# Updated firmware"
			echo cp -p ${FILE} ${TARGET}
		fi
	else
		if [ -f "${TARGET}.zst" ]; then
			DEREF=$(readlink -f "${TARGET}.zst")
			OLD_SHA=`zstd -dc "${DEREF}" | sha256sum -b | cut -f 1 -d' '`
			NEW_SHA=`sha256sum -b "${FILE}" | cut -f 1 -d' '`
			# if [ ${FILE} -nt "${TARGET}.zst" ]; then
			if [ "${OLD_SHA}" != "${NEW_SHA}" ]; then
				OLD_D=`date -r "${TARGET}.zst" "+%Y-%m-%d %H:%M:%S"`
				NEW_D=`date -r "${FILE}" "+%Y-%m-%d %H:%M:%S"`
				echo "# Updated firmware (zstd), was ${OLD_D}, new ${NEW_D}"
				echo "# Old SHA256=${OLD_SHA}"
				echo "# New SHA256=${NEW_SHA}"
				echo zstd -f ${FILE} -o ${TARGET}.zst
				echo touch --reference=${FILE} ${TARGET}.zst
			fi
		else
			echo "# New firmware"
			echo zstd ${FILE} -o ${TARGET}.zst
			echo touch --reference=${FILE} ${TARGET}.zst
		fi
	fi
done
echo "Done." >&2
