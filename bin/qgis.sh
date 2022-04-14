#!/bin/bash

ulimit -s unlimited
export OMP_NUM_THREADS=$(( $(nproc) / 2 ))

for TRYME in "/toolbox/${USER}/opt/mambaforge" "/working/${USER}/opt/mambaforge" "/Valhalla/opt/mambaforge";
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
    for script in ${CONDAPATH}/etc/profile.d/{conda,mamba}.sh; do
        [[ -f "${script}" ]] && \
            source "${script}"
    done

    mamba activate apps

    qgis

    mamba deactivate
else
    echo "ERROR: Unable to load apps environment with Mambaforge"
fi
