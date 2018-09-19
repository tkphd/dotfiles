#!/usr/bin/env bash
# === Colorful! ===
    NONE='\[\e[0m\]'
   BLACK='\[\e[0;30m\]'
     RED='\[\e[0;31m\]'
   GREEN='\[\e[0;32m\]'
  YELLOW='\[\e[0;33m\]'
    BLUE='\[\e[0;34m\]'
 MAGENTA='\[\e[0;35m\]'
    CYAN='\[\e[0;36m\]'
    GREY='\[\e[0;37m\]'
 DEFAULT='\[\e[0;39m\]'
   GREYD='\[\e[0;90m\]'
   WHITE='\[\e[0;97m\]'
# === Light! ===
    REDL='\[\e[0;91m\]'
  GREENL='\[\e[0;92m\]'
 YELLOWL='\[\e[0;93m\]'
   BLUEL='\[\e[0;94m\]'
MAGENTAL='\[\e[0;95m\]'
   CYANL='\[\e[0;96m\]'
# === Bold! ===
  BLACKB='\[\e[1;30m\]'
    REDB='\[\e[1;31m\]'
   BROWN='\[\e[1;32m\]'
  BROWNB='\[\e[1;33m\]'
   BLUEB='\[\e[1;34m\]'
MAGENTAB='\[\e[1;35m\]'
   CYANB='\[\e[1;36m\]'
   GREYB='\[\e[1;37m\]'
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
            sep_git() {
                git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/:/'
            }
            str_git() {
                git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
            }
	        PS1="${MAGENTA}«${RED}\D{%H:%M}${MAGENTA}@${BLUE}\h${MAGENTA}:${CYANL}\W${MAGENTA}\$(sep_git)${RED}\$(str_git)${MAGENTA}»${GREENL}\$${NONE} "
            PROMPT_COMMAND='echo -ne "\e]0;${USER}@$(hostname --short): $(basename $PWD)\007"'
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
if [ -f "$HOME/.bash.d/bash_aliases" ]
then
    source "$HOME/.bash.d/bash_aliases"
fi
# === Environmental! ===
if [ -f "$HOME/.bash.d/bash_envs" ]
then
    source "$HOME/.bash.d/bash_envs"
fi
if [ -f "$HOME/.bash.d/conda.sh" ]
then
    source "$HOME/.bash.d/conda.sh"
fi
if [[ -f "~/repositories/OpenFOAM-dev/etc/bashrc" ]]
then
        source "~/repositories/OpenFOAM-dev/etc/bashrc"
fi
