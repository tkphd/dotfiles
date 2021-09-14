#!/bin/bash
set -e
ulimit -s unlimited
export OMP_NUM_THREADS=$(( $(nproc) / 2 ))

flatpak run org.paraview.ParaView 1>/dev/null 2> "${HOME}/log/paraview.log"
