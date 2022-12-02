#!/bin/bash -l

CPUTHR=$(nproc --all)
CPUCOR=$((${CPUTHR}/2))

ulimit -s unlimited
export OMP_NUM_THREADS=$CPUCOR

flatpak run com.prusa3d.PrusaSlicer || exit 1
