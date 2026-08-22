#!/usr/bin/env bash
# SUDO_ASKPASS / SSH_ASKPASS helper — graphical password prompt.
#   Wayland -> fuzzel --password      X11 -> rofi -password
#
# The askpass contract is: print the password on stdout, exit 0.
# Exit non-zero on cancel so sudo aborts instead of retrying with garbage.
# Nothing is logged, cached, or written to disk.
set -uo pipefail

prompt="${1:-Password:}"

if [ -n "${WAYLAND_DISPLAY:-}" ] && command -v fuzzel >/dev/null 2>&1; then
    exec fuzzel --dmenu --password --prompt "$prompt " --lines 0 --width 32 </dev/null
elif [ -n "${DISPLAY:-}" ] && command -v rofi >/dev/null 2>&1; then
    exec rofi -dmenu -password -p "$prompt" -lines 0 </dev/null
else
    echo "askpass: no graphical session (need WAYLAND_DISPLAY or DISPLAY)" >&2
    exit 1
fi
