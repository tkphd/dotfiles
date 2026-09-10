#!/bin/bash

if [[ -n "${ALIAS_SOURCED}" ]]; then
    return
fi

md2book () {
    # convert a Markdown file to PDF using Pandoc and XeTeX
    # with New Computer Modern Book, old style numbers,
    # and the top-level header as the document title
    pandoc --data-dir="${HOME}/.dotfiles/pandoc" \
           --defaults=md2pdf-cm.yaml             \
           --output="${1/.md/.pdf}"              \
           --shift-heading-level-by=-1           \
           "$1"
}
export -f md2book

md2pdf () {
    # convert a Markdown file to PDF using Pandoc and XeTeX
    # with TeX Gyre TermesX, old style numbers,
    # and the top-level header as the document title
    pandoc --data-dir="${HOME}/.dotfiles/pandoc" \
           --defaults=md2pdf.yaml                \
           --output="${1/.md/.pdf}"              \
           --shift-heading-level-by=-1           \
           "$1"
}
export -f md2pdf

md2fn () {
    # convert a Markdown file to PDF using Pandoc and XeTeX
    # on Fluid Numerics letterhead (insignia + Courier Prime header/footer)
    pandoc --data-dir="${HOME}/.dotfiles/pandoc" \
           --defaults=md2fn.yaml                 \
           --output="${1/.md/.pdf}"              \
           --shift-heading-level-by=-1           \
           "$1"
}
export -f md2fn

mkcd () {
    mkdir "$1" && cd "$1" || exit
}
export -f mkcd

png2vid () {
	if [[ $# == 0 || $# -gt 2 ]] ; then
        echo "Usage: $0 path/to/imgdir vidfile.mp4"
    else
        mencoder "mf://$1/*.png" -o "$2" -mf fps=15 -idx \
                 -nosound -noskip -of lavf -lavfopts format=mp4 \
                 -ovc x264 -x264encopts pass=1:bitrate=2000:bframes=0:crf=24
    fi
}
export -f png2vid

tea () {
    # Set a timer for your tea. Defaults to 5 min.

    announce () {
        if [[ "$(which kdialog)" != "" ]]; then
            kdialog --msgbox "$@"
        else
            echo "$@"
        fi
    }

    t_m=5
    t_s=$(( 60 * t_m ))

    if [[ $# == 1 ]]; then
        # parse command line arguments
        if [[ "$1" == "-h" || "$1" == "--help" ]]; then
            echo -e "Usage: tea [count]\n   eg, tea     # 5 min\n       tea 3.5 # 3½ min"
            t_m=0
        else
            t_m="$1"
        fi
    fi

    t_s=$(python -c "print(int(60.0 * float(${t_m})))")

    if [[ ${t_s} -gt 1000 ]]; then
        t_s=$(python -c "print(int(${t_m}))")
        announce "Assuming you meant ${t_s} sec."
    fi

    t_ss=$(python -c "print(${t_s} % 60)")
    t_mm=$(python -c "print(${t_s} // 60)")
    t_str=$(printf "%02d:%02d" "$t_mm" "$t_ss")
    if [[ ${t_s} -gt 0 ]]; then
        sleep "${t_s}"
        announce "Your tea has steeped ${t_str}."
    fi
}
export -f tea

tee_err () {
    echo "Logging to trace.out and trace.err"
    $1 > >(tee trace.out) 2> >(tee trace.err >&2)
}
export -f tee_err

whoareu () {
    # Print the name of the person assigned the specified ID
    local user
    local info
    user=$(id -u "${1}")
    info=$(getent passwd "${user}")
    echo "${info}" | awk -F':' '{print $5}' | awk -F',' '{print $1}'
}
export -f whoareu

alias acs="apt-cache search"
alias acS="apt-cache show"
alias afb="sudo apt --fix-broken install"
alias agi="sudo apt install"
alias addroot="su root -c 'stty -echo; /usr/bin/ssh-add -c -t 9h /root/.ssh/id_rsa; stty echo'"
alias aria="aria2c -c -m 0"
alias astyle="astyle --style=linux --indent-col1-comments --indent=tab --indent-preprocessor --pad-header --align-pointer=type --keep-one-line-blocks --suffix=none"
alias curl="curl -L -C -"
alias ddp="sudo dd bs=4M conv=fsync status=progress"
alias dir='dir --color=auto'
alias dnf="sudo dnf"
alias vdir='vdir --color=auto'
alias dmesg="/bin/dmesg --color=always | /bin/less -R"
alias du="du -x"
alias e="emacsclient --no-window-system"
alias ek="emacsclient -e '(kill-emacs)'"
alias emacs="emacs --no-window-system"
alias se="sudo emacs --no-window-system"
alias exa="exa -abghHliS --group-directories-first"
alias ff="feh -F --force-aliasing"
alias glow="glow --tui"
alias grafana="ssh -L 3000:localhost:3000 mr-french"
alias grep='grep --color=auto --line-number --with-filename'
alias gs="git status"
alias htup="htop -u \${USER}"
alias journalwarn='journalctl --no-pager -b -p warning'
alias kernperf="perf stat -e cycles,instructions,cache-references,cache-misses,branches,branch-misses,task-clock,faults,minor-faults,context-switches,migrations -r 3"
alias less="less -NRm"
alias ldvi="ldapvi --base 'ou=People,dc=ctcms,dc=gov' -H ldaps://smithers.nist.gov -Y GSSAPI" # first, kinit root/admin
if [[ "$(which lsd)" != "" ]]; then
    alias lsd="lsd --color auto --classify --group-dirs first"
    alias ls="lsd --color auto --classify --group-dirs first"
    alias l="lsd"
    alias la="lsd -A"
    alias ll="lsd -hal"
else
    alias ls='ls --classify --color=auto --group-directories-first'
    alias l='ls'
    alias la='ls -A'
    alias ll='ls -hal'
    alias lls="ls -a"      # typo resistance
    alias lsrt="ls -rlct"  # chronological
fi
alias mf="echo -e 'Use /usr/bin/mf for MetaFont; you probably meant\n    mv'"
alias more="less -mNR"
alias ncdu="ncdu -x --exclude-kernfs"
alias p="python3 -i"
alias ping="ping -4 -c 4"
alias pip="python3 -m pip"
alias please="sudo"
if [[ $(which pygmentize) != "" && -a "${HOME}/bin/color-cat" ]]; then
    alias ccat="${HOME}/bin/color-cat"
    alias pyg="${HOME}/bin/color-cat"
    alias pygmentize="pygmentize -O style='github-dark'"
fi
alias R='R --no-restore --no-save'
alias rm="rm -v"
alias rs="rsync -HPavx --progress=info2"
alias shellcheck="shellcheck -e SC1090,SC2139,SC2155"
alias time="/usr/bin/time -f'\n   %E 〔%e𝑠 wall,  %U𝑠 user,  %S𝑠 sys,  %M KB,  %F faults,  %c switches〕'"
alias remux='[[ ${TMUX} ]] && eval "$(tmux show-environment -s)"'
alias trinket="screen /dev/ttyACM0 115200"
alias vg="valgrind -v --log-file=val.log --leak-check=full --show-leak-kinds=all --trace-children=yes"
alias wget="wget -d -c --tries=0 --read-timeout=30"
alias wnv="watch -n 1 nvidia-smi"

# Slurm shenanigans
LASTWK="$(date --date='last week' +%m%d%y)"
NEXTWK="$(date --date='next week' +%m%d%y)"

export SACCT_FORMAT="JobID,JobName%12,Partition%9,ReqCPUS,NodeList%10,Elapsed,State,MaxRSS"
export SINFO_FORMAT="%9P %10A %8z %14O %.12l %20N %20G"
export SQUEUE_FORMAT="%12i %20j %3t %11P %6D %5C %12L %17R"

alias si="sinfo"
alias sj="sacct --units=G --format=User,AssocID,\${SAFMT} -J"
alias sa="sacct --units=G -S \${LASTWK} -E \${NEXTWK} -u \${USER}"
alias sq="squeue -u tnk10"
alias wsq="watch -n 10 'squeue -u \${USER}'"

export ALIAS_SOURCED=1
