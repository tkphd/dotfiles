#!/bin/bash

# === Local Binaries ===
[[ -d "${HOME}/bin" ]] && \
    export PATH="${HOME}/bin:${PATH}"
# === Crypto Tokens ===
[[ -f ${HOME}/.dotfiles/local/tokens ]] && \
    source "${HOME}/.dotfiles/local/tokens"

# === BeeGFS ===
[[ -d /opt/beegfs ]] && \
    export PATH="${PATH}:/opt/beegfs/sbin"
# === Borg ===
export BORG_RSH="ssh -i ${HOME}/.ssh/danger_borg_rsa"
# === Conda ===
if [[ -a "${HOME}/.conda/anaconda" ]]; then
    CONDAPATH=$(readlink -f "${HOME}/.conda/anaconda")
    __conda_setup="$('${CONDAPATH}/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
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
elif [[ -a "/working/${USER}/opt/mambaforge" ]]; then
    CONDAPATH="/working/${USER}/opt/mambaforge"
    __conda_setup="$('${CONDAPATH}/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
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

    if [ -f "${CONDAPATH}/etc/profile.d/mamba.sh" ]; then
        . "${CONDAPATH}/etc/profile.d/mamba.sh"
    fi
    export CONDAPATH
fi
# === CUDA ===
[[ -d "${HOME}/.dotfiles/local" && -f "${HOME}/.dotfiles/local/cudarch.sh" ]] && \
    source "${HOME}/.dotfiles/local/cudarch.sh"
CUDA_TEST_PATH=$(find /usr/local/cuda* -name nvcc 2>/dev/null)
if [[ ${CUDA_HDR_PATH} == "" && ${CUDA_TEST_PATH} != "" ]]; then
    NVCCBIN=$(dirname $(ls -t "${CUDA_TEST_PATH}" 2>/dev/null | head -n 1))
    if [[ $NVCCBIN != "" ]]; then
        export PATH="${PATH}:${NVCCBIN}"
        export CUDA_HDR_PATH=$(dirname "${NVCCBIN}")/targets/x86_64-linux/include
        CUDA_LIB=$(dirname "${CUDA_HDR_PATH}/lib")
        [[ -v LD_LIBRARY_PATH && -n "${LD_LIBRARY_PATH}" ]] && \
            CUDA_LIB="${LD_LIBRARY_PATH}:${CUDA_LIB}"
        export LD_LIBRARY_PATH="${CUDA_LIB}"
    fi
    if [[ $CUDA_HDR_PATH == "" ]]; then
        NVCCBIN=$(dirname $(ls -t $(find /opt/cuda -name nvcc 2>/dev/null) 2>/dev/null | head -n 1))
        if [[ $NVCCBIN != "" ]]; then
            export PATH="${PATH}:${NVCCBIN}"
            export CUDA_HDR_PATH=$(dirname "${NVCCBIN}")/targets/x86_64-linux/include
            CUDA_LIB=$(dirname "${CUDA_HDR_PATH}/lib")
            [[ -v LD_LIBRARY_PATH && -n "${LD_LIBRARY_PATH}" ]] && \
                CUDA_LIB="${LD_LIBRARY_PATH}:${CUDA_LIB}"
            export LD_LIBRARY_PATH="${CUDA_LIB}"
        fi
    fi
    if [[ $CUDA_HDR_PATH == "" && $(which nvcc) != "" ]]; then
        export CUDA_HDR_PATH=/usr/include
    fi
    [[ $(which nvcc) != "" ]] && \
        export OMPI_MCA_opal_cuda_support=true # enable OpenMPI CUDA awareness
fi
# === Emacs ===
export EMACSD="/tmp/emacs-${USER}"
export EMACSBD="${EMACSD}/backups"
export EMACSSD="${EMACSD}/saves"
if [[ ! -d "${EMACSD}" ]]; then
    mkdir -p "${EMACSD}"
    mkdir -p "${EMACSBD}"
    mkdir -p "${EMACSSD}"
fi
# === GCC ===
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
# === GITHUB ===
[[ -f "${HOME}/.github" ]] && \
    source "${HOME}/.github" # personal access token(s)
# === Go ===
[[ -d "/opt/go" ]] && \
    export PATH="/opt/go/bin:${PATH}"
# === Haskell ===
[[ -f "${HOME}/.ghcup/env" ]] && \
    source "${HOME}/.ghcup/env" # ghcup-env
# === KDE ===
export KDE_FULL_SESSION=false
export KDEWM=/usr/bin/i3
# === LESS ===
[[ $(which pygmentize) != "" ]] && \
    export LESSOPEN="| pygmentize -g %s"
# === Lmod ===
[[ -d /working/${USER}/modules/modulefiles ]] && \
    [[ -f /etc/profile.d/lmod.sh ]] && \
        source /etc/profile.d/lmod.sh && \
        module use /working/${USER}/modules/modulefiles
# === MMSP ===
export MMSP_PATH="${HOME}/research/projects/mmsp"
export PATH="${PATH}:${MMSP_PATH}/utility"
# === NIX ===
[[ -d "${HOME}/.nix-profile/etc/profile.d" ]] && \
    source "${HOME}/.nix-profile/etc/profile.d/nix.sh"
# === OpenMP ===
export OMP_NUM_THREADS=$(( $(nproc) / 2 ))
# === PGI ===
if [[ -f "/opt/pgi/license.dat" ]]; then
    export PGI_PATH="/opt/pgi/linux86-64-llvm/19.10"
    export LM_LICENSE_FILE="/opt/pgi/license.dat"
    export PATH="${PATH}:/opt/pgi/linux86-64-llvm/19.10/bin"
fi
# === Python ===
export PYTHONPYCACHEPREFIX=/tmp/${USER}/pycache
export PYTHONWARNINGS=default
[[ ! -d ${PYTHONPYCACHEPREFIX} ]] && \
    mkdir -p ${PYTHONPYCACHEPREFIX}
# === Qt ===
export QT_XKB_CONFIG_ROOT="/usr/share/X11/xkb"
if [[ -d "/usr/local/lib/plugins/platforms" ]]; then
   export QT_QPA_PLATFORM_PLUGIN_PATH="/usr/local/lib/plugins/platforms"
elif [[ -d "/usr/lib/x86_64-linux-gnu/qt5/plugins/platforms" ]]; then
   export QT_QPA_PLATFORM_PLUGIN_PATH="/usr/lib/x86_64-linux-gnu/qt5/plugins/platforms"
fi
# === RISC V ===
if [[ -d /opt/riscv ]]; then
    export PATH="${PATH}:/opt/riscv/bin"
    RISCV_LIB="/opt/riscv/lib"
    [[ -v LD_LIBRARY_PATH ]] && \
    [[ -n "${LD_LIBRARY_PATH}" ]] && \
        RISCV_LIB="${LD_LIBRARY_PATH}:${RISCV_LIB}"
    export LD_LIBRARY_PATH="${RISCV_LIB}"
fi
# === Ruby ===
if [[ -d "${HOME}/gems" ]]; then
    export GEM_HOME="${HOME}/gems"
    export PATH="${HOME}/gems/bin:${PATH}"
fi
# === Ruby Version Manager ===
[[ -d "${HOME}/.rvm" ]] && \
    export PATH="${PATH}:${HOME}/.rvm/bin"
# === Rust ===
[[ -e "${HOME}/.cargo/env" ]] && \
    source "${HOME}/.cargo/env"
# === Singularity ===
export SINGULARITY_TMPDIR="/working/${USER}/scratch/singularity/tmp"
export SINGULARITY_CACHEDIR="/working/${USER}/scratch/singularity/cache"
if [[ -d "/working" ]]; then
    [[ -d "${SINGULARITY_TMPDIR}" ]] || mkdir -p "${SINGULARITY_TMPDIR}"
    [[ -d "${SINGULARITY_CACHEDIR}" ]] || mkdir -p "${SINGULARITY_TMPDIR}"
fi
## === Spack ===
#export SPACK_SKIP_MODULES=1
#if [[ -d "/working/${USER}/repositories/spack" ]]; then
#    source "/working/${USER}/repositories/spack/share/spack/setup-env.sh"
#elif [[ -d "${HOME}/repositories/spack/share/spack" ]]; then
#    source "${HOME}/repositories/spack/share/spack/setup-env.sh"
#fi
#if [[ $(which spack) != "" ]]; then
#    export MPLBACKEND=agg
#    export OPENBLAS_NUM_THREADS=1
#    export OMPI_MCA_rmaps_base_oversubscribe=1
#    export OMPI_MCA_plm=isolated
#    export OMPI_MCA_btl_vader_single_copy_mechanism=none
#    export OMPI_MCA_mpi_yield_when_idle=1
#    export OMPI_MCA_hwloc_base_binding_policy=none
#fi
# === SUDO ===
export SUDO_PROMPT=$(echo -e "\e[0;34m[Enter \e[0;36m${USER}'s\e[0;34m password to \e[0;35msudo\e[0;34m]:\e[0;39m ")
# === SSH ===
export SSH_ASKPASS="/usr/bin/ssh-askpass"
# === Systemd ===
# Disable systemctl's auto-paging feature:
export SYSTEMD_PAGER=
# === Thermo-Calc ===
if [[ -d "${HOME}/Thermo-Calc/2020a/" ]]; then
    export TC20A_HOME="${HOME}/Thermo-Calc/2020a/"
    export PATH="${PATH}:${HOME}/Thermo-Calc/2020a/SDK/TCAPI:${HOME}/Thermo-Calc/2020a/SDK/TQ"
    export LSERVRC="${HOME}/Thermo-Calc/lservrc"
    export LSHOST="NO-NET"
fi
# === Machine-specific Tasks ===
if [[ $(hostname -s) == "p859561" ]]; then
    unset MAIL
    export CHROME_CONFIG_HOME="/usr/local/${USER}"
    export CHROME_USER_DATA_HOME="/usr/local/${USER}/google-chrome"
    export AMGX_DIR="/usr/local/${USER}/opt/AMGX"
    #export GSL_PATH="${HOME}/.conda/envs/mmsp/include"
    #export MPI_PATH="${HOME}/.conda/envs/mmsp/include"
    export LIBGL_ALWAYS_INDIRECT=1
fi
