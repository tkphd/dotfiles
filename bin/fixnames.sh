#!/bin/bash
# Remove spaces from filenames

for T in d f; do
    find . -type $T | \
    while read X; do
        if [[ -e "$X" ]]; then
            A=$(basename "$X")
            B=$(dirname "$X")
            O=$(echo "${A}" | tr -s ' ,()[]' '------')
            O="${O/-./.}"
            if [[ "${A}" != "${O}" ]]; then
                echo "Rename ${B}/ ${A} --> ${O}"
                mv "${B}/${A}" "${B}/${O}"
            fi
        fi
    done
done
