#!/bin/bash
# ~/.profile: executed by the command interpreter for login shells.
# Ignored if either ~/.bash_profile or ~/.bash_login exists.

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

# Mamba
for TRYME in "/toolbox/${USER}/opt/mambaforge" "/working/${USER}/opt/mambaforge" "/Valhalla/opt/mambaforge";
do
    if [[ -z $CONDAPATH ]]; then
        if [[ -a "${TRYME}" ]]; then
            CONDAPATH="${TRYME}"
            __setup="$(${CONDAPATH}/bin/conda shell.bash hook 2> /dev/null)"
           if [ $? -eq 0 ]; then
               eval "$__setup"
           else
               if [ -f "${CONDAPATH}/etc/profile.d/conda.sh" ]; then
                   . "${CONDAPATH}/etc/profile.d/conda.sh"
               else
                   export PATH="${CONDAPATH}/bin:$PATH"
               fi
           fi
           unset __setup
           if [ -f "${CONDAPATH}/etc/profile.d/mamba.sh" ]; then
               . "${CONDAPATH}/etc/profile.d/mamba.sh"
               alias mambact="mamba activate"
               alias deact="mamba deactivate"
           else
               alias condact="conda activate"
               alias deact="conda deactivate"
           fi
           export CONDAPATH
        fi
    fi
done
