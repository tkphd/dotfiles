#!/bin/bash
# === Colorful! ===
BLACK="\[\033[0;30m\]"
BLUE="\[\033[0;34m\]"
GREEN="\[\033[0;32m\]"
CYAN="\[\033[0;36m\]"
RED="\[\033[0;31m\]"
PURPLE="\[\033[0;35m\]"
YELLOW="\[\033[0;33m\]"
GREY="\[\033[0;37m\]"
BLACKB="\[\033[1;30m\]"
BLUEB="\[\033[1;34m\]"
BROWN="\[\033[1;32m\]"
CYANB="\[\033[1;36m\]"
REDB="\[\033[1;31m\]"
PURPLEB="\[\033[1;35m\]"
BROWNB="\[\033[1;33m\]"
GREYB="\[\033[1;37m\]"
NONE="\[\033[0m\]"
# === Non-Interactive! ===
if [[ -z "$Environ_Sourced" && -f /etc/profile ]]
then
    source /etc/profile
fi
# === Prompt! ===
if [ "$PS1" ]
then
    # colorize if at all possible
    force_color_prompt=yes
    # autocorrect for 'cd', check for removed commands, flatten multi-liners for history,
    # append rather than overwrite history, update window size after each command
    shopt -s cdspell checkhash checkwinsize cmdhist histappend
    # Turn off HUP on exit, mail notification, and using $PATH for the 'source' command
    shopt -u huponexit mailwarn sourcepath
    # set failsafe prompt
    function prompt_command
    {
        if [ "$?" = 0 ]
        then
            ERRPROMPT=""
        else
            ERRPROMPT="($?)"
        fi
    }
    PROMPT_COMMAND=prompt_command
    case $TERM in
        iris-ansi*|konsole|*rxvt*|*xterm*|screen)
            # Put user@machine:/directory on headline of xterms
            PS="${RED}\${ERRPROMPT}${BLUE}\!"
            if [ $UID = $EUID -a $UID -ne 0 ]
            then
                PS="${PS} ${BROWN}\h${BLUE}% ${NONE}"
            else
                PS="${PS} ${RED}\u@\h${BLUE}# ${NONE}"
            fi
            parse_git() {
                git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/.\1/'
            }
	        PS1="${PURPLE}«${GREEN}\D{%H:%M}${REDB}@${BLUE}\h${RED}:${CYAN}\W${YELLOW}\$(parse_git)${PURPLE}»${RED}\$ ${NONE}"
            ;;
        default)
            if [ $UID = $EUID -a $UID -ne 0 ]
            then
                PS1="\${ERRPROMPT}\! \h$% "
            else
                PS1="\${ERRPROMPT}\! \u@\h$#"
            fi
    esac
fi
# === Aliased! ===
if [ -f $HOME/.bash.d/bash_aliases ]
then
    source $HOME/.bash.d/bash_aliases
fi
# === Environmental! ===
if [ -f $HOME/.bash.d/bash_envs ]
then
    source $HOME/.bash.d/bash_envs
fi
