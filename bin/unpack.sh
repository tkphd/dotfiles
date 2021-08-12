#!/bin/bash

if [[ $# -eq 2 ]]; then
    fname=$1
    dname=$2
    echo "Unpacking ${fname} into ${dname}"
    meta=$(file -b "${fname}")
    echo "${meta}"
    if [[ $(echo "${meta}" | grep gzip) != "" ]]; then
        tar xvaf "${fname}" -C "${dname}/" && rm "${fname}"
    elif [[ $(echo "${meta}" | grep Zip) != "" ]]; then
        unzip "${fname}" -d "${dname}/" && rm "${fname}"
    elif [[ $(echo "${meta}" | grep XZ) != "" ]]; then
        unxz "${fname}" && mv "${fname/.xz/}" "${dname}"
    elif [[ $(echo "${meta}" | grep tar) != "" ]]; then
        tar xvaf "${fname}" && rm "${fname}"
    fi
else
    echo "Usage: $0 file.zip dest/"
fi
