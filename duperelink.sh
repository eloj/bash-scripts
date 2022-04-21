#!/bin/bash
## TODO: add action: show | relink | remove
## TODO: add --dryrun --noact
## TODO: add --verbose
prevhash=x
target=x
while IFS=' ' read -r hash filename
do
	if [[ $prevhash != $hash ]];
	then
		# First time seeing hash, use as target.
		target="$(realpath $filename)"
		prevhash=$hash
		echo "TARGET:$hash=$filename"
	else
		# Hashes matched, relink this file to the target.
		echo "RELINK:$filename -> $target"
		### ACTION CHECK ### ln -srf "$target" "$filename"
	fi
done < sha256sums.dupes
