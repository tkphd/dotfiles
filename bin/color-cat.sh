#!/bin/bash

for f in "$@"; do
    pygmentize -O style='lovelace' -g "${f}"
done
