#!/bin/bash
for f in *.flac; do
	echo -n "Processing \"$f\" -- "
	opusenc --discard-pictures --bitrate 148 "$f" "${f%.*}.opus"
done
du -hc *.flac | grep total | cut -f 1 | tr -d '\n'
echo -n " --> "
du -hc *.opus | grep total | cut -f 1
