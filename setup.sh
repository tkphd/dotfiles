#!/bin/bash

echo -ne "DANGER! This script will overwrite ~/.bashrc, and other config files.\n\nType \"yes\" to continue: "
read EULA

if [[ "${EULA}" == "yes" || "${EULA}" == "\"yes\"" ]]; then

    DIR=$(pwd)

    # === bash ===
    if [[ -f ${HOME}/.bashrc || -L ${HOME}/.bashrc ]]; then
        rm ${HOME}/.bashrc
    fi
    ln -s ${DIR}/bash/bashrc ${HOME}/.bashrc

    # === conda ===
    if [[ -f ${HOME}/.condarc || -L ${HOME}/.condarc ]]; then
        rm ${HOME}/.condarc
    fi
    ln -s ${DIR}/conda/condarc ${HOME}/.condarc

    # === emacs ===
    if [[ -d ${HOME}/.emacs.d ]]; then
        rm -rf ${HOME}/.emacs.d
    elif [[ -f ${HOME}/.emacs.d || -L ${HOME}/.emacs.d ]]; then
        rm ${HOME}/.emacs.d
    fi
    ln -s ${DIR}/emacs ${HOME}/.emacs.d

    # === gdb ===
    if [[ -f ${HOME}/.gdbinit || -L ${HOME}/.gdbinit ]]; then
        rm ${HOME}/.gdbinit
    fi
    ln -s ${DIR}/gdb/gdbinit ${HOME}/.gdbinit

    # === git ===
    if [[ -f ${HOME}/.gitconfig || -L ${HOME}/.gitconfig ]]; then
        rm ${HOME}/.gitconfig
    fi
    ln -s ${DIR}/git/gitconfig ${HOME}/.gitconfig

    # === i3wm ===
    if [[ -d ${HOME}/.config/i3 ]]; then
        rm -rf ${HOME}/.config/i3
    elif [[ -f ${HOME}/.config/i3 || -L ${HOME}/.config/i3 ]]; then
        rm ${HOME}/.config/i3
    fi
    ln -s ${DIR}/i3wm ${HOME}/.config/i3

    ## === urxvt ===
    if [[ -d ${HOME}/.urxvt/ext/font-size ]]; then
        rm -rf ${HOME}/.urxvt/ext/font-size
    elif [[ -f ${HOME}/.urxvt/ext/font-size || -L ${HOME}/.urxvt/ext/font-size ]]; then
        rm ${HOME}/.urxvt/ext/font-size
    fi
    ln -s ${DIR}/i3wm/urxvt-font-size/font-size ${HOME}/.urxvt/ext/font-size

    ## === Xresources ===
    if [[ -f ${HOME}/.Xresources || -L ${HOME}/.Xresources ]]; then
        rm ${HOME}/.Xresources
    fi
    if [[ -f ${HOME}/.Xdefaults ]]; then
        rm ${HOME}/.Xdefaults
    fi
    ln -s ${DIR}/i3wm/Xresources ${HOME}/.Xresources
    ln -s ${DIR}/i3wm/Xresources ${HOME}/.Xdefaults
else
    echo "No changes were made."
fi
