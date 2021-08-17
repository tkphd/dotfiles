#!/bin/bash
set -e
for f in "$@"; do
    pygmentize -O style='lovelace' -g "${f}"
done
