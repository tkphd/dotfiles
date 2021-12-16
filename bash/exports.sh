#!/bin/bash

export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -nw"
export PAGER="less"
export READER="zathura"
export VISUAL="${EDITOR}"

# display non-text files with less
[ -x /usr/bin/lesspipe ] && \
    export LESSOPEN="|lesspipe %s"
# list capitalized folders first
export LC_COLLATE="C"
