#!/bin/bash
#
# Set the color intensity of a PS4 Dual Shock Controller
# Call with '<RRGGBB> [/dev/input/js0] [<udev-path>]'
#
# Example udev-rule:
# $ cat /etc/udev/rules.d/10-dualshock4.rules
# ACTION=="add", SUBSYSTEM=="input", ATTRS{uniq}=="fe:ed:be:ef:aa:ff", RUN+="/local/bin/ds4led.sh 000001 '%E{DEVNAME}' '%p'"
#
COLOR="${1:-000001}"
DEVNAME="${2:-/dev/input/js0}"
DEVPATH="${3:-$(udevadm info -q path -n $DEVNAME 2>/dev/null)}"

if [ -z "$DEVPATH" ]; then
	echo "Error: No device path for device '$DEVNAME'"
	exit 1
fi

RED=$((16#${COLOR:0:2}))
GREEN=$((16#${COLOR:2:2}))
BLUE=$((16#${COLOR:4:2}))

# extract LEDID from path
LEDID=$(echo "$DEVPATH" | egrep -o '[[:xdigit:]]{4}:[[:xdigit:]]{4}:[[:xdigit:]]{4}\.[[:xdigit:]]{4}')

if [ -z "$LEDID" ]; then
	echo "Error: Failed to extract LED ID from devpath."
	exit 1
fi
if [ ! -d "/sys/class/leds/$LEDID:global" ]; then
	echo "Error: /sys/class/leds/$LEDID:global not found"
	exit 2
fi

echo $RED   >/sys/class/leds/$LEDID:red/brightness
echo $GREEN >/sys/class/leds/$LEDID:green/brightness
echo $BLUE  >/sys/class/leds/$LEDID:blue/brightness

# logging
# echo $(date +"%F %T") "ID:$LEDID R:$RED G:$GREEN B:$BLUE" >>/var/log/ds4led.log
