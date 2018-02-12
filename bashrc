#!/bin/bash
# === Colorful! ===
    NONE="\[\033[0m\]"
   BLACK="\[\033[0;30m\]"
     RED="\[\033[0;31m\]"
   GREEN="\[\033[0;32m\]"
  YELLOW="\[\033[0;33m\]"
    BLUE="\[\033[0;34m\]"
 MAGENTA="\[\033[0;35m\]"
    CYAN="\[\033[0;36m\]"
    GREY="\[\033[0;37m\]"
 DEFAULT="\[\033[0;39m\]"
   GREYD="\[\033[0;90m\]"
   WHITE="\[\033[0;97m\]"
# === Light! ===
    REDL="\[\033[0;91m\]"
  GREENL="\[\033[0;92m\]"
 YELLOWL="\[\033[0;93m\]"
   BLUEL="\[\033[0;94m\]"
MAGENTAL="\[\033[0;95m\]"
   CYANL="\[\033[0;96m\]"
# === Bold! ===
  BLACKB="\[\033[1;30m\]"
    REDB="\[\033[1;31m\]"
   BROWN="\[\033[1;32m\]"
  BROWNB="\[\033[1;33m\]"
   BLUEB="\[\033[1;34m\]"
MAGENTAB="\[\033[1;35m\]"
   CYANB="\[\033[1;36m\]"
   GREYB="\[\033[1;37m\]"
# === Non-Interactive! ===
if [[ -z "$Environ_Sourced" && -f /etc/profile ]]; then
    source /etc/profile
fi
# === Prompt! ===
if [ "$PS1" ]; then
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
    # Color Codes:
    #         Color Light
    #   Black 30    90
    #     Red 31    91
    #   Green 32    92
    #  Yellow 33    93
    #    Blue 34    94
    # Magenta 35    95
    #    Cyan 36    96
    #    Gray 37    97
    case $TERM in
        iris-ansi*|konsole|*rxvt*|*xterm*|screen)
            # Put user@machine:/directory on headline of xterms
            PS="${RED}\${ERRPROMPT}${BLUE}\!"
            str_git() {
                # Encapsulating in a function makes git branch detection dynamic
                git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\x1b[35m:\x1b[31m\1/'
            }
	        PS1="${MAGENTA}«${RED}\D{%H:%M}${MAGENTA}@${BLUE}\h${MAGENTA}:${CYANL}\W\$(str_git)${MAGENTA}»${GREENL}\$ ${NONE}"
            PROMPT_COMMAND='echo -ne "\033]0;${USER}@$(hostname --short): $(basename $PWD)\007"'
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
