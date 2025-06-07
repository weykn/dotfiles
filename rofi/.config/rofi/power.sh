#!/bin/bash

# Define labels (with icons)
shutdown="󰐥  Poweroff"
reboot="  Reboot"
lock="  Lock"
suspend="󰤄  Sleep"

# Show the menu and get the selection
chosen=$(echo -e "$lock\n$suspend\n$reboot\n$shutdown" | rofi -dmenu -i -p "power")

# Match based on keywords only
case "$chosen" in
    *Poweroff*) systemctl poweroff ;;
    *Reboot*) systemctl reboot ;;
    *Lock*) i3lock -c 000000 ;;
    *Sleep*) systemctl suspend ;;
    *) exit 1 ;;
esac
