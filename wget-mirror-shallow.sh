#!/bin/bash
URL=$1
CUTDIRS=${2:-0}
if [[ -z ${URL} ]]; then
	echo "Usage: $0 url [cut-dirs#]"
	exit 1
fi
# Use "-i urls.txt" to read url(s) from file.
wget --recursive --level=1 --convert-links --timestamping --no-host-directories --cut-dirs=${CUTDIRS} ${URL}
