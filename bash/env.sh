#!/bin/bash

if [[ -n "${ENV_SOURCED}" ]]; then
    return
fi

# === Local Binaries ===
[[ -d "${HOME}/bin" ]] && [[ ! $PATH =~ .*/$USER/bin* ]] && \\
    export PATH="${HOME}/bin:${PATH}"
# === Snap Binaries ===
[[ -d "/snap/bin" ]] && [[ ! $PATH =~ .*/snap* ]] && \
    export PATH="/snap/bin:${PATH}"
# === AMGX ===
AMGX_DIR=/toolbox/${USER}/opt/amgx
[ -d "${AMGX_DIR}" ] && \
    export AMGX_DIR
# === BeeGFS ===
[[ -d /opt/beegfs ]] && [[ ! $PATH =~ .*/opt/beegfs* ]] && \
    export PATH="${PATH}:/opt/beegfs/sbin"
# === Borg ===
export BORG_RSH="ssh -i ${HOME}/.ssh/danger_borg_rsa"
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
# === Haskell ===
[[ -f "${HOME}/.ghcup/env" ]] && \
    source "${HOME}/.ghcup/env" # ghcup-env
# === KDE ===
# export KDE_FULL_SESSION=false
# export KDEWM=/usr/bin/i3
# === less ===
# termcap  terminfo  effect
# ks       smkx      make the keypad send commands
# ke       rmkx      make the keypad send digits
# vb       flash     emit visual bell
# mb       blink     start blink: green
# md       bold      start bold: cyan
# me       sgr0      turn off bold, blink and underline
# so       smso      start standout (reverse video): yellow-on-blue
# se       rmso      stop standout
# us       smul      start underline: white
# ue       rmul      stop underline
LESS_TERMCAP_mb=$(tput bold; tput setaf 2)               && export LESS_TERMCAP_mb
LESS_TERMCAP_md=$(tput bold; tput setaf 6)               && export LESS_TERMCAP_md
LESS_TERMCAP_me=$(tput sgr0)                             && export LESS_TERMCAP_me
LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) && export LESS_TERMCAP_so
LESS_TERMCAP_se=$(tput rmso; tput sgr0)                  && export LESS_TERMCAP_se
LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7)    && export LESS_TERMCAP_us
LESS_TERMCAP_ue=$(tput rmul; tput sgr0)                  && export LESS_TERMCAP_ue
LESS_TERMCAP_mr=$(tput rev)                              && export LESS_TERMCAP_mr
LESS_TERMCAP_mh=$(tput dim)                              && export LESS_TERMCAP_mh
LESS_TERMCAP_ZN=$(tput ssubm)                            && export LESS_TERMCAP_ZN
LESS_TERMCAP_ZV=$(tput rsubm)                            && export LESS_TERMCAP_ZV
LESS_TERMCAP_ZO=$(tput ssupm)                            && export LESS_TERMCAP_ZO
LESS_TERMCAP_ZW=$(tput rsupm)                            && export LESS_TERMCAP_ZW
GROFF_NO_SGR=1                                           && export GROFF_NO_SGR
[[ $(which pygmentize) != "" ]] && \
    export LESSOPEN="| pygmentize -g %s"
# === Modules ===
if [[ -f /etc/profile.d/lmod.sh ]]; then
    . /etc/profile.d/lmod.sh
    [ -d "/toolbox/${USER}/modules" ] && \
        module use "/toolbox/${USER}/modules"
fi
# === MMSP ===
export MMSP_PATH="${HOME}/research/projects/mmsp"
[[ ! $PATH =~ .*mmsp* ]] && \
    export PATH="${PATH}:${MMSP_PATH}/utility"
# === Nix ===
[ -e "${HOME}/.nix-profile/etc/profile.d/nix.sh" ] && \
    . "${HOME}/.nix-profile/etc/profile.d/nix.sh"
# === Node ===
if [[ -d "${HOME}/.nvm" ]]; then
    export NVM_DIR="${HOME}/.nvm"
    [ -s "${NVM_DIR}/nvm.sh" ] && \
        source "${NVM_DIR}/nvm.sh"  # This loads nvm
    [ -s "${NVM_DIR}/bash_completion" ] && \
        source "${NVM_DIR}/bash_completion"  # This loads nvm bash_completion
fi
# === OpenSCAD plugins ===
if [[ -d "${HOME}/repositories/dotSCAD" ]]; then
    DOTSCADPATH="${HOME}/repositories/dotSCAD/src"
    if [[ -n "${OPENSCADPATH}" ]]; then
        export OPENSCADPATH="${OPENSCADPATH}:${DOTSCADPATH}"
    else
        export OPENSCADPATH="${DOTSCADPATH}"
    fi
    unset DOTSCADPATH
fi
# === Python ===
export PYTHONPYCACHEPREFIX="/tmp/${USER}/pycache"
export PYTHONWARNINGS=default
[[ ! -d "${PYTHONPYCACHEPREFIX}" ]] && \
    mkdir -p "${PYTHONPYCACHEPREFIX}"
# === Qt ===
export QT_XKB_CONFIG_ROOT="/usr/share/X11/xkb"
if [[ -d "/usr/local/lib/plugins/platforms" ]]; then
   export QT_QPA_PLATFORM_PLUGIN_PATH="/usr/local/lib/plugins/platforms"
elif [[ -d "/usr/lib/x86_64-linux-gnu/qt5/plugins/platforms" ]]; then
   export QT_QPA_PLATFORM_PLUGIN_PATH="/usr/lib/x86_64-linux-gnu/qt5/plugins/platforms"
fi
# === RISC V ===
if [[ -d /opt/riscv ]]; then
    [[ ! $PATH =~ .*/opt/riscv* ]] && \
        export PATH="${PATH}:/opt/riscv/bin"
    RISCV_LIB="/opt/riscv/lib"
    [[ -n "${LD_LIBRARY_PATH}" ]] && \
        RISCV_LIB="${LD_LIBRARY_PATH}:${RISCV_LIB}"
    export LD_LIBRARY_PATH="${RISCV_LIB}"
fi
# === Ruby ===
[ -d "${HOME}/.rvm/bin" ] && [[ ! $PATH =~ .*/.rvm* ]] && \
    export PATH="${PATH}:${HOME}/.rvm/bin"
[ -s "$HOME/.rvm/scripts/rvm" ] && \
    . "$HOME/.rvm/scripts/rvm"
# === Singularity ===
if [[ -d "/working/${USER}" ]]; then
    export SINGULARITY_TMPDIR="/working/${USER}/scratch/singularity/tmp"
    export SINGULARITY_CACHEDIR="/working/${USER}/scratch/singularity/cache"
    [[ -d "${SINGULARITY_TMPDIR}" ]] || mkdir -p "${SINGULARITY_TMPDIR}"
    [[ -d "${SINGULARITY_CACHEDIR}" ]] || mkdir -p "${SINGULARITY_TMPDIR}"
fi
# === SSH ===
SSH_ASKPASS="/usr/bin/ssh-askpass" && export SSH_ASKPASS
# === Systemd ===
# export SYSTEMD_PAGER=  # uncomment to disable systemctl's auto-paging feature

export ENV_SOURCED=1
