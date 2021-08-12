#!/bin/bash

echo -ne 'DANGER! This script will overwrite ~/.bashrc, and other config files.\n\nType "yes" to continue: '
read -r DISCLAIMER

if [[ "${DISCLAIMER}" == "yes" || "${DISCLAIMER}" == "\"yes\"" ]]; then

    DIR="${PWD}"

    # === bash ===
    [[ -f "${HOME}"/.bashrc || -L "${HOME}"/.bashrc ]] && rm "${HOME}"/.bashrc
    ln -s "${DIR}"/bash/bashrc "${HOME}"/.bashrc

    # === rc files ===
    for f in rc/*rc; do
        RC="${HOME}"/.$(basename "${f}")
        [[ -f "${RC}" || -L "${RC}" ]] && rm "${RC}"
        ln -s "${PWD}/${f}" "${RC}"
    done

    ## === binaries ===
    [[ -d "${HOME}"/bin ]] || mkdir "${HOME}"/bin
    for f in bin/*; do
        link="${HOME}/${f/.sh/}"
        [[ -f "${link}" || -L "${link}" ]] && rm "${link}"
        ln -s "$(pwd)/${f}" "${link}"
    done

    # === conda ===
    [[ -f "${HOME}"/.condarc || -L "${HOME}"/.condarc ]] && rm "${HOME}"/.condarc
    ln -s "${DIR}"/conda/condarc "${HOME}"/.condarc

    [[ -f "${HOME}"/.mambarc || -L "${HOME}"/.mambarc ]] && rm "${HOME}"/.mambarc
    ln -s "${DIR}"/conda/mambarc "${HOME}"/.mambarc

    # === emacs ===
    if [[ -d "${HOME}"/.emacs.d ]]; then
        rm -rf "${HOME}"/.emacs.d
    elif [[ -f "${HOME}"/.emacs.d || -L "${HOME}"/.emacs.d ]]; then
        rm "${HOME}"/.emacs.d
    fi
    ln -s "${DIR}"/emacs "${HOME}"/.emacs.d

    # === gdb ===
    [[ -f "${HOME}"/.gdbinit || -L "${HOME}"/.gdbinit ]] && rm "${HOME}"/.gdbinit
    ln -s "${DIR}"/gdb/gdbinit "${HOME}"/.gdbinit

    # === git ===
    [[ -f "${HOME}"/.gitconfig || -L "${HOME}"/.gitconfig ]] && rm "${HOME}"/.gitconfig
    if [[ ! -d "${HOME}"/.config/git/template ]]; then
        mkdir -p "${HOME}"/.config/git/template
        echo "ref: refs/heads/main" > "${HOME}"/.config/git/template/HEAD
    fi
    ln -s "${DIR}"/git/gitconfig "${HOME}"/.gitconfig

    # === i3wm ===
    if [[ -d "${HOME}"/.config/i3 ]]; then
        rm -rf "${HOME}"/.config/i3
    elif [[ -f "${HOME}"/.config/i3 || -L "${HOME}"/.config/i3 ]]; then
        rm "${HOME}"/.config/i3
    fi
    ln -s "${DIR}"/i3wm "${HOME}"/.config/i3

    # === kitty ===
    if [[ -d "${HOME}"/.config/kitty ]]; then
        rm -rf "${HOME}"/.config/kitty
    elif [[ -f "${HOME}"/.config/kitty || -L "${HOME}"/.config/kitty ]]; then
        rm "${HOME}"/.config/kitty
    fi
    ln -s "${DIR}"/kitty "${HOME}"/.config/kitty

    mkdir -p "${HOME}"/.terminfo/x
    [[ -f "${HOME}"/.terminfo/x/xterm-kitty || -L "${HOME}"/.terminfo/x/xterm-kitty ]] && rm "${HOME}"/.terminfo/x/xterm-kitty
    ln -s "${HOME}"/.local/kitty.app/share/terminfo/x/xterm-kitty "${HOME}"/.terminfo/x/xterm-kitty

    # === nano ===
    if [[ ! -d "${HOME}/.nano" ]]; then
        NANO_TMP="/tmp/nanorc.zip"
        NANO_DIR="${HOME}/.nano"

        wget -O "${NANO_TMP}" https://github.com/scopatz/nanorc/archive/master.zip
        mkdir -p "${NANO_DIR}" || exit
        "${HOME}"/bin/unpack "${NANO_TMP}" "${NANO_DIR}"
        mv "${NANO_DIR}"/nanorc-master/* "${NANO_DIR}/"
        rm -rf "${NANO_DIR}/nanorc-master"
    fi

    ## === urxvt ===
    if [[ -d "${HOME}"/.urxvt/ext/font-size ]]; then
        rm -rf "${HOME}"/.urxvt/ext/font-size
    elif [[ -f "${HOME}"/.urxvt/ext/font-size || -L "${HOME}"/.urxvt/ext/font-size ]]; then
        rm "${HOME}"/.urxvt/ext/font-size
    else
        mkdir -p "${HOME}"/.urxvt/ext/font-size
    fi
    ln -s "${DIR}"/i3wm/urxvt-font-size/font-size "${HOME}"/.urxvt/ext/font-size

    ## === X session ===
    [[ -f "${HOME}"/.Xresources || -L "${HOME}"/.Xresources ]] && rm "${HOME}"/.Xresources
    ln -s "${DIR}"/x11/Xresources "${HOME}"/.Xresources

    [[ -f "${HOME}"/.Xdefaults || -L "${HOME}"/.Xdefaults ]] && rm "${HOME}"/.Xdefaults
    ln -s "${DIR}"/x11/Xresources "${HOME}"/.Xdefaults

    [[ -f "${HOME}"/.xsessionrc || -L "${HOME}"/.xsessionrc ]] && rm "${HOME}"/.xsessionrc
    ln -s "${DIR}"/x11/xsessionrc "${HOME}"/.xsessionrc

    # === volantes cursor theme ===
    sudo cp -r "${DIR}"/x11/volantes /usr/share/icons/

    xrdb -merge "${HOME}"/.Xresources
else
    echo "No changes were made."
fi
