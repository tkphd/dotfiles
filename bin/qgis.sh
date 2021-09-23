#!/bin/bash

ulimit -s unlimited
export OMP_NUM_THREADS=$(( $(nproc) / 2 ))

CONDAPATH="${HOME}/.conda/anaconda"
source "${CONDAPATH}/etc/profile.d/conda.sh"

conda activate apps

qgis

conda deactivate
