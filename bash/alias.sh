#!/bin/bash

if [[ -f "${HOME}/.dotfiles/local/HostIP" ]]; then
    source "${HOME}/.dotfiles/local/HostIP"
fi

aguu () {
    # Update Debian and Conda apps
    sudo apt update
    sudo apt dist-upgrade -y
    update_envs
}

airplanemode () {
    if [[ $(nmcli n connectivity) == 'none' ]]; then
        nmcli n on
    elif [[ $(nmcli n connectivity) == 'full' ]]; then
        nmcli n off
    fi
}

md2book () {
    # convert a Markdown file to PDF using Pandoc and XeTeX
    # with New Computer Modern Book, old style numbers,
    # and the top-level header as the document title
    pandoc --data-dir="${HOME}/.dotfiles/pandoc" \
           --defaults=md2pdf-cm.yaml \
           --output="${1/.md/.pdf}" \
           --shift-heading-level-by=-1 \
           "$1"
}

md2pdf () {
    # convert a Markdown file to PDF using Pandoc and XeTeX
    # with TeX Gyre TermesX, old style numbers,
    # and the top-level header as the document title
    pandoc --data-dir="${HOME}/.dotfiles/pandoc" \
           --defaults=md2pdf.yaml \
           --output="${1/.md/.pdf}" \
           --shift-heading-level-by=-1 \
           "$1"
}

png2vid () {
	if [[ $# == 0 || $# -gt 2 ]] ; then
        echo "Usage: $0 path/to/imgdir vidfile.mp4"
    else
        mencoder "mf://$1/*.png" -o "$2" -mf fps=15 -idx \
                 -nosound -noskip -of lavf -lavfopts format=mp4 \
                 -ovc x264 -x264encopts pass=1:bitrate=2000:bframes=0:crf=24
    fi
}

rot13 () {
    # "rotate by 13 places," a substitution cipher for the Latin
    # alphabet that both encrypts and decrypts, like a Fourier transform!
	if  [[ $# == 0 ]] ; then
		tr "a-mn-zA-MN-Z" "n-za-mN-ZA-M"
	else
		tr "a-mn-zA-MN-Z" "n-za-mN-ZA-M" < "$1"
	fi
}

ssm () {
    if [[ $# == 0 || $1 == "--help" || $1 == "-h" ]]; then
        echo -e "\e[0;32mssm\e[0;39m: SSH to the specified host as \e[0;35mmachine\e[0;39m"
        echo "«Usage:»$ ssm host"
    elif [[ $# == 1 ]]; then
        ssh -A -l machine -o UserKnownHostsFile="${HOME}/.ssh/known_hosts_su" "$1"
    else
        ssh -A -l machine -o UserKnownHostsFile="${HOME}/.ssh/known_hosts_su" "$@"
    fi
}

ssr () {
    if [[ $# == 0 || "$1" == "--help" || "$1" == "-h" ]]; then
        echo -e "\e[0;32mssr\e[0;39m: SSH to the specified host as \e[0;31mroot\e[0;39m"
        echo "«Usage:»$ ssr host"
    else
        ssh -A -l root -o UserKnownHostsFile="${HOME}/.ssh/known_hosts_su" "$@"
    fi
}

ssv () {
    if [[ $# == 0 || "$1" == "--help" || "$1" == "-h" ]]; then
        echo -e "\e[0;32mssm\e[0;39m: SSH to the specified VM as \e[0;35mroot\e[0;39m"
        echo "«Usage:»$ ssv host"
    else
        ssh -A -l root -o UserKnownHostsFile="${HOME}/.ssh/known_hosts_vm" "$@"
    fi

}

tea () {
    # Set a timer for your tea. Defaults to 5 min.

    announce () {
        if [[ "$(which kdialog)" != "" ]]; then
            kdialog --msgbox "$@"
        elif [[ "$(which i3-nagbar)" != "" ]]; then
            i3-nagbar -t warning -m "$@"
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

update_envs () {
    # update conda environments
    module load conda
    for dir in base ${CONDAPATH}/envs/*; do
        name=$(basename "${dir}")
        echo -e "\n=== Updating ${name} env ===\n"
        conda activate "${name}"
        mamba update --yes --all
        conda deactivate
    done
    module unload conda

    # update nix environments
    if [[ "$(which nix-env)" != "" ]]; then
        nix-channel --update nixpkgs
        nix-env -u '*'
        # nix-collect-garbage -d
    fi
}

whoareu () {
    # Print the name of the person assigned the specified ID
    local user
    local info
    user=$(id -u "${1}")
    info=$(getent passwd "${user}")
    echo "${info}" | awk -F':' '{print $5}' | awk -F',' '{print $1}'
}

alias acs="apt-cache search"
alias acS="apt-cache show"
alias afb="sudo apt --fix-broken install"
alias agi="sudo apt install"
alias addroot="su root -c 'stty -echo; /usr/bin/ssh-add -c -t 9h /root/.ssh/id_rsa; stty echo'"
alias addvroot="su root -c 'stty -echo; /usr/bin/ssh-add -c -t 9h /root/.ssh/id_ed25519; stty echo'"
alias aria="aria2c -c -m 0"
alias astyle="astyle --style=linux --indent-col1-comments --indent=tab --indent-preprocessor --pad-header --align-pointer=type --keep-one-line-blocks --suffix=none"
alias curl="curl -L -C -"
alias ddp="sudo dd bs=4M conv=fsync status=progress"
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias dmesg="/bin/dmesg --color=always | /bin/less -R"
alias dpgrep="dpkg -l | grep"
alias e="emacsclient -t"
alias ek="emacsclient -e '(kill-emacs)'"
alias se="sudo emacs -nw"
alias sn="sudo nano"
alias exa="exa -abghHliS"
alias ff="feh -F --force-aliasing"
alias gdb="gdb -q"
alias grafana="ssh -L 3000:localhost:3000 mr-french"
alias grep='grep --color=auto --line-number --with-filename'
alias gs="git status"
alias fgrep='fgrep --color=auto --line-number --with-filename'
alias egrep='egrep --color=auto --line-number --with-filename'
alias guvc="guvcviewer -x 1600x1200"
alias htup="htop -u \${USER}"
alias iftop="bmon"
alias kernperf="perf stat -e cycles,instructions,cache-references,cache-misses,branches,branch-misses,task-clock,faults,minor-faults,context-switches,migrations -r 3"
alias less="less -mNR"
alias ldvi="ldapvi --base 'ou=People,dc=ctcms,dc=gov' -H ldaps://smithers.nist.gov -Y GSSAPI" # first, kinit root/admin
alias ls='ls --group-directories-first --color=auto'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -hal'
alias mdl="markdownlint-cli2"
alias mf="echo -e 'Use /usr/bin/mf for MetaFont; you probably meant\n    mv'"
alias mmbi="mamba install --quiet"
alias mmbs="mamba search --quiet"
alias more="less -mNR"
alias mmspstyle="/usr/bin/astyle --style=linux --indent-col1-comments --indent=tab --indent-preprocessor --indent-preproc-cond --pad-header --align-pointer=type --keep-one-line-blocks --suffix=none"
alias bp="bpython3"
alias p="python3 -i -c 'from math import pi' 2>/dev/null"
alias pdf="qpdfview"
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
[[ -f "${HOME}/repositories/rockstar/satriani/rockstar.js" ]] && \
    alias rockstar="node ${HOME}/repositories/rockstar/satriani/rockstar.js"
alias rs="rsync -Pavz"
alias rshop="rsync -Pavz -e \"ssh -o ProxyJump=ruth -o UserKnownHostsFile=${HOME}/.ssh/known_hosts_hop\""
alias rsmop="rsync -Pavz -e \"ssh -o ProxyJump=ruth -l machine -i /root/.ssh/id_rsa -o UserKnownHostsFile=${HOME}/.ssh/known_hosts_machine\""
alias scancel="scancel -u ${USER}"
alias shellcheck="shellcheck -e SC1090,SC2139,SC2155"
alias sshop="ssh -i ${HOME}/.ssh/id_ed25519 -o ProxyJump=ruth -o UserKnownHostsFile=${HOME}/.ssh/known_hosts_hop"
alias sshkeygen="ssh-keygen -t ed25519 -a 100"
alias time="/usr/bin/time -f'\n   %E 〔%e𝑠 wall,  %U𝑠 user,  %S𝑠 sys,  %M KB,  %F faults,  %c switches〕'"
alias trinket="screen /dev/ttyACM0 115200"
alias vg="valgrind -v --log-file=val.log --leak-check=full --show-leak-kinds=all --trace-children=yes"
alias wget="wget -d -c --tries=0 --read-timeout=30"
alias win="sudo intel_gpu_top -s 100"
alias wnv="watch -n 1 nvidia-smi"
alias xpraview="xpra --webcam=no --opengl=no start ssh://bart --start=paraview"

# Slurm shenanigans
safmt="JobID,JobName%20,Partition,ReqCPUS,NodeList%8,State,Start,Elapsed,CPUTime"
sifmt="%9P %10A %8z %14O %.12l %N"
sqfmt="%7i %20j %3t %11P %9Q %6D %5C %20S %12L %17R"
alias si="sinfo -o \"${sifmt}\""
alias sj="sacct --format=User,AssocID,${safmt} -j"
alias sa="sacct --format=${safmt} -u ${USER} -S $(date --date='last week' +%m%d%y)"
alias sq="squeue -o \"${sqfmt}\" -u tnk10"
alias wsq="watch -n 20 'squeue -o \"${sqfmt}\" -u tnk10'"
alias ss="squeue --start -u ${USER}"

if [[ $(hostname -s) == "enki" ]]; then
    alias  sbash="srun -p debug -t 60 -n 1 --pty bash"
    alias squart="srun -p debug -t 60 -n 20 --gres=gpu:1 --pty bash"
elif [[ $(hostname -s) == "ruth" ]]; then
    alias      s4="srun -p gpu -t 120 -n 1  -w rgpu4 --pty bash"
    alias   sbash="srun -p gpu -t  60 -n 1  --pty bash"
    alias  squart="srun -p gpu -t  60 -n 16 --gres=gpu:pascal:1 --pty bash"
    alias svquart="srun -p gpu -t  60 -n 16 --gres=gpu:volta:1  --pty bash"
elif [[ $(hostname -s) == "mr-french" ]]; then
    alias   sbash="srun -p gpu -t  60 -n 1  --pty bash"
    alias  squart="srun -p gpu -t  60 -n 16 --gres=gpu:pascal:1 --pty bash"
    alias svquart="srun -p gpu -t  60 -n 16 --gres=gpu:volta:1  --pty bash"
fi

export ALIAS_SOURCED=1
