#!/bin/bash
CMD=$1

if [ "$EUID" -ne 0 ]; then
	echo "Must be run as root"
	exit 1
fi

if [[ "$CMD" == "start" ]]; then
	echo "Starting docker services"
	systemctl start containerd
	systemctl start docker.socket
	systemctl start docker
	systemctl status --no-pager docker
elif [[ "$CMD" == "stop" ]]; then
	echo "Stopping docker services"
	systemctl stop docker.socket
	systemctl stop docker
	systemctl stop containerd
	systemctl status --no-pager docker || true
else
	echo "Usage: $0 <start|stop>"
fi
