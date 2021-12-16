#!/bin/bash

export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -nw"
export PAGER="less"
export READER="zathura"
export VISUAL="${EDITOR}"

# === check dependencies ===
for PKG in emacs i3wm pygmentize urxvt zathura; do
    [[ $(which ${PKG}) == "" ]] && \
        echo "Warning: ${PKG} not found!"
done

# display non-text files with less
[ -x /usr/bin/lesspipe ] && \
    export LESSOPEN="|lesspipe %s"
# list capitalized folders first
export LC_COLLATE="C"
