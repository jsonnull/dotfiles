# vim: filetype=sh

alias vim='nvim'
alias ls='exa'
# alias ls='ls -GA'
alias tmux='tmux -u'
alias tn='tmux new -n `basename "$PWD"`'
alias tl='tree -C -a -L 1 -I "node_modules|.git"'
alias tl2='tree -C -a -L 2 -I "node_modules|.git"'
alias tl3='tree -C -a -L 3 -I "node_modules|.git"'
alias tl4='tree -C -a -L 4 -I "node_modules|.git"'
alias rmdnscache='sudo discoveryutil mdnsflushcache'
alias treetop='tree -L 1'

test -f ~/.git-completion.bash && . $_

vagrant(){
    if [[ $@ == "ip" ]]; then
        command vagrant ssh -c ifconfig | grep -oE "inet addr:\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}" | grep -oE "\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}" | tail -n 2 | head -n 1
    elif [[ $1 == "host" ]]; then
        command sudo sh -c "echo $(vagrant ip) $2 >> /etc/hosts"
    else
        command vagrant "$@"
    fi
}

# OPAM configuration
. /Users/jsonnull/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

# added by travis gem
[ -f /Users/jsonnull/.travis/travis.sh ] && source /Users/jsonnull/.travis/travis.sh