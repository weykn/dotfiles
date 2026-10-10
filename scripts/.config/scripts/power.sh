#!/bin/bash
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
    *"Log out"*)   hyprctl dispatch 'hl.dsp.exit()' ;;
    *)             exit 1 ;;
esac
