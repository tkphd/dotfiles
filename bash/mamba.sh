#!/bin/bash

if [[ -n "${CONDAPATH}" ]]; then
    return
fi

# === Conda & Mamba ===
for TESTDIR in "/toolbox/${USER}" "/working/${USER}"
do
    if [[ -z "${CONDAPATH}" ]]; then
        [[ -h "${TESTDIR}" ]] \
            && TESTDIR="$(readlink ${TESTDIR})"
        if [[ -d "${TESTDIR}" ]]; then
            TESTDIR="${TESTDIR}/opt/mambaforge"
            if [[ -d "${TESTDIR}" ]]; then
                export CONDAPATH="${TESTDIR}"
                _setup="$(${CONDAPATH}/bin/conda 'shell.bash' 'hook' 2> /dev/null)"
                if [ $? -eq 0 ]; then
                    eval "$_setup"
                else
                    if [ -f "${CONDAPATH}/etc/profile.d/conda.sh" ]; then
                        . "${CONDAPATH}/etc/profile.d/conda.sh"
                    else
                        export PATH="${CONDAPATH}/bin:$PATH"
                    fi
                fi
                unset _setup

                if [ -f "${CONDAPATH}/etc/profile.d/mamba.sh" ]; then
                    . "${CONDAPATH}/etc/profile.d/mamba.sh"
                    alias mambact="mamba activate"
                    alias deact="mamba deactivate"
                else
                    alias condact="conda activate"
                    alias deact="conda deactivate"
                fi
            fi
        fi
    fi
done
