#!/bin/bash

if [[ -n "${ALIAS_SOURCED}" ]]; then
    return
fi

if [[ -f "${HOME}/.dotfiles/local/HostIP" ]]; then
    source "${HOME}/.dotfiles/local/HostIP"
fi

aguu () {
    # Update Debian and Conda apps
    sudo apt update
    sudo apt dist-upgrade -y
    update-conda
}

man () {
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

    LESS_TERMCAP_mb=$(tput bold; tput setaf 2) \
    LESS_TERMCAP_md=$(tput bold; tput setaf 6) \
    LESS_TERMCAP_me=$(tput sgr0) \
    LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) \
    LESS_TERMCAP_se=$(tput rmso; tput sgr0) \
    LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7) \
    LESS_TERMCAP_ue=$(tput rmul; tput sgr0) \
    LESS_TERMCAP_mr=$(tput rev) \
    LESS_TERMCAP_mh=$(tput dim) \
    LESS_TERMCAP_ZN=$(tput ssubm) \
    LESS_TERMCAP_ZV=$(tput rsubm) \
    LESS_TERMCAP_ZO=$(tput ssupm) \
    LESS_TERMCAP_ZW=$(tput rsupm) \
    GROFF_NO_SGR=1 \
    command man "$@"
}

md2pdf () {
    pandoc --data-dir="${HOME}/.dotfiles/pandoc" \
           --defaults=md2pdf.yaml \
           --output="${1/.md/.pdf}" \
           --shift-heading-level-by=-1 \
           "$1"
}

rot13 () {
	if [[ $# = 0 ]] ; then
		tr "[a-m][n-z][A-M][N-Z]" "[n-z][a-m][N-Z][A-M]"
	else
		tr "[a-m][n-z][A-M][N-Z]" "[n-z][a-m][N-Z][A-M]" < $1
	fi
}

tea () {
    # Set a timer for your tea. Time is measured in seconds.
    timer=300 # default: 5 minutes
    if [[ $(command -v kdialog) == "" ]]; then
        echo "You must install kdialog!"
        timer=0
    fi
    if [[ $# == 1 ]]; then
        timer=$1
    else
        echo -e "Usage: tea [count]\n   eg, tea     # 5 min\n       tea 180 # 3 min"
        timer=0
    fi
    if [[ ${timer} -gt 0 ]]; then
        sleep ${timer}
        kdialog --msgbox "Your tea is ready."
    fi
}

update-conda() {
    # Update Anaconda Python and all its virtual environments
    echo "=== Updating conda base ==="
    mamba update -n base --yes --all
    if [[ -a ~/.conda/anaconda ]]; then
        for dir in "${HOME}"/.conda/anaconda/envs/*; do
            name=$(basename "${dir}")
            echo -e "\n=== Updating ${name} env ===\n"
            mamba update -n "${name}" --yes --all
        done
    elif [[ -a /Valhalla/opt/mambaforge ]]; then
        for dir in /Valhalla/opt/mambaforge/envs/*; do
            name=$(basename "${dir}")
            echo -e "\n=== Updating ${name} env ===\n"
            mamba update -n "${name}" --yes --all
        done
    fi
}

whoareu() {
    # Print the name of the person assigned the specified ID
    local user
    local info
    user=$(id -u "${1}")
    info=$(getent passwd "${user}")
    echo "${info}" | awk -F':' '{print $5}' | awk -F',' '{print $1}'
}

alias acs="apt-cache search"
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
alias fixperm="find . -perm -u=r -a -not -perm -o=r -exec chmod -v a+r {} \; ; find . -perm -u=x -a -not -perm -o=x -exec chmod -v a+x {} \;"
alias gdb="gdb -q"
alias grafana="ssh -L 3000:localhost:3000 mr-french"
alias grep='grep --color=auto --line-number --with-filename'
alias gs="git status"
alias fgrep='fgrep --color=auto --line-number --with-filename'
alias egrep='egrep --color=auto --line-number --with-filename'
alias guvc="guvcviewer -x 1600x1200"
alias kernperf="perf stat -e cycles,instructions,cache-references,cache-misses,branches,branch-misses,task-clock,faults,minor-faults,context-switches,migrations -r 3"
alias less="less -mNR"
alias ldvi="ldapvi --base 'ou=People,dc=ctcms,dc=gov' -H ldaps://smithers.nist.gov -Y GSSAPI" # first, kinit root/admin
alias ls='ls --group-directories-first --color=auto'
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -hal'
alias md2pdf="pandoc -f markdown -t pdf --template=simple.latex"
alias mmbi="mamba install --quiet"
alias mmbs="mamba search --quiet"
alias more="less -mNR"
alias mmspstyle="/usr/bin/astyle --style=linux --indent-col1-comments --indent=tab --indent-preprocessor --indent-preproc-cond --pad-header --align-pointer=type --keep-one-line-blocks --suffix=none"
alias p="python3 -i -c 'from math import pi' 2>/dev/null"
alias pdf="qpdfview"
alias ping="ping -c 4"
alias pip="python3 -m pip"
alias please="sudo"
if [[ $(which pygmentize) != "" && -f "${HOME}/bin/color-cat" ]]; then
    alias ccat="${HOME}/bin/color-cat"
    alias pyg="${HOME}/bin/color-cat"
fi
alias R='R --no-restore --no-save'
alias rm="rm -v"
alias rockstar="node ${HOME}/repositories/rockstar/satriani/rockstar.js"
alias rs="rsync -Pavz"
alias rshop="rsync -Pavz -e \"ssh -o ProxyJump=ruth -o UserKnownHostsFile=${HOME}/.ssh/known_hosts_hop\""
alias rsmop="rsync -Pavz -e \"ssh -o ProxyJump=ruth -l machine -i /root/.ssh/id_rsa -o UserKnownHostsFile=${HOME}/.ssh/known_hosts_machine\""
alias scancel="scancel -u ${USER}"
alias shellcheck="shellcheck -e SC1090,SC2139,SC2155"
alias si="sinfo -o \"%9P %10A %8z %14O %.12l %N\""
alias sj="sacct --format=User,AssocID,JobID,JobName,Partition,ReqCPUS,NNodes,NTasks,NCPUS,NodeList,Layout,State,Elapsed,CPUTime -j"
alias sa="sacct --format=JobID,JobName%20,Partition,ReqCPUS,NodeList%8,State,Start,Elapsed,CPUTime -u ${USER} -S $(date --date='last week' +%m%d%y)"
alias sq="squeue -o \"%7i %20j %3t %11P %9Q %6D %5C %20S %12L %17R\" -u tnk10"
alias wsq="watch -n 20 'squeue -o \"%7i %11j %3t %7q %11P %9Q %6D %5C %20S %12L %17R %Y\" -u tnk10'"
alias ss="squeue --start -u ${USER}"
alias sshop="ssh -i ${HOME}/.ssh/id_ed25519 -o ProxyJump=ruth -o UserKnownHostsFile=${HOME}/.ssh/known_hosts_hop"
alias sshkeygen="ssh-keygen -t ed25519 -a 100"
function ssm {
    if [[ $# == 0 || $1 == "--help" || $1 == "-h" ]]; then
        echo -e "\e[0;32mssm\e[0;39m: SSH to the specified host as \e[0;35mmachine\e[0;39m"
        echo "«Usage:»$ ssm host"
    elif [[ $# == 1 ]]; then
        ssh -A -l machine \
            -o UserKnownHostsFile=${HOME}/.ssh/known_hosts_su \
            $1
    else
        ssh -A -l machine \
            -o UserKnownHostsFile=${HOME}/.ssh/known_hosts_su \
            $@
    fi
}
function ssr {
    if [[ $# == 0 || $1 == "--help" || $1 == "-h" ]]; then
        echo -e "\e[0;32mssr\e[0;39m: SSH to the specified host as \e[0;31mroot\e[0;39m"
        echo "«Usage:»$ ssr host"
    elif [[ $# == 1 ]]; then
        ssh -A -l root \
            -o UserKnownHostsFile=${HOME}/.ssh/known_hosts_su \
            $1
    else
        ssh -A -l root \
            -o UserKnownHostsFile=${HOME}/.ssh/known_hosts_su \
            $@
    fi
}
function ssv {
    if [[ $# != 1 || $1 == "--help" || $1 == "-h" ]]; then
        echo -e "\e[0;32mssm\e[0;39m: SSH to the specified host as \e[0;35mroot\e[0;39m"
        echo "«Usage:»$ ssv host"
    else
        ssh -A \
            -o UserKnownHostsFile=${HOME}/.ssh/known_hosts_vc \
            -i /root/.ssh/id_ed25519 \
            root@$1
    fi

}
alias time="/usr/bin/time -f'\n   %E 〔%e𝑠 wall,  %U𝑠 user,  %S𝑠 sys,  %M KB,  %F faults,  %c switches〕'"
alias trinket="screen /dev/ttyACM0 115200"
alias vg="valgrind -v --log-file=val.log --leak-check=full --show-leak-kinds=all --trace-children=yes"
alias wget="wget -d -c --tries=0 --read-timeout=30"
alias win="sudo intel_gpu_top -s 100"
alias wnv="watch -n 1 nvidia-smi"
alias xpraview="xpra --webcam=no --opengl=no start ssh://renfield --start=paraview"

if [[ $(hostname -s) == "huginn" ]]
then
    alias airplanemode="if [[ $(nmcli n connectivity) == 'none' ]]; then nmcli n on; elif [[ $(nmcli n connectivity) == 'full' ]]; then nmcli n off; fi"
    alias wihome="nmcli con up home"
    alias wiwork="nmcli con up work passwd-file ${HOME}/.wifi"
fi

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
