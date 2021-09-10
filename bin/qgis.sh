#!/bin/bash
set -e
ulimit -s unlimited
export OMP_NUM_THREADS=$(( $(nproc) / 2 ))
export CONDAPATH=$(readlink -f "${HOME}/.conda/anaconda")

source "${CONDAPATH}/etc/profile.d/conda.sh"

conda activate apps

qgis 1>/dev/null 2> "${HOME}/log/qgis.log"

conda deactivate
