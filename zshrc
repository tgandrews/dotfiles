# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

precmd() {
    eval 'if [ "$(id -u)" -ne 0 ]; then echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history | tail -n 1)" >>! ~/Dropbox/logs/bash/laptop/bash-history-$(date "+%Y-%m-%d").log; fi'
}

ZSH_THEME="robbyrussell"

plugins=(git npm yarn)

# User configuration

export PATH="$HOME/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# export MANPATH="/usr/local/man:$MANPATH"
source $ZSH/oh-my-zsh.sh

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

# Auto .nvmrc
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

export EDITOR='code --wait'

alias gs='git status -s'
alias gc='git commit'
alias ga='git add'
alias gf='git fetch -p --tags && git pull --rebase'
alias gd='git diff'
alias gdc='git diff --cached'
alias gco='git checkout'
alias gpf='git push --force-with-lease'
alias grmu=$'gs | grep \'??\' | awk -F \' \' \'{ print "rm -rf "$2 }\' | bash'
alias gl='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias grmb='git branch --merged | grep -v "\*" | grep -v master | grep -v dev | xargs -n 1 git branch -d'
alias grmbr=$'git branch -vv | awk \'{print $1,$4}\' | grep \'gone]\' | awk \'{print $1}\' | xargs -n 1 git branch -D'
alias ll='ls -lah'

nvm use default