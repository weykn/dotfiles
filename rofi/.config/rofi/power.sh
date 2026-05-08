#!/bin/bash

# Define labels (with icons)
shutdown="󰐥  Poweroff"
reboot="  Reboot"
lock="  Lock"

# Show the menu and get the selection
chosen=$(echo -e "$lock\n$reboot\n$shutdown" | rofi -dmenu -i -p "power")

# Match based on keywords only
case "$chosen" in
*Poweroff*) poweroff ;;
*Reboot*) reboot ;;
*Lock*) i3lock -c 000000 ;;
*) exit 1 ;;
esac
