#!/bin/bash
geom=$(slurp -b 1b1e22cc -c 6ea8deff -s 6ea8de22 -w 2) || exit 0
grim -g "$geom" - | swappy -f -
