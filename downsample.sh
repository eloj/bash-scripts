#!/bin/bash
INFILE=$1
PERC=${2:-50}
BASEFILE=$(basename ${INFILE})
OUTFILE="downsampled-${PERC}%-${BASEFILE}.jpeg"
convert $1 -verbose -filter Lanczos -sampling-factor 1x1 -quality 90 -resize %${PERC} ${OUTFILE}
