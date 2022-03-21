#!/bin/bash

ulimit -s unlimited
export OMP_NUM_THREADS=4

if [[ -a ${CONDAPATH} ]]; then
    for script in ${CONDAPATH}/etc/profile.d/{conda,mamba}.sh; do
        [[ -f "${script}" ]] && \
            source "${script}"
    done

    mamba activate apps

    freecad

    mamba deactivate
fi
