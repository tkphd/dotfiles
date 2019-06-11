#!/bin/bash

DIR=$(pwd)

# === bash ===
if [[ -f ${HOME}/.bashrc ]]; then
    rm ${HOME}/.bashrc
fi
ln -s ${DIR}/bash/bashrc ${HOME}/.bashrc

# === emacs ===
if [[ -d ${HOME}/.emacs.d ]]; then
    rm -rf ${HOME}/.emacs.d
elif [[ -f ${HOME}/.emacs.d ]]; then
    rm ${HOME}/.emacs.d
fi
ln -s ${DIR}/emacs ${HOME}/.emacs.d

# === gdb ===
if [[ -f ${HOME}/.gdbinit ]]; then
    rm ${HOME}/.gdbinit
fi
ln -s ${DIR}/gdb/gdbinit ${HOME}/.gdbinit

# === git ===
if [[ -f ${HOME}/.gitconfig ]]; then
    rm ${HOME}/.gitconfig
fi
ln -s ${DIR}/git/gitconfig ${HOME}/.gitconfig

# === i3wm ===

if [[ -d ${HOME}/.config/i3wm ]]; then
    rm -rf ${HOME}/.config/i3
elif [[ -f ${HOME}/.config/i3 ]]; then
    rm ${HOME}/.config/i3
fi
if [[ -f ${HOME}/.Xresources ]]; then
    rm ${HOME}/.Xresources
fi
if [[ -f ${HOME}/.Xdefaults ]]; then
    rm ${HOME}/.Xdefaults
fi
ln -s ${DIR}/i3wm ${HOME}/.config/i3
ln -s ${DIR}/i3wm/Xresources ${HOME}/.Xresources
ln -s ${DIR}/i3wm/Xresources ${HOME}/.Xdefaults

# === urxvt ===
if [[ -d ${HOME}/.urxvt/ext/font-size ]]; then
    rm -rf ${HOME}/.urxvt/ext/font-size
elif [[ -f ${HOME}/.urxvt/ext/font-size ]]; then
    rm ${HOME}/.urxvt/ext/font-size
fi
ln -s ${DIR}/i3wm/urxvt-font-size/font-size ~/.urxvt/ext/font-size
