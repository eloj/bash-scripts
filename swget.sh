#!/bin/bash
URL=$1
FILE=${URL##*/}
echo "Writing STDOUT to $FILE"
wget -O - "$URL" | sudo tee "$FILE" >/dev/null
