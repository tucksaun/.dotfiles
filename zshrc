# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# if [ ! -z ${SSH_AUTH_SOCK_ASKPASS+x} ]; then
#   export SSH_AUTH_SOCK="${SSH_AUTH_SOCK_ASKPASS}"
#   /usr/bin/ssh-add --apple-use-keychain -c
# fi

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="tucksaun"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=7

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    macos
    iterm2
    git
    colored-man-pages
    icloud-credentials
    # per-directory-history
    # aws
    # golang
    asdf
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

########################################################################################
# ZSH
########################################################################################
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export HISTSIZE=100000
export HISTFILESIZE=${HISTSIZE}
export HISTIGNORE="ls:cd:[bf]g:exit:todo:todo_edit"
export HISTCONTROL="ignoreboth" # ignore duplicate line + line which start by a space

export COPY_EXTENDED_ATTRIBUTES_DISABLE=true
export COPYFILE_DISABLE=true

export EDITOR='vim'

# Aliases

alias l='ls -lFh'     #size,show type,human readable
alias la='ls -lAFh'   #long list,show almost all,show type,human readable
alias lr='ls -tRFh'   #sorted by date,recursive,show type,human readable
alias lt='ls -ltFh'   #long list,sorted by date,show type,human readable
alias ll='ls -l'      #long list
alias grep='grep --color'
alias df="df -h"
alias du="du -h"
alias dd="dd status=progress"
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias free="free -m"
alias grep='grep -n --exclude-dir ".svn" --exclude-dir ".git" --exclude tagsi --color=tty'
alias mkdir="mkdir -p"
mkcd() { mkdir "${1}" && cd "${1}"; }

function manprint {
    man -t $1 | open -f -a /System/Applications/Preview.app
}
transfer() {
    if [ $# -eq 0 ]; then echo -e "No arguments specified. Usage:\necho transfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"; return 1; fi
    tmpfile=$( mktemp -t transferXXX ); if tty -s; then basefile=$(basename "$1" | sed -e 's/[^a-zA-Z0-9._-]/-/g'); curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile" >> $tmpfile; else curl --progress-bar --upload-file "-" "https://transfer.sh/$1" >> $tmpfile ; fi; cat $tmpfile; rm -f $tmpfile;
    echo "";
}
function audit_zip() {
  if [ ! -d $1 ]; then echo "Not a valid directory"; return 1; fi
  rm -Rf "$1-archive" || true
  git clone "$1" "$1-archive" && \
  (cd "$1-archive" && git remote rm origin && git rebase --root --ignore-date && git-prune-for-archive && zip -9 -r "../$1-audit.zip" .)
}

## Cool shortcut
alias aria2c="aria2c -c -x 4 --check-certificate=false --file-allocation=none"
alias top="top -i 1 -o cpu"
alias sort="sort -h"
alias mysql="mysql --sigint-ignore"
alias whatsmyip="curl -s checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*$//'"
wdl(){ wget -r -l5 -k -E ${1} && cd $_;}
alias serve_this="python -m SimpleHTTPServer 8081" # Serveur python sur le port 8080
# alias screensaver="/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine &"
alias screensaver="/System/Library/CoreServices/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine"
alias brewup='brew update && brew upgrade && brew cleanup'
alias cleardns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
alias todo="cat ${HOME}/Work/src/github.com/sensiolabs/TODO | \grep -v -E '^[[:space:]]*- \[[XO]\]' | \grep -v -E '^[|]' | less"

# Cool Docker Shortcut
docker-ip() {
  docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@"
}
docker-clean-images() {
  docker rmi $(docker images | grep "^<none>" | awk "{print \$3}")
}
alias phpqa='docker run --init -it --rm -v "$(pwd):$(pwd)" -v "$(pwd)/tmp-phpqa:/tmp" -w "$(pwd)" jakzal/phpqa:php8.1-alpine-arm64'

alias ssh_temp="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
tucknet_upgrade() {
  servers=""
  for arg in $@; do
    if [ "$arg" == "all" ]; then
      servers="$servers fox.tucksaun.net kastalia.tucksaun.net"
    else
      servers="$servers $arg"
    fi
  done

  for server in $servers; do
    ssh -t $server.tucksaun.net "DEBIAN_FRONTEND=noninteractive sudo apt update && sudo apt -qqy dist-upgrade"
  done
}

########################################################################################
# Brew
########################################################################################
eval "$(/opt/homebrew/bin/brew shellenv)"
BREW_PREFIX=$(brew --prefix 2>/dev/null)
PATH="${BREW_PREFIX}/opt/make/libexec/gnubin:$PATH"
export LDFLAGS="-L${BREW_PREFIX}/lib/"
export CPPFLAGS="-I${BREW_PREFIX}/include/"
# export PATH="${BREW_PREFIX}/opt/python/Frameworks/Python.framework/Versions/Current/bin:${BREW_PREFIX}/opt/coreutils/libexec/gnubin:/usr/local/bin:/usr/local/sbin:$PATH" # These REALLY need to come first
# export PATH="/usr/local/opt/curl/bin:$PATH"
# export PATH="/usr/local/opt/bash/bin:$PATH"
# export PATH="${HOME}/Library/Python/3.7/bin:$PATH"

########################################################################################
# PHP
########################################################################################
export COMPOSER_HOME=$HOME/.composer
export PATH=$COMPOSER_HOME/vendor/bin:$HOME/Work/src/github.com/tucksaun/export-compte/bin:$PATH

########################################################################################
# Chef
########################################################################################
export OPSCODE_USER=tucksaun

########################################################################################
# GO
########################################################################################
export GOPATH=$HOME/Work
export GOPRIVATE="github.com/symfonycorp,github.com/tucksaun,github.com/blackfireio"
# export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
# complete -C ${HOME}/Work/bin/gocomplete go

########################################################################################
# Custom PATH
########################################################################################
export PATH="$GOPATH/bin:$HOME/bin:$PATH"

########################################################################################
# Raspberry PI
########################################################################################
#export PATH="$HOME/Work/rpi/arm-cs-tools/bin:$PATH"

########################################################################################
# Yarn
########################################################################################
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

########################################################################################
# Terminal colors
########################################################################################
# export CLICOLOR=1

# export LESS=-R

# export GREP_OPTIONS='--color=auto'
# export GREP_COLOR='1;33'

# export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
# export LSCOLORS=ExFxCxDxBxegedabagacad
# export LS_COLORS='di=34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'

# export TERM=xterm-256color

########################################################################################
# Autocomplete
########################################################################################
FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

typeset -U path cdpath
cdpath=($HOME/Work/src/github.com/tucknet $HOME/Work/src/github.com/vigiesh $HOME/Work/src/github.com/tucksaun $HOME/Work/src/github.com)

zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format %d
zstyle ':completion:*:descriptions' format %B%d%b
zstyle ':completion:*:complete:(cd|pushd):*' tag-order 'path-directories local-directories named-directories'

# Better SSH/Rsync/SCP Autocomplete
zstyle ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'
zstyle ':completion:*:(scp|rsync):*' tag-order ' hosts:-ipaddr:ip\ address hosts:-host:host files'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'
# autoload -U +X bashcompinit && bashcompinit
autoload -Uz compinit && compinit

# makefiles
zstyle ':completion:*:make:*:targets' call-command true
zstyle ':completion:*:*:make:*' tag-order 'targets'

setopt no_share_history
# unsetopt share_history

# PATH="${HOME}/perl5/bin${PATH:+:${PATH}}"; export PATH;
# PERL5LIB="${HOME}/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
# PERL_LOCAL_LIB_ROOT="${HOME}/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
# PERL_MB_OPT="--install_base \"${HOME}/perl5\""; export PERL_MB_OPT;
# PERL_MM_OPT="INSTALL_BASE=${HOME}/perl5"; export PERL_MM_OPT;

export PATH="/opt/homebrew/opt/bison/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/bison/lib"

# pnpm
export PNPM_HOME="/Users/tucksaun/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm endsource "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/zshrc"

eval "$(direnv hook zsh)"
autoload -U +X bashcompinit && bashcompinit
