#!/bin/bash
# Replaces clipmenu. Backed by cliphist.
cliphist list \
    | fuzzel --dmenu --prompt "clip  " --lines 12 --width 70 \
    | cliphist decode \
    | wl-copy
