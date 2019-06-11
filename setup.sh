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
