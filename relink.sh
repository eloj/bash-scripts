#!/bin/bash
#
# Change an existing link (arg1) to a new target (arg2)
#
relink() {
	if [ ! -L "$1" ]; then echo "First argument must be an existing symbolic link" && return 1; fi
	if [ ! -e "$2" ]; then echo "Target '$2' doesn't exist." && return 1; fi
	# Canonicalize target link (alt. use realpath) -- makes symlink movable
	TARGET=$(readlink -f "$2")
	ln -sfn "$TARGET" "$1"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	echo "This script should be sourced, not run: '. $0'"
fi
