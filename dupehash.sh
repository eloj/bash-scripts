#!/bin/bash
SUMBIN="${SUMBIN:-sha256sum}"
SUMOUT=${SUMBIN}s
echo Hashing files..
find . -type f -size +0c -exec $SUMBIN {} \; >$SUMOUT
echo Generating duplicate list..
sort -r <sha256sums | uniq -w 64 -D >$SUMOUT.dupes
if [ -s "$SUMOUT.dupes" ]; then
	echo "Duplicates logged in '$SUMOUT.dupes'"
else
	echo "No duplicates found."
	rm "$SUMOUT.dupes"
fi
echo "Result of hashing files left in '$SUMOUT'"
