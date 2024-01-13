#!/bin/bash
#
# Download thumbnails for youtube video IDs fed into it on stdin or args.
#
# Download thumbnails:
#   ./ytdlp-thumbs.sh id1 id2 id3 ...
# Download thumbnails for all videos present:
#   ytarchive | ./ytdlp-thumbs.sh
# Download thumbnails from download archive:
#   head -n 40 archive.txt | ./ytdlp-thumbs.sh
#

function get_thumbnail() {
	echo "Fetching thumbnail for youtube video $1"
	yt-dlp --write-thumbnail --no-progress --no-download https://www.youtube.com/watch?v=$1
}

if [ "$#" -gt 0 ]; then
	for ID in "$@"; do
		get_thumbnail $ID
	done
else
	while IFS= read -r line; do
		# Remove "youtube " prefix, assuming input is yt-dlp download-archive format.
		ID=${line#youtube\ }
		get_thumbnail $ID
	done
fi
