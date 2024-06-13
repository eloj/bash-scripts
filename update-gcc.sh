#!/bin/bash
TVER=${1:-14}
TDIR=/opt/local/bin
update-alternatives --remove-all gcc
update-alternatives --remove-all g++
update-alternatives --remove-all cpp
update-alternatives --remove-all gcov
update-alternatives --install /usr/bin/gcc gcc $TDIR/gcc-$TVER 100
update-alternatives --install /usr/bin/g++ g++ $TDIR/g++-$TVER 100
update-alternatives --install /usr/bin/cpp cpp $TDIR/cpp-$TVER 100
update-alternatives --install /usr/bin/gcov gcov $TDIR/gcov-$TVER 100
update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 100
update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 100
#update-alternatives --set cc /usr/bin/gcc
#update-alternatives --set c++ /usr/bin/g++
