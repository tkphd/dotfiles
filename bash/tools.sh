#!/bin/bash

export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -nw"
export PAGER="less"
export READER="zathura"
export VISUAL="${EDITOR}"
[ $(which urxvt) ] && \
    export TERM=rxvt-unicode-256color

# display non-text files with less
[ -x /usr/bin/lesspipe ] && \
    export LESSOPEN="|lesspipe %s"
# list capitalized folders first
export LC_COLLATE="C"

# let dmenu find useful things
export XDG_DATA_DIRS=/usr/share
