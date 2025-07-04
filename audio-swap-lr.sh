#!/bin/sh
pactl load-module module-remap-sink \
    sink_name=reverse-stereo \
    master=0 \
    channels=2 \
    master_channel_map=front-right,front-left \
    channel_map=front-left,front-right
echo "Setting default sink to reverse-stereo"
pactl set-default-sink reverse-stereo
