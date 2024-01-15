#!/bin/bash

export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -nw"
export PAGER="less -Rm"
export READER="okular"
export VISUAL="${EDITOR}"

# display non-text files with less
[ -x /usr/bin/lesspipe ] && \
    eval "$(SHELL=/bin/sh lesspipe)"

# list capitalized folders first
export LC_COLLATE="C"

# let dmenu find useful things
export XDG_DATA_DIRS=/usr/share
