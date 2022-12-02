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

# === Modules ===
if [[ -f /etc/profile.d/lmod.sh ]]; then
    . /etc/profile.d/lmod.sh
    [ -d "${HOME}/research/modules" ] && \
        module use "${HOME}/research/modules/modulefiles"
fi

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

# === Ruby ===
[ -s "$HOME/.rvm/scripts/rvm" ] && \
    . "$HOME/.rvm/scripts/rvm"

# === Rust/cargo ===
[ -e "${HOME}/.cargo/env" ] && \
    . "${HOME}/.cargo/env"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
[ -d "${HOME}/.rvm/bin" ] && [[ ! $PATH =~ .*/.rvm* ]] && \
    export PATH="${PATH}:${HOME}/.rvm/bin"

export PROFILE_SOURCED=1
