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

    ## === desktop entries ===
    # Generated rather than tracked so ${HOME} is resolved at run time instead
    # of baking an absolute path into the repo. Registering it as the default
    # browser is left as a deliberate manual step:
    #   xdg-settings set default-web-browser browser-router.desktop
    APPS="${HOME}/.local/share/applications"
    [[ -d "${APPS}" ]] || mkdir -p "${APPS}"
    cat > "${APPS}/browser-router.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Browser Router
Comment=Google Meet opens in Chrome; everything else in Firefox
Exec=${HOME}/bin/browser-router %U
Terminal=false
NoDisplay=true
StartupNotify=false
MimeType=x-scheme-handler/unknown;x-scheme-handler/about;x-scheme-handler/http;x-scheme-handler/https;text/html;application/xhtml+xml;
EOF
    command -v update-desktop-database >/dev/null && \
        update-desktop-database "${APPS}"

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
