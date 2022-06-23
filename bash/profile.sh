#!/bin/bash
# ~/.profile: executed by the command interpreter for login shells.
# Ignored if either ~/.bash_profile or ~/.bash_login exists.

if [[ -n "$PROFILE_SOURCED" ]]; then
    return
fi

if [ -n "${BASH_VERSION}" ]; then
    if [[ -e "${HOME}/.bashrc" ]]; then
        . "${HOME}/.bashrc"
    fi
fi

# export LANGUAGE="en_US:en"
# export LC_MESSAGES="en_US.UTF-8"
# export LC_CTYPE="en_US.UTF-8"
# export LC_COLLATE="en_US.UTF-8"

# Nix
function loadnix {
    if [ -e "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]; then
        . "${HOME}/.nix-profile/etc/profile.d/nix.sh"
    fi # added by Nix installer
}

function loadcargo {
    [ -e "${HOME}/.cargo/env" ] && \
        . "${HOME}/.cargo/env"
}

function loadrvm {
    [ -d "${HOME}/.rvm/bin" ] && \
        export PATH="${PATH}:${HOME}/.rvm/bin"

    [ -s "$HOME/.rvm/scripts/rvm" ] && \
        . "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
}

[[ -e "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]] && \
    . "${HOME}/.nix-profile/etc/profile.d/nix.sh" # added by Nix installer

# Rust/cargo
[[ -f "$HOME/.cargo/env" ]] && \
    . "$HOME/.cargo/env"

# === Conda & Mamba ===
[[ -f "${HOME}/.dotfiles/bash/mamba.sh" ]] && \
    . "${HOME}/.dotfiles/bash/mamba.sh"

export PROFILE_SOURCED=1
