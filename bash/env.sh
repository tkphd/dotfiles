#!/bin/bash

if [[ -n "${ENV_SOURCED}" ]]; then
    return
fi

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
# === Conda & Mamba ===
[[ -f "${HOME}/.dotfiles/bash/mamba.sh" ]] && \
    source "${HOME}/.dotfiles/bash/mamba.sh"
# === Emacs ===
export EMACSD="/tmp/${USER}/emacs"
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
# # === Go ===
# [[ -d "/opt/go" ]] && \
#     export PATH="/opt/go/bin:${PATH}"
# === Haskell ===
[[ -f "${HOME}/.ghcup/env" ]] && \
    source "${HOME}/.ghcup/env" # ghcup-env
# === KDE ===
export KDE_FULL_SESSION=false
export KDEWM=/usr/bin/i3
# === less ===
[[ $(which pygmentize) != "" ]] && \
    export LESSOPEN="| pygmentize -g %s"
# === Lmod ===
if [[ -f /etc/profile.d/lmod.sh ]]; then
    . /etc/profile.d/lmod.sh
    for DIR in /toolbox /working; do
        [[ -d ${DIR}/${USER}/modules/modulefiles ]] && \
            module use ${DIR}/${USER}/modules/modulefiles
    done
fi
# === MMSP ===
export MMSP_PATH="${HOME}/research/projects/mmsp"
export PATH="${PATH}:${MMSP_PATH}/utility"
# === NIX ===
[[ -d "${HOME}/.nix-profile/etc/profile.d" ]] && \
    source "${HOME}/.nix-profile/etc/profile.d/nix.sh"
# === Node ===
if [[ -d "${HOME}/.nvm" ]]; then
    export NVM_DIR="${HOME}/.nvm"
    [ -s "${NVM_DIR}/nvm.sh" ] && \
        source "${NVM_DIR}/nvm.sh"  # This loads nvm
    [ -s "${NVM_DIR}/bash_completion" ] && \
        source "${NVM_DIR}/bash_completion"  # This loads nvm bash_completion
fi
# === OpenSCAD ===
[[ -d "${HOME}/repositories/dotSCAD" ]] && \
    export OPENSCADPATH="${HOME}/repositories/dotSCAD/SRC:${OPENSCADPATH}"
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
    [[ -n "${LD_LIBRARY_PATH}" ]] && \
        RISCV_LIB="${LD_LIBRARY_PATH}:${RISCV_LIB}"
    export LD_LIBRARY_PATH="${RISCV_LIB}"
fi
# === Ruby Version Manager ===
if [[ -d "${HOME}/.rvm" ]]; then
    RVMDIR="${HOME}/.rvm"
    export PATH="${PATH}:${RVMDIR}/bin"
    if [[ -a "${RVMDIR}/rubies/default" ]]; then
        RUBYDIR="$(realpath ${RVMDIR})/rubies/default"
        export PATH="${RUBYDIR}/bin:${PATH}"
    fi
fi
# === Rust ===
[[ -e "${HOME}/.cargo/env" ]] && \
    source "${HOME}/.cargo/env"
# === Singularity ===
if [[ -d "/working/${USER}" ]]; then
    export SINGULARITY_TMPDIR="/working/${USER}/scratch/singularity/tmp"
    export SINGULARITY_CACHEDIR="/working/${USER}/scratch/singularity/cache"
    [[ -d "${SINGULARITY_TMPDIR}" ]] || mkdir -p "${SINGULARITY_TMPDIR}"
    [[ -d "${SINGULARITY_CACHEDIR}" ]] || mkdir -p "${SINGULARITY_TMPDIR}"
fi
# === SUDO ===
export SUDO_PROMPT=$(echo -e "\e[0;34m[Enter \e[0;36m${USER}'s\e[0;34m password to \e[0;35msudo\e[0;34m]:\e[0;39m ")
# === SSH ===
export SSH_ASKPASS="/usr/bin/ssh-askpass"
# === Systemd ===
export SYSTEMD_PAGER=  # disable systemctl's auto-paging feature
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
    export LIBGL_ALWAYS_INDIRECT=1
fi

export ENV_SOURCED=1
