#!/bin/bash

if [[ -n "${PROMPT_SOURCED}" ]]; then
    return
fi

[[ -f "${HOME}/.dotfiles/bash/colors.sh" ]] && \
    source "${HOME}/.dotfiles/bash/colors.sh"

[[ -f "${HOME}/.dotfiles/bash/local_prompt" ]] && \
    source "${HOME}/.dotfiles/bash/local_prompt"
if [[ "$PS1" ]]; then
    # colorize if at all possible
    force_color_prompt=yes
    # disable Ctrl-S in interactive shells (only), per
    # https://twitter.com/thingskatedid/status/1348860793618456581
    [[ $- == *i* ]] && \
        stty -ixon
    # autocorrect for 'cd', check for removed commands, flatten multi-liners for history,
    # append rather than overwrite history, update window size after each command
    shopt -s cdspell checkhash checkwinsize cmdhist histappend
    # Turn off HUP on exit, mail notification, and using $PATH for the 'source' command
    shopt -u huponexit mailwarn sourcepath
    # set failsafe prompt
    function prompt_command
    {
        if [ "$?" == 0 ]; then
            ERRPROMPT=""
        else
            ERRPROMPT="($?)"
        fi
    }
    PROMPT_COMMAND=prompt_command
    case ${TERM} in
        iris-ansi*|konsole|rxvt*|screen|urxvt*|xterm*)
            # Put user@machine:/directory on headline of xterms
            PS="${RED}\${ERRPROMPT}${BLUE}\!"
            sep_git() {
                git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/:/'
            }
            str_git() {
                git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
            }
            # Customizable prompt settings
            DIV_HUE="${MAGENTAB}"
            GIT_HUE="${RED}"
            HOST_HUE="${BLUE}"
            PATH_HUE="${CYANL}"
            PROM_HUE="${GREENL}"
            QUOT_HUE="${MAGENTAB}"
            TIME_HUE="${RED}"
            [[ -f "${HOME}/.dotfiles/bash/local_prompt" ]] && \
                source "${HOME}/.dotfiles/bash/local_prompt"
            PS1="${QUOT_HUE}«${TIME_HUE}\D{%H:%M}${DIV_HUE}@${HOST_HUE}\h${DIV_HUE}:${PATH_HUE}\W${DIV_HUE}\$(sep_git)${GIT_HUE}\$(str_git)${QUOT_HUE}»${PROM_HUE}\$${DEFAULT} "
            PROMPT_COMMAND='echo -ne "\e]0;${USER}@$(hostname --short): $(basename $PWD)\007"'
            ;;
        default)
            if [[ $UID == $EUID && $UID -ne 0 ]]; then
                PS1="\${ERRPROMPT}\! \h$% "
            else
                PS1="\${ERRPROMPT}\! \u@\h$#"
            fi
    esac
fi

export PROMPT_SOURCED=1
