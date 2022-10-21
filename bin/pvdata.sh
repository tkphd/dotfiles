#!/bin/bash -l
# launch a ParaView data server

CPUTHR=$(nproc --all)
CPUCOR=$((${CPUTHR}/2))

ulimit -s unlimited
export OMP_NUM_THREADS=$CPUCOR

NCPU=1

for TRYME in "/toolbox/${USER}/opt/mambaforge" "/working/${USER}/opt/mambaforge" "/Valhalla/opt/mambaforge" "/working/${USER}/opt/anaconda";
do
    if [[ -z $CONDAPATH ]]; then
        if [[ -a "${TRYME}" ]]; then
            CONDAPATH="${TRYME}"
            __conda_setup="$(${CONDAPATH}/bin/conda shell.bash hook 2> /dev/null)"
           if [ $? -eq 0 ]; then
               eval "$__conda_setup"
           else
               if [ -f "${CONDAPATH}/etc/profile.d/conda.sh" ]; then
                   . "${CONDAPATH}/etc/profile.d/conda.sh"
               else
                   export PATH="${CONDAPATH}/bin:$PATH"
               fi
           fi
           unset __conda_setup
           export CONDAPATH
        fi
    fi
done

if [[ -a "${CONDAPATH}" ]]; then
    LOG="${HOME}/pvserver_$(hostname).log"

    for script in ${CONDAPATH}/etc/profile.d/{conda,mamba}.sh; do
        [[ -f "${script}" ]] && \
            source "${script}"
    done

    mamba activate paraview

    if [[ $# == 1 ]]; then
        if ! [[ "$1" =~ ^[0-9]+$ ]]; then
            # Argument is not numeric
            pvdataserver $1
        elif [[ "$1" == "-h" || "$1" == "--help" ]]; then
            echo "Usage: ${0} <cores>"
        else
            NCPU=$1
            echo "Using ${NCPU} cores"
            mpirun -np ${NCPU} pvserver
        fi
    else
        pvdataserver --hostname ${HOST} --no-mpi
    fi

    mamba deactivate
else
    echo "ERROR: Unable to load paraview environment with Mambaforge"
fi
