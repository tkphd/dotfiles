#!/bin/bash
set -e  # exit on failure



echo -ne "DANGER! This script will overwrite ${HOME}/.bashrc and other config files.\n\nType \"yes\" to continue: "
read -r DISCLAIMER

if [[ "${DISCLAIMER}" == "yes" || "${DISCLAIMER}" == "\"yes\"" ]]; then

    DIR="${PWD}"

    # === bash ===
    [[ -f "${HOME}"/.bashrc || -L "${HOME}"/.bashrc ]] && \
        rm "${HOME}"/.bashrc
    ln -s "${DIR}"/bash/bashrc "${HOME}"/.bashrc

    [[ -f "${HOME}"/.profile || -L "${HOME}"/.profile ]] && \
        rm "${HOME}"/.profile
    ln -s "${DIR}"/bash/profile.sh "${HOME}"/.profile

    # === rc files ===
    for f in rc/*rc; do
        RC="${HOME}"/.$(basename "${f}")
        [[ -f "${RC}" || -L "${RC}" ]] && \
            rm "${RC}"
        ln -s "${PWD}/${f}" "${RC}"
    done

    ## === binaries ===
    [[ -d "${HOME}"/bin ]] || mkdir "${HOME}"/bin
    for f in bin/*; do
        link="${HOME}/${f/.sh/}"
        [[ -f "${link}" || -L "${link}" ]] && \
            rm "${link}"
        ln -s "${PWD}/${f}" "${link}"
    done

    ## === emacs ===
    [[ -d "${HOME}"/.emacs.d ]] && \
	    rm -r "${HOME}"/.emacs.d
    ln -s "${PWD}/emacs" "${HOME}/.emacs.d"
    [[ -d "${HOME}/.cache/emacs" ]] || \
        mkdir -p "${HOME}"/.cache/emacs/{backup,save,undo}

    # === git ===
    [[ -f "${HOME}"/.gitconfig || -L "${HOME}"/.gitconfig ]] && \
        rm "${HOME}"/.gitconfig
    if [[ ! -d "${HOME}"/.config/git/template ]]; then
        mkdir -p "${HOME}"/.config/git/template
        echo "ref: refs/heads/main" > "${HOME}"/.config/git/template/HEAD
    fi
    ln -s "${DIR}"/git/gitconfig "${HOME}"/.gitconfig

    # === nano ===
    if [[ ! -d "${HOME}/.nano" ]]; then
        NANO_TMP="/tmp/nanorc.zip"
        NANO_DIR="${HOME}/.nano"

        git clone --recursive github:scopatz/nanorc "${NANO_DIR}"
    fi
else
    echo "No changes were made."
fi
