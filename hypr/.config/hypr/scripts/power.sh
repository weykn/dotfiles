#!/bin/bash
# SUPER+P - power menu. Uses the "Mono" nerd font variant so every icon is
# exactly one cell wide and the labels line up.

font="JetBrainsMono Nerd Font Mono:size=12"

chosen=$(printf '%s\n' \
    "  Lock" \
    "  Log out" \
    "  Reboot" \
    "  Power off" \
    | fuzzel --dmenu \
        --font "$font" \
        --prompt "  " \
        --placeholder "" \
        --no-icons \
        --lines 4 \
        --width 22 \
        --only-match)

case "$chosen" in
    *"Power off"*) systemctl poweroff ;;
    *Reboot*)      systemctl reboot ;;
    *Lock*)        hyprlock ;;
    *"Log out"*)   hyprctl dispatch exit ;;
    *)             exit 1 ;;
esac
