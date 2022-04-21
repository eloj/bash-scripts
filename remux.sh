#!/bin/bash
# TARGET="${1%.*}-remuxed.mkv"
ffmpeg -i "$1" -map 0 -c copy "remuxed-$1"
