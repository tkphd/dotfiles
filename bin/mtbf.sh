#!/bin/bash
# list uptime durations

journalctl --list-boots | \
    awk 'NR > 1 {print $4"T"$5" "$8"T"$9}' | \
    while read t1 t2; do
        echo $(( "$(date +"%s" -s "$t2")" - "$(date +"%s" -s "$t1")" ))
    done
