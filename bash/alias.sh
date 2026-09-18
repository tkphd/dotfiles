#!/bin/bash

if [[ -n "${ALIAS_SOURCED}" ]]; then
    return
fi

md2book () {
    # convert a Markdown file to PDF using Pandoc and XeTeX
    # with New Computer Modern Book, old style numbers,
    # and the top-level header as the document title
    local src=$1 out
    # Was ${1/.md/.pdf}, which replaces the first ".md" ANYWHERE in the name
    # rather than the extension: `md2book README` produced the output name
    # README and overwrote the input with a PDF. Match the extension, or
    # refuse. (Same bug as md2fn, fixed the same way.)
    [ -n "$src" ] || { echo "md2book: usage: md2book FILE.md" >&2; return 2; }
    [ -f "$src" ] || { echo "md2book: no such file: $src" >&2; return 2; }
    case $src in
        *.md) out=${src%.md}.pdf ;;
        *) echo "md2book: not a .md file: $src" >&2; return 2 ;;
    esac
    pandoc --data-dir="${HOME}/.dotfiles/pandoc" \
           --defaults=md2pdf-cm.yaml             \
           --output="$out"                       \
           --shift-heading-level-by=-1           \
           "$src"
}
export -f md2book

md2pdf () {
    # convert a Markdown file to PDF using Pandoc and XeTeX
    # with TeX Gyre TermesX, old style numbers,
    # and the top-level header as the document title
    local src=$1 out
    # Was ${1/.md/.pdf}, which replaces the first ".md" ANYWHERE in the name
    # rather than the extension: `md2pdf README` produced the output name
    # README and overwrote the input with a PDF. Match the extension, or
    # refuse. (Same bug as md2fn, fixed the same way.)
    [ -n "$src" ] || { echo "md2pdf: usage: md2pdf FILE.md" >&2; return 2; }
    [ -f "$src" ] || { echo "md2pdf: no such file: $src" >&2; return 2; }
    case $src in
        *.md) out=${src%.md}.pdf ;;
        *) echo "md2pdf: not a .md file: $src" >&2; return 2 ;;
    esac
    pandoc --data-dir="${HOME}/.dotfiles/pandoc" \
           --defaults=md2pdf.yaml                \
           --output="$out"                       \
           --shift-heading-level-by=-1           \
           "$src"
}
export -f md2pdf

md2fn () {
    # Convert a Markdown file to PDF on Fluid Numerics letterhead, using the
    # fluidnumerics LaTeX class (~/fn/fluidnumerics.cls).
    #
    # Reads pandoc's default data dir (~/.local/share/pandoc), where fn.yaml
    # selects the class template, the fn-crossref.lua filter, and -- load
    # bearing -- `columns: 250`. That last one reads like a line-wrapping
    # width but for the LaTeX writer it selects table COLUMN TYPES: below it
    # pandoc emits equal-fraction p{} columns that wrap badly, above it
    # natural l/r/c columns sized to content. The default moved between
    # pandoc 2.14 and 3.x, so leaving it unset makes table layout a function
    # of which pandoc is on PATH.
    #
    # The filter is still required, but NOT for labels any more: pandoc 3.11
    # emits \label on longtable captions by itself, which 2.14 could not.
    # It carries .wide, .auto-page, .page-per-table and .marginnote, which
    # have no pandoc equivalent.
    #
    # This is the convenience path. For a build that can be CHECKED -- one
    # that reports overfull boxes and undefined references -- use a Makefile
    # with the two-stage pandoc/xelatex split: pandoc's direct-to-PDF path
    # builds in a temp dir and discards the .log with the answers in it.
    local src=$1 out inst root defaults f
    [ -n "$src" ] || { echo "md2fn: usage: md2fn FILE.md" >&2; return 2; }
    [ -f "$src" ] || { echo "md2fn: no such file: $src" >&2; return 2; }
    # Was ${1/.md/.pdf}, which replaces the first ".md" ANYWHERE in the name
    # rather than the extension: `md2fn README` produced the output name
    # README and overwrote the input with a PDF, and `md2fn notes.md.bak`
    # wrote notes.pdf.bak. Match the extension, or refuse.
    case $src in
        *.md) out=${src%.md}.pdf ;;
        *) echo "md2fn: not a .md file: $src" >&2; return 2 ;;
    esac
    inst=$(kpsewhich fluidnumerics.cls 2>/dev/null) || true
    [ -n "$inst" ] || {
        echo "md2fn: fluidnumerics.cls not found; run 'make install' in ~/fn/fluidnumerics.cls" >&2
        return 3
    }
    # kpsewhich answers relative to $PWD: run inside the class repo it returns
    # ./fluidnumerics.cls -- the repo's own file, not the installed one. Resolve
    # it, or the staleness check below compares a file against itself.
    inst=$(readlink -f "$inst")
    # `make install` copies rather than symlinks, so an installed file can be
    # older than the repo it came from with nothing saying so -- which is how a
    # rebuilt asset silently fails to reach a document.
    #
    # The repo is DERIVED, not hardcoded. `make install-pandoc` symlinks
    # fn.yaml into pandoc's data dir, md2fn already depends on that symlink
    # because --defaults=fn.yaml resolves through it, and it follows the repo
    # if the repo moves. A hardcoded path would be a second copy of a fact
    # already on disk, free to read and self-maintaining. Use -L, not -e:
    # `readlink -f` on a missing path echoes it back, so an unguarded suffix
    # strip yields a root that silently matches nothing.
    #
    # Check every installed file, not just the class: `make install` copies the
    # artwork too, and a stale logo is exactly as silent as a stale class.
    # Comparison is by mtime, so it errs toward warning -- restoring a file
    # from a backup trips it with identical content. That is the safe
    # direction for a warning whose whole job is to break a silence.
    defaults=$HOME/.local/share/pandoc/defaults/fn.yaml
    root=
    if [ -L "$defaults" ]; then
        # Up three levels, rather than stripping a fixed suffix. The symlink's
        # NAME must be fn.yaml for pandoc to find it, but its TARGET need not
        # be: point it at a variant and ${root%/pandoc/defaults/fn.yaml} is a
        # no-op that leaves root naming a FILE, every -f test below fails, and
        # the check goes silently inert -- the exact failure it exists to catch.
        root=$(readlink -f "$defaults")
        root=${root%/*}; root=${root%/*}; root=${root%/*}
        # Then check the derivation landed somewhere that can answer the
        # question, instead of assuming it did.
        [ -f "$root/fluidnumerics.cls" ] || root=
    fi
    if [ -n "$root" ]; then
        # The loop needs pathname expansion. A caller with `set -f` -- md2fn is
        # export -f'd, so a script can be the caller -- would otherwise hand it
        # the literal "dir/*", every -f test would fail, and the check would go
        # silently inert. `local -` scopes shell options to this function, so
        # the caller's setting is restored on return.
        local -; set +f
        for f in "$(dirname "$inst")"/*; do
            [ -f "$root/${f##*/}" ] && [ "$root/${f##*/}" -nt "$f" ] && {
                echo "md2fn: warning: ${f##*/} is newer in $root" >&2
                echo "       than the copy TeX will use; 'make install' to refresh" >&2
            }
        done
    fi
    pandoc --defaults=fn.yaml --output="$out" "$src"
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
