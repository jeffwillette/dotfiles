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
    alias ls='ls --color'

    LS_COLORS="rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:";
    export LS_COLORS

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
