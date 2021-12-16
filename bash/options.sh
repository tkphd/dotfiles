#!/bin/bash

# Enable some useful shell options
shopt -s cdspell      # autocorrect dir typos
shopt -s checkhash    # check for removed commands
shopt -s checkwinsize # resize terminal output
shopt -s cmdhist      # flatten multi-line cmd history
shopt -s histappend   # append, rather than overwrite
shopt -s nocaseglob   # case-insensitive globbing

# Disable some unhelpful options
shopt -u huponexit  # don't kill *all jobs* just 'cuz this shell quit
shopt -u mailwarn   # don't tell me about mail
shopt -u sourcepath # don't use PATH to find file called by `source`
