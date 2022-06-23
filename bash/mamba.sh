#!/bin/bash

if [[ -n "${CONDAPATH}" ]]; then
    return
fi

# === Conda & Mamba ===
for TRYME in "/working/${USER}/opt/mambaforge" "/toolbox/${USER}/opt/mambaforge";
do
    if [[ -z "${CONDAPATH}" ]]; then
        if [[ -a "${TRYME}" ]]; then
            CONDAPATH="${TRYME}"
            __setup="$(${CONDAPATH}/bin/conda shell.bash hook 2> /dev/null)"
            if [ $? -eq 0 ]; then
                eval "$__setup"
            else
                if [ -f "${CONDAPATH}/etc/profile.d/conda.sh" ]; then
                    . "${CONDAPATH}/etc/profile.d/conda.sh"
                else
                    export PATH="${CONDAPATH}/bin:$PATH"
                fi
            fi
            unset __setup
            if [ -f "${CONDAPATH}/etc/profile.d/mamba.sh" ]; then
                . "${CONDAPATH}/etc/profile.d/mamba.sh"
                alias mambact="mamba activate"
                alias deact="mamba deactivate"
            else
                alias condact="conda activate"
                alias deact="conda deactivate"
            fi
            export CONDAPATH
        fi
    fi
done
