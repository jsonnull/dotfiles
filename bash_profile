# vim: filetype=sh

if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

source ~/.cargo/env
export PATH="Users/jsonnull/.local/bin:$PATH"

export HISTFILESIZE=10000
export HISTSIZE=10000
export EDITOR='vim'

function git-branch-name {
  git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3
}
function git-branch-prompt {
  local branch=`git-branch-name`
  if [ $branch ]; then printf "  %s" $branch; fi
}

BG_BLUE="\[\033[44m\]"
BG_BLACK="\[\033[40m\]"
BG_WHITE="\[\033[47m\]"
BG_CYAN="\[\033[46m\]"
BG_GREEN="\[\033[42m\]"
BG_YELLOW="\[\033[43m\]"

FG_WHITE="\[\033[0;97m\]"
FG_WHITE_BOLD="\[\033[1;97m\]"
FG_BLACK="\[\033[0;30m\]"
FG_BLACK_BOLD="\[\033[1;30m\]"
FG_ORANGE_BOLD="\[\033[1;93m\]"
FG_YELLOW="\[\033[0;33m\]"

BG0=$BG_BLUE
BG1=$BG_YELLOW

FG0=$FG_WHITE
FG1=$FG_WHITE_BOLD
FGBLUE="\[\033[1;34m\]" # bold blue
FG2=$FG_BLACK
FG3=$FG_YELLOW

RESET="\[\033[0m\]"

PS1="${FG0}${BG0} \u ${FG1}\W ${FGBLUE}${BG1}${FG2}${BG1}\$(git-branch-prompt) ${RESET}${FG3}${RESET} \$ "

# NPM 5
export PATH="/Users/jsonnull/.npm-packages/bin:/Users/jsonnull/.config/yarn/global/node_modules/.bin:$PATH"

# MacPorts
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"