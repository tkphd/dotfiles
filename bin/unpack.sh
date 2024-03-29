#!/bin/bash
set -e

if [[ $# -eq 0 ]] || [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    echo "Usage: $0 «archive-file-name» «destination-folder»"
    exit 1
fi

fname="$1"
dname="${PWD}"

[[ $# -eq 2 ]] && \
    dname="$2"
[[ ! -d "${dname}" ]] && \
    mkdir "${dname}"

echo "Unpacking ${fname} into ${dname}"

fname=$(readlink -f "${fname}") # convert to full absolute path
meta=$(file -b "${fname}")

if [[ $(echo "${meta}" | grep gzip) != "" ]]; then
    tar xvaf "${fname}" -C "${dname}" && rm "${fname}"
elif [[ $(echo "${meta}" | grep RAR) != "" ]]; then
    cd "${dname}"
    unrar e "${fname}" && rm "${fname}"
elif [[ $(echo "${meta}" | grep tar) != "" ]]; then
    tar xvaf "${fname}" && rm "${fname}"
elif [[ $(echo "${meta}" | grep XZ) != "" ]]; then
    unxz "${fname}" && mv "${fname/.xz/}" "${dname}"
elif [[ $(echo "${meta}" | grep Zip) != "" ]]; then
    unzip "${fname}" -d "${dname}" && rm "${fname}"
else
    echo "Unrecognized archive, unable to proceed: ${meta}"
fi
