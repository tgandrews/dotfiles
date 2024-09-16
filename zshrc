# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

precmd() {
    eval 'if [ "$(id -u)" -ne 0 ]; then echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history | tail -n 1)" >>! ~/Dropbox\ \(TG\ Andrews\ Limited\)/logs/bash/laptop/bash-history-$(date "+%Y-%m-%d").log; fi'
}

ZSH_THEME="robbyrussell"

plugins=(gitfast brew npm yarn)

# Secrets
[[ -f ~/.secrets.sh ]] && . ~/.secrets.sh || true

# User configuration
export PATH="$HOME/bin:/opt/homebrew/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# export MANPATH="/usr/local/man:$MANPATH"
source $ZSH/oh-my-zsh.sh

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

# Use the default node version
nvm use default

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
alias pr='gh pr view $(git branch --show-current) --json title,url,additions,deletions,headRepository --template ":pr: [{{.headRepository.name}}] {{.title}} (+{{.additions}} -{{.deletions}})
:pr-arrow: {{.url}}" | pbcopy'

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true

if [ -d "/opt/homebrew/opt/ruby/bin" ]; then
  export PATH=/opt/homebrew/opt/ruby/bin:$PATH
  export PATH=`gem environment gemdir`/bin:$PATH
fi

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Andorid SDK
export ANDROID_SDK_ROOT=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator
export PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
