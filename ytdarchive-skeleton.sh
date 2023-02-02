#!/bin/bash
URL=${1:-https://www.youtube.com/USER/videos}
echo ytdlp-best --playlist-items 1:20 --max-downloads 6 --download-archive ytarchive.txt --break-on-existing $URL
