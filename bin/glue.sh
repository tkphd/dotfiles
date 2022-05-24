#!/bin/bash

module use /working/${USER}/modules/modulefiles
module load petsc fenics

glue

module purge
