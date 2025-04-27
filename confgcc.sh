#!/bin/bash
#
#	GCC configuration helper script.
#	Run from out-of-tree build directory!
#
GCCDIR=$1
PREFIX=${2:-/opt/local}

if [[ ! -d ${GCCDIR} ]]; then
	echo "First argument must be the GCC source directory. Don't forget to ./contrib/download_prerequisites before building."
	exit 1
fi

if [[ ! -d ${PREFIX} ]]; then
	echo "Second argument must be the desired GCC installation prefix, e.g /opt/local"
	exit 1
fi

# Remove everything to the left up till and including the last slash
GCCMAJ=${GCCDIR##*/}
# Remove everything to the right till the first dot
GCCMAJ=${GCCMAJ%%.*}
# Remove any "gcc-" prefix.
GCCMAJ=${GCCMAJ#gcc-}

# NOTE: bootstrap-lto-lean is much slower than the default. Remove line for faster build.
${GCCDIR}/configure --enable-languages=c,c++ --prefix=${PREFIX} --program-suffix=-${GCCMAJ} \
	--with-build-config=bootstrap-lto-lean --enable-link-serialization=2 \
	--disable-nls --disable-multilib \
	--with-system-zlib --with-zstd --with-target-system-zlib=auto \
	--enable-shared --enable-linker-build-id --without-included-gettext --enable-threads=posix \
	--enable-bootstrap --enable-clocale=gnu --enable-libstdcxx-debug --enable-libstdcxx-time=yes \
	--with-default-libstdcxx-abi=new --enable-libstdcxx-backtrace --enable-gnu-unique-object --disable-vtable-verify \
	--enable-plugin --enable-default-pie --enable-libphobos-checking=release \
	--disable-werror --enable-cet --with-abi=m64 --without-cuda-driver \
	--with-cpu=native --with-arch=native --with-tune=native \
	--enable-checking=release --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu
#	--with-gcc-major-version-only
## Note: ^-- Strips minor version from '-dumpversion' and all include and library paths and so on. Easier upgrade, but can leave left over files.

echo "Done."
echo "GCC in '${GCCDIR}' configured with --program-suffix=${GCCMAJ}, installing to '${PREFIX}'"
echo "Run e.g 'make -j $(($(nproc)/2)) bootstrap' to build, then 'sudo make install'"

## Old, slimmer, faster build
## ${GCCDIR}/configure --enable-languages=c,c++ --prefix=/opt/local --program-suffix=-${GCCMAJ} \
## 	--disable-nls --disable-multilib \
## 	--with-system-zlib --with-zstd \
## 	--enable-shared --enable-threads=posix --enable-__cxa_atexit --enable-clocale=gnu \
## 	--enable-libstdcxx-debug --enable-libstdcxx-time=yes --enable-plugin \
## 	--with-cpu=native --with-arch=native --with-tune=native \
## 	--enable-checking=release --build=x86_64-linux-gnu --host=x86_64-linux-gnu --target=x86_64-linux-gnu
