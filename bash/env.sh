#!/bin/bash

if [[ -n "${ENV_SOURCED}" ]]; then
    return
fi

# === sbin ===
[[ ! $PATH =~ .*/usr/sbin* ]] && \
    export PATH="${PATH}:/usr/sbin"
# === Local Binaries ===
[[ ! $PATH =~ .*/$USER/.local/bin* ]] && \
    export PATH="${HOME}/.local/bin:${PATH}"
[[ -d "${HOME}/bin" ]] && [[ ! $PATH =~ .*/$USER/bin* ]] && \
    export PATH="${HOME}/bin:${PATH}"
[[ ! $PATH =~ .*cargo* ]] && \
    export PATH="${HOME}/.cargo/bin:$PATH"
[[ ! $PATH =~ .*krew* ]] && \
    export PATH="${HOME}/.krew/bin:$PATH"

# === TeX Live ===
[[ -d "/usr/local/texlive/2026/bin/x86_64-linux" ]] && \
    [[ ! $PATH =~ .*texlive.* ]] && \
    export PATH="/usr/local/texlive/2026/bin/x86_64-linux:${PATH}"
# === Emacs ===
export EMACSD="${HOME}/.cache/emacs"
export EMACSBD="${EMACSD}/backups"
export EMACSSD="${EMACSD}/saves"
if [[ ! -d "${EMACSD}" ]]; then
    mkdir -p "${EMACSD}"
    mkdir -p "${EMACSBD}"
    mkdir -p "${EMACSSD}"
fi
# === GCC ===
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
# === GCloud ===
[[ -a /opt/google/gcloud/path.bash.inc ]] && \
    source /opt/google/gcloud/path.bash.inc
# === GITHUB ===
[[ -f "${HOME}/.github" ]] && \
    source "${HOME}/.github" # personal access token(s)
# === less ===
# termcap  terminfo  effect
# ks       smkx      make the keypad send commands
# ke       rmkx      make the keypad send digits
# vb       flash     emit visual bell
# mb       blink     start blink: green
# md       bold      start bold: cyan
# me       sgr0      turn off bold, blink and underline
# so       smso      start standout (reverse video): yellow-on-blue
# se       rmso      stop standout
# us       smul      start underline: white
# ue       rmul      stop underline
LESS_TERMCAP_mb=$(tput bold; tput setaf 2)               && export LESS_TERMCAP_mb
LESS_TERMCAP_md=$(tput bold; tput setaf 6)               && export LESS_TERMCAP_md
LESS_TERMCAP_me=$(tput sgr0)                             && export LESS_TERMCAP_me
LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) && export LESS_TERMCAP_so
LESS_TERMCAP_se=$(tput rmso; tput sgr0)                  && export LESS_TERMCAP_se
LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7)    && export LESS_TERMCAP_us
LESS_TERMCAP_ue=$(tput rmul; tput sgr0)                  && export LESS_TERMCAP_ue
LESS_TERMCAP_mr=$(tput rev)                              && export LESS_TERMCAP_mr
LESS_TERMCAP_mh=$(tput dim)                              && export LESS_TERMCAP_mh
LESS_TERMCAP_ZN=$(tput ssubm)                            && export LESS_TERMCAP_ZN
LESS_TERMCAP_ZV=$(tput rsubm)                            && export LESS_TERMCAP_ZV
LESS_TERMCAP_ZO=$(tput ssupm)                            && export LESS_TERMCAP_ZO
LESS_TERMCAP_ZW=$(tput rsupm)                            && export LESS_TERMCAP_ZW
GROFF_NO_SGR=1                                           && export GROFF_NO_SGR
# === LESS ===
[[ $(which pygmentize 2>/dev/null) != "" ]] && \
    export LESSOPEN="| pygmentize -g %s"
# === Systemd ===
# export SYSTEMD_PAGER=  # uncomment to disable systemctl's auto-paging feature
# === neovim ===
[[ ! $PATH =~ .*/opt/nvim-linux-x86_64* ]] && \
    export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

export ENV_SOURCED=1
