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
SUDO_PS1="${REDB}\U@\H:\w\$${default}"
export SUDO_PROMPT
export SUDO_PS1

# Set window title & basic prompt
PS='\u@\h:\w'
PS1='[\u@\h:\W]\$ '
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
PS1="${Q_HU}«${T_HU}\D{%H:%M}${D_HU}@${H_HU}\h${D_HU}:${P_HU}\W${D_HU}\$(sep_git)${G_HU}\$(str_git)${Q_HU}»${S_HU}\$${DEFAULT} "
export PS1
export PROMPT_SOURCED=1
