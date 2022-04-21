#!/bin/bash
SPEED=${1:-30}
nvidia-settings -a "[gpu:0]/GPUFanControlState=1" -a "[fan:0]/GPUTargetFanSpeed=$SPEED"
