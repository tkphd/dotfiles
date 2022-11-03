#!/bin/bash

if [[ -n "${PROMPT_SOURCED}" ]]; then
    return
fi

[[ -f "${HOME}/.dotfiles/bash/colors.sh" ]] && \
    source "${HOME}/.dotfiles/bash/colors.sh"

sep_git() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/:/'
}
str_git() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

SUDO_PROMPT=$(echo -e "\e[0;34m[Enter \e[0;36m${USER}'s\e[0;34m password to \e[0;35msudo\e[0;34m]:\e[0;39m ")
export SUDO_PROMPT

if [[ "$PS1" ]]; then
    # autocorrect for 'cd', check for removed commands, flatten multi-liners for history,
    # append rather than overwrite history, update window size after each command
    shopt -s cdspell checkhash checkwinsize cmdhist histappend
    # Turn off HUP on exit, mail notification, and using $PATH for the 'source' command
    shopt -u huponexit mailwarn sourcepath
    # Set window title & basic prompt
    PS='\u@\h:\w'
    PS1='[\u@\h:\W]\$ '
    case ${TERM} in
        linux)
            # Probably a TTY rather than a terminal
            PS1='[\u@\h:\W]\$ '
            ;;
        *)
            # Customizable prompt settings
            D_HU="${MAGENTAB}"
            G_HU="${RED}"
            H_HU="${BLUE}"
            P_HU="${CYANL}"
            S_HU="${GREENL}"
            Q_HU="${MAGENTAB}"
            T_HU="${RED}"
            [[ -f "${HOME}/.dotfiles/bash/local_prompt" ]] && \
                source "${HOME}/.dotfiles/bash/local_prompt"
            if [[ "${UID}" != "${EUID}" ]]; then
                # su environment
                PS1="${REDB}\u[\h]:\W\$${DEFAULT} "
            else
                PS1="${Q_HU}«${T_HU}\D{%H:%M}${D_HU}@${H_HU}\h${D_HU}:${P_HU}\W${D_HU}\$(sep_git)${G_HU}\$(str_git)${Q_HU}»${S_HU}\$${DEFAULT} "
            fi
            ;;
    esac
fi

export PROMPT_SOURCED=1
