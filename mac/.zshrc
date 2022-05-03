export PATH=$HOME/bin:/usr/local/bin:$PATH:/Users/olem/.cargo/bin
export ZSH="$HOME/.oh-my-zsh"

plugins=(
    git 
    zsh-syntax-highlighting
    web-search
    zsh-fzf-history-search
)

source $ZSH/oh-my-zsh.sh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Aliases
## Better ls
alias l="exa"
alias ls="exa"
alias la="exa -a"
alias ll="exa -l"
alias lla="exa -la"

## Better rm
alias rm="rm -i"

## To folders
export wallpapers="$HOME/Documents/github/wallpapers"
export gdrive="$HOME/Google Drive/My Drive"
export school="$HOME/Documents/school"
export uib="$gdrive/uib"
export mnf130="$uib/semester2/mnf130"
export inf101="$uib/semester2/inf101"

## Cargo
export CARGO_NAME="Ole Magnus Johnsen"
export CARGO_EMAIL="ole.magnus@me.com"xport inf142="$uib/semester2/inf142"

# Alias to scritps
alias lec-to-vid="~/Documents/github/scripts/lec-to-vid.sh"
alias ttest="ttyper -l norwegian -w 50"


alias v="nvim"

eval "$(starship init zsh)"

export HOMEBREW_AUTO_UPDATE_SECS="86400"
export PATH="/usr/local/sbin:$PATH"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

[ -f "/Users/olem/.ghcup/env" ] && source "/Users/olem/.ghcup/env" # ghcup-env
