#!/bin/bash
# Remove spaces from filenames

BASE=""

for T in d f; do
    find . -type $T | \
    while read X; do
        if [[ -e "$X" ]]; then
            LEAF=$(basename "$X")  # filename
            STEM=$(dirname "$X")  # directory name
            BUD=$(echo "${LEAF}" | tr -s ' ,()[]&!' '------')  # replace special chars
            BUD="${BUD/-./.}"  # remove trailing '-'
            BUD="${BUD#-}"  # remove leading '-'
            if [[ "${STEM}" != "${BASE}" ]]; then
                BASE="${STEM}"
                echo "${BASE}/:"
            fi
            if [[ "${LEAF}" != "${BUD}" ]]; then
                echo "  ${LEAF} --> ${BUD}"
                mv "${STEM}/${LEAF}" "${STEM}/${BUD}"
            fi
        fi
    done
done
