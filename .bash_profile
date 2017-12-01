export PATH=$HOME/bin:/usr/local/sbin:$PATH

# programs which search for a text editor will use this editor by default
export VISUAL=nvim
export EDITOR="$VISUAL"

export CLICOLOR=1;

#for completing source commands
complete -c source

#This is for golang files, everything outside of the standard go install
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

function _update_ps1() {
    PS1="$(~/go/bin/powerline-go \
        -error $? \
        -cwd-max-depth 1 \
        -modules venv,user,ssh,cwd,perms,git,hg,jobs,exit,root)"
}

if [ "$TERM" != "linux" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

SYSTEM=`uname -a | cut -d" " -f1`
# These things are system specific
if [ $SYSTEM == "Darwin" ]; then
    #Making an alias to show/hide hidden files in the finder
    alias showf='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder \
        /System/Library/CoreServices/Finder.app'
    alias hidef='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder \
        /System/Library/CoreServices/Finder.app'
    alias upgrade='brew update && brew upgrade'
    alias mvim='/Applications/MacVim.app/Contents/MacOS/MacVim'
    alias adb='/Users/Jeff/Library/Android/sdk/platform-tools/adb'
    alias deltaskelta-ssh='ssh jeff@$DELTASKELTA_SERVER -p 31988'
    alias cdgo='cd ~/go/src/github.com/deltaskelta'
    # this is for deleting files from git repository history
    # use as bfg --delete-files [file]
    alias bfg='java -jar /Users/Jeff/bin/bfg-1.12.15.jar'
    alias delve='/usr/local/bin/dlv'
    alias make='gmake'
    alias sed='gsed'

    # my hosting server for sshing into
    export DELTASKELTA_SERVER=138.197.235.247

    # so that it finds the right python when using venv wrapper
    VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3

    #This is for the virtualenvwrapper for python
    source /usr/local/bin/virtualenvwrapper.sh

    if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
    fi

    for file in ~/.completion/* ; do
      if [ -f "$file" ] ; then
        . "$file"
      fi
    done

elif [ $SYSTEM == "Linux" ]; then
    alias upgrade='sudo apt-get update && sudo apt-get upgrade'

    # save the IP address in case I need it later
    export IP_ADDRESS=`ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`
fi

# These things are regardless of system
alias ll='ls -l'
alias la='ls -la'
alias python='python3'
alias pip='pip3'
alias gitl='git log --oneline'
alias ga='git add -A :/'
alias gc='git commit'
alias gs='git status'
alias gac='ga && gc'
alias vim='nvim'
alias docker-rm-none='docker rmi $(docker images -f "dangling=true" -q)'
alias dsize='du -hcs'

# These are not being used, but they might be convenient in the future...
#black='\[\e[30m\]'
#red='\[\e[31m\]'
#green='\[\e[32m\]'
#yellow='\[\e[33m\]'
#blue='\[\e[34m\]'
#magenta='\[\e[35m\]'
#cyan='\[\e[36m\]'
#lgray='\[\e[37m\]'
#dgray='\[\e[90m\]'
#lred='\[\e[91m\]'
#lgreen='\[\e[92m\]'
#lyellow='\[\e[93m\]'
#lblue='\[\e[94m\]'
#lmagenta='\[\e[95m\]'
#lcyan='\[\e[96m\]'
#white='\[\e[97m\]'
#reset='\[\e[0m\]' # reset to default color
