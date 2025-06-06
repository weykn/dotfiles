#!/bin/bash

# Options
shutdown="󰐥\tPoweroff"
reboot="\tReboot"
lock="\tLock"
suspend="󰤄\tSleep"

chosen=$(echo -e "$lock\n$suspend\n$reboot\n$shutdown" | rofi -dmenu -i -p "power")

case "$chosen" in
    "$shutdown") systemctl poweroff ;;
    "$reboot") systemctl reboot ;;
    "$lock") i3lock -c 000000  ;;  # Or i3lock-color / betterlockscreen
    "$suspend") systemctl suspend ;;
    *) exit 1 ;;
esac
