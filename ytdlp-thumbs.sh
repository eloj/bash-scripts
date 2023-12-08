#!/bin/bash
#
# Download thumbnails for youtube video IDs fed into it on stdin.
#
# Download thumbnails for all videos present:
#   ytarchive | ./ytdlp-thumbs.sh
# Download thumbnails from download archive:
#   head -n 40 archive.txt | ./ytdlp-thumbs.sh
#

function get_thumbnail() {
	yt-dlp --write-thumbnail --no-progress --no-download https://www.youtube.com/watch?v=$1
}

if [ "$#" -gt 0 ]; then
	echo "Error: Feed script youtube id's on stdin"
	exit 1
else
	while IFS= read -r line; do
		# Remove "youtube " prefix, assuming input is yt-dlp download-archive format.
		ID=${line#youtube\ }
		echo "Fetching thumbnail for youtube video $ID"
		get_thumbnail $ID
	done
fi
