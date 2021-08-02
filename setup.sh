#!/bin/bash

echo -ne "DANGER! This script will overwrite ~/.bashrc, and other config files.\n\nType \"yes\" to continue: "
read DISCLAIMER

if [[ "${DISCLAIMER}" == "yes" || "${DISCLAIMER}" == "\"yes\"" ]]; then

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

    if [[ -f ${HOME}/.mambarc || -L ${HOME}/.mambarc ]]; then
        rm ${HOME}/.mambarc
    fi
    ln -s ${DIR}/conda/mambarc ${HOME}/.mambarc


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
    if [[ ! -d ${HOME}/.config/git/template ]]; then
        mkdir -p ${HOME}/.config/git/template
        echo "ref: refs/heads/main" > ${HOME}/.config/git/template/HEAD
    fi
    ln -s ${DIR}/git/gitconfig ${HOME}/.gitconfig

    # === i3wm ===
    if [[ -d ${HOME}/.config/i3 ]]; then
        rm -rf ${HOME}/.config/i3
    elif [[ -f ${HOME}/.config/i3 || -L ${HOME}/.config/i3 ]]; then
        rm ${HOME}/.config/i3
    fi
    ln -s ${DIR}/i3wm ${HOME}/.config/i3

    # === kitty ===
    if [[ -d ${HOME}/.config/kitty ]]; then
        rm -rf ${HOME}/.config/kitty
    elif [[ -f ${HOME}/.config/kitty || -L ${HOME}/.config/kitty ]]; then
        rm ${HOME}/.config/kitty
    fi
    ln -s ${DIR}/kitty ${HOME}/.config/kitty

    mkdir -p ~/.terminfo/x
    if [[ -f ${HOME}/.terminfo/x/xterm-kitty || -L ${HOME}/.terminfo/x/xterm-kitty ]]; then
        rm ${HOME}/.terminfo/x/xterm-kitty
    fi
    ln -s ${HOME}/.local/kitty.app/share/terminfo/x/xterm-kitty ${HOME}/.terminfo/x/xterm-kitty

    ## === urxvt ===
    if [[ -d ${HOME}/.urxvt/ext/font-size ]]; then
        rm -rf ${HOME}/.urxvt/ext/font-size
    elif [[ -f ${HOME}/.urxvt/ext/font-size || -L ${HOME}/.urxvt/ext/font-size ]]; then
        rm ${HOME}/.urxvt/ext/font-size
    else
        mkdir -p ${HOME}/.urxvt/ext/font-size
    fi
    ln -s ${DIR}/i3wm/urxvt-font-size/font-size ${HOME}/.urxvt/ext/font-size

    # === volantes cursor theme ===
    sudo cp -r ${DIR}/x11/volantes /usr/share/icons/

    ## === X session ===
    if [[ -f ${HOME}/.Xresources || -L ${HOME}/.Xresources ]]; then
        rm ${HOME}/.Xresources
    fi
    ln -s ${DIR}/x11/Xresources ${HOME}/.Xresources

    if [[ -f ${HOME}/.Xdefaults || -L ${HOME}/.Xdefaults ]]; then
        rm ${HOME}/.Xdefaults
    fi
    ln -s ${DIR}/x11/Xresources ${HOME}/.Xdefaults

   if [[ -f ${HOME}/.xsessionrc || -L ${HOME}/.xsessionrc ]]; then
        rm ${HOME}/.xsessionrc
    fi
    ln -s ${DIR}/x11/xsessionrc ${HOME}/.xsessionrc

    xrdb -merge ${HOME}/.Xresources
else
    echo "No changes were made."
fi
