#!/bin/bash
# Replaces `flameshot gui`: select a region, then annotate/save/copy in swappy.
# Escape during selection cancels cleanly.
geom=$(slurp -b 1b1e22cc -c 6ea8deff -s 6ea8de22 -w 2) || exit 0
grim -g "$geom" - | swappy -f -
