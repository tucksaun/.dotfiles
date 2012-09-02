alias sudo="sudo " # Hack, for sudo an aliases

#alias ls="ls --color"
alias ls="ls -G"
alias ll="ls -lh"
alias lla="ll -a"
alias l="ll"

alias df="df -h"
alias du="du -h"
alias free="free -m"

alias cp="cp -i"
alias mv="mv -i"
alias rm="rm -i"

alias mkdir="mkdir -p"
mkcd() { mkdir "${1}" && cd "${1}" }


alias ssh="ssh -A"

alias grep='grep -n --exclude-dir ".svn" --exclude-dir ".git" --exclude tagsi --color=tty'
alias sed="sed --follow-symlinks"

## Archive
alias untar="tar xvf"
alias ungz="gunzip"
alias unzip2="bzip2 -d"
alias untargz="tar zxvf"
alias untarbz1="tar jxvf"
alias ungz2="bunzip2 -k"
mktar() { tar cvf  "${1%%/}.tar"     "${1%%/}/"; }
mktgz() { tar cvzf "${1%%/}.tar.gz"  "${1%%/}/"; }
mktbz() { tar cvjf "${1%%/}.tar.bz2" "${1%%/}/"; }

function extract()
{
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1     ;;
            *.tar.gz)    tar xvzf $1     ;;
            *.bz2)       bunzip2 $1      ;;
            *.rar)       unrar x $1      ;;
            *.gz)        gunzip $1       ;;
            *.tar)       tar xvf $1      ;;
            *.tbz2)      tar xvjf $1     ;;
            *.tgz)       tar xvzf $1     ;;
            *.zip)       unzip $1        ;;
            *.Z)         uncompress $1   ;;
            *.7z)        7z x $1         ;;
            *)           echo "'$1' cannot be extracted via >extract<" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

## Cool shortcut
alias aria2c="aria2c -c -x 4 --check-certificate=false --file-allocation=none"
alias top="top -i 1 -o cpu"
alias mysql="mysql --sigint-ignore"
alias whatsmyip="curl -s checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*$//'"
alias serve_this="python -m SimpleHTTPServer 8080" # Serveur python sur le port 8080
alias reload_bash="source ~/.bashrc" # recharger le ~/.bashrc