#!/bin/bash -l

CPUTHR=$(nproc --all)
CPUCOR=$(( CPUTHR/2 ))

ulimit -s unlimited
export OMP_NUM_THREADS=$CPUCOR

if [[ -f /etc/profile.d/lmod.sh ]]; then
    . /etc/profile.d/lmod.sh
    [ -d "${HOME}/research/modules" ] && \
        module use "${HOME}/research/modules/modulefiles"
fi

module load conda || exit

conda activate freecad || exit

freecad

conda deactivate
