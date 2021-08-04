#!/bin/bash

ulimit -s unlimited
export OMP_NUM_THREADS=$(( nproc / 2 ))

source "${CONDAPATH}/etc/profile.d/conda.sh"

conda activate freecad

freecad &> "${HOME}/log/freecad.log"

conda deactivate
