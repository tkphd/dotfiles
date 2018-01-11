# uncomment next line for debugging
#set -x
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
export MOZ_PRINTER_NAME=div655
unset MAIL

# If this is a non-interactive shell, we still want to get
# the stuff (like $PATH) in /etc/profile if we haven't already
if [[ -z "$Environ_Sourced" && -f /etc/profile ]]
then
    source /etc/profile
fi

if [ "$PS1" ]
then
	# uncomment for a colored prompt, if the terminal has the capability; turned
	# off by default to not distract the user: the focus in a terminal window
	# should be on the output of commands, not on the prompt
	force_color_prompt=yes

    # Turn on automatic directory spelling correction (for 'cd'),
    # checking for removed commands, and saving multi-line commands
    # on one line in the history
    shopt -s cdspell checkhash cmdhist

    # Turn off HUP on exit, mail notification, and using $PATH for
    # the 'source' command
    shopt -u huponexit mailwarn sourcepath

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
    # Put current user@machine:/directory on headline of xterms
    case $TERM in
        iris-ansi*|*xterm*|*rxvt*|screen)
        PS="${RED}\${ERRPROMPT}${BLUE}\!"
        if [ $UID = $EUID -a $UID -ne 0 ]
        then
            PS="${PS} ${BROWN}\h${BLUE}% ${NONE}"
        else
            PS="${PS} ${RED}\u@\h${BLUE}# ${NONE}"
        fi
	    PS1="${PURPLE}<${GREEN}\D{%H:%M}${REDB}@${GREEN}\h${RED}:${CYAN}\W${PURPLE}>${RED}\$ ${NONE}"
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

if [ -f ~/.bash.d/aliases ]
then
    source ~/.bash.d/aliases
fi

if [ -f ~/.bash.d/envs ]
then
    source ~/.bash.d/envs
fi

