#!/bin/bash
set -e
if [[ $# -eq 1 ]]; then
    fname=$1
    if [[ -a "$1" ]]; then
	sudo dpkg -i "${fname}" && rm "${fname}"
        sudo apt --fix-broken install
    else
	echo "No such file: ${1}"
    fi
else
    echo "Usage: $0 file.deb"
fi
