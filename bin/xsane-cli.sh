#!/bin/bash
# CLI to XSANE, since the GUI is being a tosser.
# Scan size assumes standard letter paper:
# W = 8.5 in = 216 mm
# H = 11  in = 279 mm
set -e
if [[ $# != 1 ]]; then
    echo "Usage: $0 filename.png"
else
    scanimage -x 216 -y 279 --resolution 300dpi --format=png > $1
fi
