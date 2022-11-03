#!/bin/bash
set -e
for f in "$@"; do
    # pygmentize -O style='lovelace' -g "${f}"
    pygmentize -O style='github-dark' -g "${f}"
done
