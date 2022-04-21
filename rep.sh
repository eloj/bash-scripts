#!/bin/bash
# Output a string (ARG2, defaults to 'A'), repeated ARG1 times.
rep() {
	C=${1:-0}
	S=${2:-A}
	if [ "$C" -gt 0 ]; then
		printf "%.0s$S" $(seq 1 $C)
	fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	echo "This script should be sourced, not run: '. $0'"
fi
