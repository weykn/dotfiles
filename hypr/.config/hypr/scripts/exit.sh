#!/bin/bash
# Replaces i3-nagbar exit confirmation.
chosen=$(printf 'No, stay\nYes, exit Hyprland\n' \
    | fuzzel --dmenu --prompt "exit?  " --lines 2 --width 24)
[ "$chosen" = "Yes, exit Hyprland" ] && hyprctl dispatch exit
