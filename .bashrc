# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac
#
# These things are system specific
if [[ $SYSTEM == "Linux" && $HOSTNAME =~ ^ai[0-9] ]]; then
    echo "setting home to /c2/jeff on KAIST server"
    export HOME=/c2/jeff
fi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

SYSTEM=`uname -a | cut -d" " -f1`
export HOSTNAME=`hostname`
set -o vi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac


# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export PATH=$HOME/bin:/usr/local/sbin:$PATH

# these used to be in the format of \[\e[30m\] but using printf printed the brackets.
# I am not sure why that was the format, but worth noting
black='\e[30m'
red='\e[31m'
green='\e[32m'
yellow='\e[33m'
blue='\e[34m'
magenta='\e[35m'
cyan='\e[36m'
lgray='\e[37m'
dgray='\e[90m'
lred='\e[91m'
lgreen='\e[92m'
lyellow='\e[93m'
lblue='\e[94m'
lmagenta='\e[95m'
lcyan='\e[96m'
white='\e[97m'
reset='\e[0m' # reset to default color

# programs which search for a text editor will use this editor by default,
# vim should be aliased to neovim somewhere later in here
export VISUAL=vim
export EDITOR="$VISUAL"

export CLICOLOR=1;
export TSS_LOG="-level verbose -file /tmp/tsserver.log"

#for completing source commands
complete -c source


#This is for golang files, everything outside of the standard go install
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# note with args of $1 = text and $2 = color variable will printf that line with colo
function note() {
    printf "$2$1${reset}"
}

function trash () {
    note "moving ${@} to trash\n" ${blue}
    now="$(date +%Y%m%d_%H%M%S)"
    mkdir -p ~/.trash/$now
    mv "$@" ~/.trash/$now
}

function emptytrash() {
    note "emptying trash\n" ${blue}
    rm -rf ~/.trash
    mkdir ~/.trash
}

function _update_ps1() {
    PS1="$(powerline-go \
    	-error $? \
        -cwd-max-depth 1 \
        -modules venv,host,cwd,perms,git,hg,jobs,exit,root)"
}


export NVIM_SAVE_LINK=~/bin/vim
export FD_SAVE_LINK=~/bin/fd.tar.gz
export DENO_SAVE_LINK=~/bin/deno.zip
export RG_SAVE_LINK=~/bin/rg.tar.gz

function download_nvim() {
    note "\ndownloading nvim appimage\n" ${blue}
    # curl -Lo $NVIM_SAVE_LINK https://github.com/neovim/neovim/releases/download/v0.10.0/nvim.appimage
    curl -Lo $NVIM_SAVE_LINK https://github.com/neovim/neovim/releases/download/v0.10.1/nvim.appimage
    # curl -Lo $NVIM_SAVE_LINK https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
    chmod u+x $NVIM_SAVE_LINK
}

function download_fd() {
    note "\ndownloading fd\n" ${blue}
    # url=https://github.com/sharkdp/fd/releases/download/v9.0.0/fd-v9.0.0-x86_64-unknown-linux-gnu.tar.gz
    # file=fd-v9.0.0-x86_64-unknown-linux-gnu
    url=https://github.com/sharkdp/fd/releases/download/v10.2.0/fd-v10.2.0-i686-unknown-linux-gnu.tar.gz
    file=fd-v10.2.0-i686-unknown-linux-gnu

    curl -Lo $FD_SAVE_LINK ${url}

    cd ~/bin
    tar -xvf fd.tar.gz
    mv ~/bin/${file}/fd ~/bin/fd
    rm -r ${file}
    rm fd.tar.gz
}

function download_deno() {
    # deno is a runtime for vim plugins, needs the exectuable to use advanced vim features.
    note "\ndownloading deno exectuable\n" ${blue}
    # curl -Lo $DENO_SAVE_LINK https://github.com/denoland/deno/releases/download/v1.45.0/deno-x86_64-unknown-linux-gnu.zip
    curl -Lo $DENO_SAVE_LINK https://github.com/denoland/deno/releases/download/v1.46.1/deno-x86_64-unknown-linux-gnu.zip 

    cd ~/bin
    unzip -o deno.zip
}

function download_rg {
    note "\ndownloading and extracting ripgrep\n" ${blue}
    # curl -Lo $RG_SAVE_LINK https://github.com/BurntSushi/ripgrep/releases/download/14.0.3/ripgrep-14.0.3-x86_64-unknown-linux-musl.tar.gz
    curl -Lo $RG_SAVE_LINK https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep-14.1.0-x86_64-unknown-linux-musl.tar.gz
    cd ~/bin
    tar -xvf rg.tar.gz
    cp ~/bin/ripgrep-14.0.3-x86_64-unknown-linux-musl/rg ~/bin
    rm -r ripgrep-14.0.3-x86_64-unknown-linux-musl
}

if [ "$TERM" != "linux" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

# These things are system specific
if [ $SYSTEM == "Darwin" ]; then
    #Making an alias to show/hide hidden files in the finder

    export PATH=$PATH:/usr/local/opt/coreutils/libexec/gnubin:/opt/homebrew/bin
    export MANPATH=/usr/local/opt/coreutils/libexec/gnuman:$MANPATH
    alias showf='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder \
        /System/Library/CoreServices/Finder.app'
    alias hidef='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder \
        /System/Library/CoreServices/Finder.app'
    alias login-kaist-desktop='ssh jeff@143.248.158.60'

    alias cdgo='cd ~/go/src/github.com/deltaskelta'
    # this is for deleting files from git repository history
    # use as bfg --delete-files [file]
    alias bfg='java -jar /Users/Jeff/bin/bfg-1.12.15.jar'
    alias delve='/usr/local/bin/dlv'
    alias make='gmake'
    alias sed='gsed'
    alias vim='nvim'

    # turns off the writing of .DS_Store. I think this stays until there is an OS update,
    # so if you notice the files coming back you might need to run it again
    alias nodsstore='defaults write com.apple.desktopservices DSDontWriteNetworkStores true'

    if type brew &>/dev/null
    then
      HOMEBREW_PREFIX="$(brew --prefix)"
      if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
      then
        source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
      else
        for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
        do
          [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
        done
      fi
    fi

    for file in ~/.completion/* ; do
      if [ -f "$file" ] ; then
        . "$file"
      fi
    done

    function update() {
        note "updating brew\n" ${blue}
        brew update
        note "\nupgrading brew\n" ${blue}
        brew upgrade
        note "\ncleaning up brew\n" ${blue}
        brew cleanup

        note "\nchecking and updating brew casks\n" ${blue}
        brew outdated --cask
        brew upgrade --cask

        note "\nupdating vim plugins\n" ${blue}
        nvim --headless +PlugUpdate +PlugUpgrade +UpdateRemotePlugins +qall
    }

    # to search an entire git history for a word, if you want to re-write the line in history exec the cmd below
    # filename=src/pages/docker-go-sdk-mount git filter-branch -f --tree-filter 'test -f $filename && gsed -i "s/search/replace/" $filename  || echo “skipping file“' -- --all
    function gitgrep() {
      git grep ${1} $(git rev-list --all)
    }

    function noDsStore() {
        sudo find / -name .DS_Store -type f | xargs rm
        defaults write com.apple.desktopservices DSDontWriteNetworkStores true
    }

    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/Users/jeff/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/Users/jeff/anaconda3/etc/profile.d/conda.sh" ]; then
            . "/Users/jeff/anaconda3/etc/profile.d/conda.sh"
        else
            export PATH="/Users/jeff/anaconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<

elif [[ $SYSTEM == "Linux" && $HOSTNAME =~ ^ai[0-9] ]]; then
    # this is for general linux systems that I control
    echo "KAIST AI SERVER"

    # add neovim bin so that the install executables are visible
    export PATH=/c2/jeff/bin:/usr/local/sbin:$PATH

    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/c2/jeff/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    eval "$__conda_setup"
    unset __conda_setup
    # <<< conda initialize <<<

    export __GL_SHADER_DISK_CACHE_PATH=/c2/jeff/.nv
    export DENO_DIR=/c2/jeff/.tmp  # needed for this bug: https://github.com/denoland/deno/issues/16577
    # this was added for the rl experiments for my CS572 project
    # export PATH=/usr/local/cuda-10.1/bin:$PATH
    # export LD_LIBRARY_PATH=/usr/local/cuda-10.1/lib64:/home/jeff/.mujoco/mujoco200/bin:$LD_LIBRARY_PATH
    export LD_LIBRARY_PATH=/home/jeff/.mujoco/mujoco200/bin:$LD_LIBRARY_PATH
    export CUDA_DEVICE_ORDER=PCI_BUS_ID
    export XAUTHORITY=/home/jeff/.Xauthority
    export XDG_CACHE_HOME=/c2/jeff/.tmp
    export XDG_CONFIG_HOME=/c2/jeff/.config
    export HOME=/c2/jeff
    export TMPDIR=/tmp
    export WORKPLACE=KAIST
    export DATADIR=/d1/dataset
    # for using hdf5 files on the server. Doing anything with hdf5 files
    # causes an error without this
    export HDF5_USE_FILE_LOCKING=TRUE

    function update() {
	note "downloading binaries\n" ${blue}
	download_nvim
        download_fd
        download_rg
        download_deno

        note "\ndownloading powerline go\n" ${blue}
        # curl -Lo ~/bin/powerline-go https://github.com/justjanne/powerline-go/releases/download/v1.21.0/powerline-go-linux-amd64
        curl -Lo ~/bin/powerline-go https://github.com/justjanne/powerline-go/releases/download/v1.24/powerline-go-linux-amd64
        chmod +x ~/bin/powerline-go

    }

    export IP_ADDRESS=`ip -4 address | grep inet | tail -n 1 | cut -d " " -f 8`

elif [[ $SYSTEM == "Linux" && $HOSTNAME =~ .*"desktop".* ]]; then
    note "Linux Desktop\n" ${blue}
    #
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/home/jeff/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    eval "$__conda_setup"
    unset __conda_setup
    # <<< conda initialize <<<

    SSH_ENV="$HOME/.ssh/environment"
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/jeff/.mujoco/mujoco200/bin
    export PATH=/usr/local/cuda-12.1/bin${PATH:+:${PATH}}
    export LD_LIBRARY_PATH=/usr/local/cuda-12.4/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

    function start_agent {
        echo "Initialising new SSH agent..."
        /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
        echo succeeded
        chmod 600 "${SSH_ENV}"
        . "${SSH_ENV}" > /dev/null
        /usr/bin/ssh-add ~/.ssh/*rsa
    }

    # Source SSH settings, if applicable
    if [ -f "${SSH_ENV}" ]; then
        . "${SSH_ENV}" > /dev/null
        #ps ${SSH_AGENT_PID} doesn't work under cywgin
        ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
            start_agent;
        }
    else
        start_agent;
    fi

    # run tmux with systemd so that I can logout and still have tmux running (https://unix.stackexchange.com/questions/490267/prevent-logoff-from-killing-tmux-session)
    alias tmux='systemd-run --scope --user tmux'
    alias python='python3'
    export WORKPLACE=Linux

    function update() {
	note "downloading binaries\n" ${blue}
	download_nvim
    	download_fd
    	download_rg
    	download_deno

	note "apt update\n" ${blue}
	sudo apt -y update && sudo apt -y upgrade
    }

    export PATH=~/go/bin:$PATH

    export IP_ADDRESS=`ip -4 address | grep inet | tail -n 1 | cut -d " " -f 8`
fi

# These things are regardless of system
LS_COLORS=$LS_COLORS:'di=1;36'
alias ll='ls -alF'
alias la='ls -lA --block-size=K'
alias l='ls -CF'
alias gitl='git log --oneline'
alias ga='git add -A :/'
alias gc='git commit --verbose'
alias gs='git status'
alias gac='ga && gc'
alias gmend='git commit --amend --no-edit'
alias docker-rm-none='docker rmi $(docker images -f "dangling=true" -q)'
alias dsize='du -hcs'
alias aplay='ansible-playbook'

# rename file extensions in directory from 1 to 2
function renameExt() {
    for file in *."${1}"
    do
        mv "$file" "${file%.${1}}.${2}"
    done
}

# example of how to sed over multiple files
# grep -rl LIABILITYACCOUNTNAME ./* | xargs gsed -i 's/LIABILITYACCOUNTNAME/LIABILITYACCOUNT/g'
function replace() {
    grep \
        -rl \
        --exclude-dir coverage \
        --exclude-dir node_modules \
        --exclude-dir .cache \
        --exclude-dir vendor \
        --exclude-dir public \
        --exclude yarn.lock \
        "${1}" "${3}" | xargs gsed -i "s|${1}|${2}|g"
}

