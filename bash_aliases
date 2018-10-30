#!/usr/bin/env bash

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.bash.d/dircolors && eval "$(dircolors -b ~/.bash.d/dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias l='ls -CF'
    alias la='ls -A'
    alias ll='ls -l'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
if [[ $(hostname -s) == "p859561" ]]; then
    alias agi="apt-get -s install"
    alias condact="source /site/x86/anaconda-1.8/anaconda/bin/activate"
    alias condeact="source /site/x86/anaconda-1.8/anaconda/bin/deactivate"
elif [[ $(hostname -s) == "huginn" ]]; then
        alias agi="sudo apt-get install"
        alias aguu="sudo apt update; sudo apt upgrade -y"
        alias condact="source /usr/local/tnk10/opt/anaconda/bin/activate"
        alias condeact="source /usr/local/tnk10/opt/anaconda/bin/deactivate"
else
    alias agi="sudo apt install"
    alias aguu="sudo apt update; sudo apt upgrade -y"
    alias condact="source $HOME/anaconda/bin/activate"
    alias condeact="source $HOME/anaconda/bin/deactivate"
fi
alias acs="apt-cache search"
alias addroot="su root -c 'stty -echo; /usr/bin/ssh-add -c -t 8h /root/.ssh/id_rsa; stty echo'"
alias astyle="astyle --style=linux --indent-col1-comments --indent=tab --indent-preprocessor --pad-header --align-pointer=type --keep-one-line-blocks --suffix=none"
alias convertbw="convert -density 300 -colorspace gray"
alias e="emacsclient -t"
alias ec="emacsclient -c -a emacs"
alias ed="emacs --daemon"
alias ek="emacsclient -e '(kill-emacs)'"
alias se="sudo emacs -nw"
alias gdb="gdb -q"
alias gue="git config user.email 'trevor.keller@gmail.com'"
alias ifstat="sudo iftop -i enp0s31f6"
alias jbld="docker run --rm --volume=$PWD:/srv/jekyll -it jekyll/jekyll:stable jekyll build"
alias jsrv="docker run --rm --volume=$PWD:/srv/jekyll -p 4000:4000 -it jekyll/jekyll:stable jekyll serve"
alias kernperf="perf stat -e cycles,instructions,cache-references,cache-misses,branches,branch-misses,task-clock,faults,minor-faults,context-switches,migrations -r 3"
alias mmspstyle="/usr/bin/astyle --style=linux --indent-col1-comments --indent=tab --indent-preprocessor --indent-preproc-cond --pad-header --align-pointer=type --keep-one-line-blocks --suffix=none"
alias nettop="sudo nethogs enp0s31f6"
alias p="python 2>/dev/null"
alias pss="pacman -Ss"
alias psi="sudo pacman -S"
alias psu="sudo pacman -Syu"
alias rsync="rsync -Pavz"
alias rsynquickly="rsync -aHAXxv --numeric-ids --delete --progress -e 'ssh -T -c arcfour128 -o Compression=no -x'"
alias sbash="srun --pty -n 20 bash"
alias si="sinfo -o \"%20P %5D %14F %8z %10m %10d %11l %16f %N\""
alias sj="sacct --format=User,AssocID,JobID,JobName,Partition,ReqCPUS,NNodes,NTasks,NCPUS,NodeList,Layout,State,Elapsed,CPUTime -j"
alias sq="squeue -o \"%7i %10j %10P %9Q %6D %5C %11R %o\" -u"
alias ss="squeue --start -u $USER"
alias time="/usr/bin/time -f' Time (%E wall, %U user, %S sys)'"
alias vg="valgrind -v --log-file=val.log --leak-check=full --show-leak-kinds=all --trace-children=yes"
alias wdd="sudo dd bs=4M conv=fsync status=progress"
alias win="sudo intel_gpu_top -s 100"
alias wnv="watch -n 1 nvidia-smi"
if [[ $(hostname -s) == 'huginn' ]]
then
	alias airplanemode="if [[ $(nmcli n connectivity) == 'none' ]]; then nmcli n on; elif [[ $(nmcli n connectivity) == 'full' ]]; then nmcli n off; fi"
	alias wihome="nmcli con up home"
	alias wiwork="nmcli con up work passwd-file ~/.wifi"
fi
whoareu () {
    local user=$(id -u $1)
    local info=$(getent passwd $user)
    echo $info | awk -F':' '{print $5}' | awk -F',' '{print $1}'
}
