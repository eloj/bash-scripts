#!/bin/bash
#
# Simple bash shell opus tagger
# https://github.com/eloj/bash-scripts
#
# Automatically tag opus files based on directory and filenames.
# Requires 'opustags': https://github.com/fmang/opustags
#
# Directory format: "Artist Name - Album Title (2024)"
# File format "01 - Track Name.opus"
#
# NOTE: Must run from directory with the files to be tagged.
#
set -e
CMD=opustags

OLDIFS=$IFS
IFS=$'\n'
FILES=(${@:-*.opus})
IFS=$OLDIFS

DIR=$(basename "`pwd`")
# DIR="Artist Name - Album Title (1019)"

command -v $CMD >/dev/null 2>&1 || { echo >&2 "$CMD not available, aborting."; exit 1; }

if [[ ! $DIR =~ [:alnum:\ ]+\-[:alnum:\ ]+ ]]; then
	echo "Directory should have format \"artist name - album name (year)\" where the year part is optional."
	exit 1
fi

# Extract artist, album and year from directory name
ARTIST=${DIR% - *}
ALBUM=${DIR#* - }
if [[ $ALBUM =~ \(([12][0-9][0-9][0-9])\)$ ]]; then
	DATE=${BASH_REMATCH[1]}
	# Strip " (year)" from end of album name
	ALBUM=${ALBUM:0:-7}
fi

NUM_TRACKS=${#FILES[@]}

if [[ "$NUM_TRACKS" -eq "0" ]]; then
	echo "No matching files found."
	exit 1
fi

echo "Tagging $NUM_TRACKS tracks with ARTIST='$ARTIST', ALBUM='$ALBUM', DATE=$DATE"

# Prepare tagging template
TB="TRACKNUMBER=\$tno
TITLE=\$title
ARTIST=$ARTIST
ALBUM=$ALBUM
TRACKTOTAL=$NUM_TRACKS
DISCNUMBER=1
DISCTOTAL=1
"

# Append date if available
if [[ ! -z "$DATE" ]]; then
	TB="${TB}DATE=${DATE}"
fi

#
# Process files
#
for f in "${FILES[@]}"; do
	echo "Tagging \"$f\""
	# Extract two first characters as the track no.
	title=${f%.opus}
	tno=${title:0:2}
	# Skip trackno + " - "
	title=${title:5}
	# Write variable data into template:
	tags=${TB//\$tno/$tno}
	tags=${tags//\$title/$title}
	# echo "$tags"
	# Invoke tagger:
	echo "$tags" | $CMD -i -S "$f"
done

if [[ -z "$DATE" ]]; then
	echo "No date was detected, you can set it with:"
	echo "$CMD -i -s DATE=yyyy <files..>"
fi
