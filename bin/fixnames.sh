#!/bin/bash
# Remove spaces from filenames

D=""

for T in d f; do
    find . -type $T | \
    while read X; do
        if [[ -e "$X" ]]; then
            A=$(basename "$X")
            B=$(dirname "$X")
            O=$(echo "${A}" | tr -s ' ,()[]&' '------')
            O="${O/-./.}"
            if [[ "${B}" != "${D}" ]]; then
                D="${B}"
                echo "${D}/:"
            fi
            if [[ "${A}" != "${O}" ]]; then
                echo "  ${A} --> ${O}"
                mv "${B}/${A}" "${B}/${O}"
            fi
        fi
    done
done
