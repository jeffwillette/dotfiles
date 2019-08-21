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

# programs which search for a text editor will use this editor by default
export VISUAL=nvim
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

if [ "$TERM" != "linux" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi

SYSTEM=`uname -a | cut -d" " -f1`
HOSTNAME=`hostname`

# These things are system specific
if [ $SYSTEM == "Darwin" ]; then
    #Making an alias to show/hide hidden files in the finder
    alias showf='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder \
        /System/Library/CoreServices/Finder.app'
    alias hidef='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder \
        /System/Library/CoreServices/Finder.app'
    alias upgrade='brew update && brew upgrade'
    alias adb='/Users/Jeff/Library/Android/sdk/platform-tools/adb'
    alias deltaskelta-ssh='ssh jeff@$DELTASKELTA_SERVER -p 31988'
    alias cdgo='cd ~/go/src/github.com/deltaskelta'
    # this is for deleting files from git repository history
    # use as bfg --delete-files [file]
    alias bfg='java -jar /Users/Jeff/bin/bfg-1.12.15.jar'
    alias delve='/usr/local/bin/dlv'
    alias make='gmake'
    alias sed='gsed'
    alias vim='nvim'

    # fixing some weird inkscape error with xquartz
    # https://apple.stackexchange.com/questions/235279/inkscape-or-other-xquartz-window-disappears-when-using-external-screen
    alias fixInkscape='wmctrl -r Inkscape -e 0,1440,900,1200,700'
    alias fixInkscapeExt='wmctrl -r Inkscape -e 0,0,0,1080,1920'

    # turns off the writing of .DS_Store. I think this stays until there is an OS update,
    # so if you notice the files coming back you might need to run it again
    alias nodsstore='defaults write com.apple.desktopservices DSDontWriteNetworkStores true'

    # my hosting server for sshing into
    alias youshowprossh='ssh jeff@youshowpro.com -p 31988'

    # for making the gopass tty work correctly
    export GPG_TTY=$(tty)

    # get gopass completion
    source /dev/stdin <<<"$(gopass completion bash)"

    if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
    fi

    for file in ~/.completion/* ; do
      if [ -f "$file" ] ; then
        . "$file"
      fi
    done

    function _update_ps1() {
        PS1="$(~/go/bin/powerline-go \
            -error $? \
            -cwd-max-depth 1 \
            -modules venv,user,ssh,cwd,perms,git,hg,jobs,exit,root)"
    }

    function update() {
        note "updating brew\n" ${blue}
        brew update
        note "\nupgrading brew\n" ${blue}
        brew upgrade
        note "\ncleaning up brew\n" ${blue}
        brew cleanup

        note "\nchecking and updating brew casks\n" ${blue}
        brew cask outdated
        brew cask upgrade

        note "\nupdating vim plugins\n" ${blue}
        nvim --headless +PlugUpdate +PlugUpgrade +UpdateRemotePlugins +qall

        note "\nupgrading yarn\n" ${blue}
        cd ~/.config/yarn/global
        yarn outdated
        yarn upgrade --latest
        cd -

        note "\nupdating neovim python\n" ${blue}
        source ~/.py_venvs/neovim/bin/activate
        pip install -U pip neovim
        deactivate
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

elif [[ $SYSTEM == "Linux" && $HOSTNAME =~ ^ai[0-9] ]]; then
    echo "KAIST"
    export PATH=$PATH:~/bin
    alias vim='~/bin/nvim.appimage'

    function update() {
        note "\ndownloading nvim appimage\n" ${blue}
    	curl -Lo ~/bin/nvim.appimage https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
        chmod u+x ~/bin/nvim.appimage

        note "\ndownloading powerline go\n" ${blue}
        curl -Lo ~/bin/powerline-go https://github.com/justjanne/powerline-go/releases/download/v1.13.0/powerline-go-linux-amd64
        chmod +x ~/bin/powerline-go

        note "\ndownloading and extracting ripgrep\n" ${blue}
        curl -Lo ~/bin/rg.tar.gz https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep-11.0.2-x86_64-unknown-linux-musl.tar.gz
        cd ~/bin
        tar -xvf rg.tar.gz
        cp ~/bin/ripgrep-11.0.2-x86_64-unknown-linux-musl/rg ~/bin
    }

    function _update_ps1() {
        PS1="$(powerline-go \
            -error $? \
            -cwd-max-depth 1 \
            -modules venv,user,ssh,cwd,perms,git,hg,jobs,exit,root)"
    }

elif [[ $SYSTEM == "Linux" && ! $HOSTNAME =~ ^ai[0-9] ]]; then
    echo "My server"
    alias upgrade='sudo apt-get update && sudo apt-get upgrade'

    # ansible installs go from the source download
    export PATH=$PATH:/usr/local/go/bin

    # save the IP address in case I need it later
    export IP_ADDRESS=`ifconfig eth0 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}'`

    # TODO: if this does not work, look for a trash command in apt
    function trash() {
        cp -R "${1}" ~/.Trash;
        rm -rf "${1}";
    }

    function _update_ps1() {
        PS1="$(~/go/bin/powerline-go \
            -error $? \
            -cwd-max-depth 1 \
            -modules venv,user,ssh,cwd,perms,git,hg,jobs,exit,root)"
    }
fi

# These things are regardless of system
alias ll='ls -l'
alias la='ls -la'
alias gitl='git log --oneline'
alias ga='git add -A :/'
alias gc='git commit'
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
