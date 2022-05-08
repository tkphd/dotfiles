#!/bin/bash
set -e
echo -ne 'DANGER! This script will overwrite ~/.bashrc and other config files.\n\nType "yes" to continue: '
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
        ln -s "$(pwd)/${f}" "${link}"
    done

    # === emacs ===
    if [[ -d "${HOME}"/.emacs.d ]]; then
        rm -rf "${HOME}"/.emacs.d
    elif [[ -f "${HOME}"/.emacs.d || -L "${HOME}"/.emacs.d ]]; then
        rm "${HOME}"/.emacs.d
    fi
    ln -s "${DIR}"/emacs "${HOME}"/.emacs.d

    # === gdb ===
    [[ -f "${HOME}"/.gdbinit || -L "${HOME}"/.gdbinit ]] && \
        rm "${HOME}"/.gdbinit
    ln -s "${DIR}"/gdb/gdbinit "${HOME}"/.gdbinit

    # === git ===
    [[ -f "${HOME}"/.gitconfig || -L "${HOME}"/.gitconfig ]] && \
        rm "${HOME}"/.gitconfig
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

    # === nano ===
    if [[ ! -d "${HOME}/.nano" ]]; then
        NANO_TMP="/tmp/nanorc.zip"
        NANO_DIR="${HOME}/.nano"

        wget -O "${NANO_TMP}" https://github.com/scopatz/nanorc/archive/master.zip
        mkdir -p "${NANO_DIR}" || exit
        unzip -d "${NANO_DIR}" -f -j "${NANO_TMP}" && rm "${NANO_TMP}"
    fi

    # === urxvt ===
    if [[ -d "${HOME}"/.urxvt ]]; then
        rm -rf "${HOME}"/.urxvt
    elif [[ -f "${HOME}"/.urxvt || -L "${HOME}"/.urxvt ]]; then
        rm "${HOME}"/.urxvt
    fi
    ln -s "${DIR}"/urxvt "${HOME}"/.urxvt

    ## === X session ===
    [[ -f "${HOME}"/.Xresources || -L "${HOME}"/.Xresources ]] && \
        rm "${HOME}"/.Xresources
    ln -s "${DIR}"/x11/Xresources "${HOME}"/.Xresources

    [[ -f "${HOME}"/.Xdefaults || -L "${HOME}"/.Xdefaults ]] && \
        rm "${HOME}"/.Xdefaults
    ln -s "${DIR}"/x11/Xresources "${HOME}"/.Xdefaults

    [[ -f "${HOME}"/.xsessionrc || -L "${HOME}"/.xsessionrc ]] && \
        rm "${HOME}"/.xsessionrc
    ln -s "${DIR}"/x11/xsessionrc "${HOME}"/.xsessionrc

    # === volantes cursor theme ===
    mkdir -p "${HOME}"/.local/share/icons
    rsync -a --quiet "${DIR}"/x11/volantes "${HOME}"/.local/share/icons/

    xrdb -merge "${HOME}"/.Xresources

    # === check dependencies ===
    for PKG in diff-so-fancy direnv duf emacs-nox fzf i3 lnav mdp plocate pygmentize tig urxvt visidata xsel zathura; do
        [[ $(which ${PKG}) == "" ]] && \
            echo "Warning: ${PKG} not found!"
    done

    # === rust utilities ===
    # h/t Julia Evans <https://jvns.ca/blog/2022/04/12/a-list-of-new-ish--command-line-tools/>
    if [[ ! -d "${HOME}/.cargo" ]]; then
        curl --proto '=https' --tlsv1.2 -sSf https://static.rust-lang.org/rustup/rustup-init.sh | sh
    else
        rustup update
    fi
    source "${HOME}/.cargo/env"
    cargo install ag choose difftastic du-dust exa git-delta ripgrep sd xsv

    # === node utilities ===
    if [[ ! -d "${HOME}/.nvm" ]]; then
        curl -o- https:/raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
        [ -s "${HOME}/.nvm/nvm.sh" ] && \
            . "${HOME}/.nvm/nvm.sh"  # This loads nvm
        [ -s "${HOME}/.nvm/bash_completion" ] && \
            . "${HOME}/.nvm/bash_completion"  # This loads nvm bash_completion
        nvm install --lts
        nvm use --lts
        nvm alias default node
    fi
    [ -s "${HOME}/.nvm/nvm.sh" ] && \
        . "${HOME}/.nvm/nvm.sh"  # This loads nvm
    [ -s "${HOME}/.nvm/bash_completion" ] && \
        . "${HOME}/.nvm/bash_completion"  # This loads nvm bash_completion
    if [[ -d "${HOME}/.npm" ]]; then
        npm install --global markdownlint-cli tldr yarn 2&>/dev/null # don't tell me about audit errors
    fi

else
    echo "No changes were made."
fi
