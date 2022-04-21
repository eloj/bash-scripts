#!/bin/bash
# Change an existing link (arg1) to a new target (arg2)
relink(){
	if [ ! -L "$1" ]; then echo "First argument must be an existing symbolic link" && return 1; fi
	if [ ! -e "$2" ]; then echo "Target '$2' doesn't exist." && return 1; fi
	ln -sfn `readlink -f $2` $1
}

