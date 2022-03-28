# Exports
export PATH=$HOME/.cargo/bin:/usr/local/bin:$HOME/.local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"

## Workflow
export school="$HOME/Documents/school"
export github="$HOME/Documents/github"

## School
export gdrive="$HOME/Google Drive"
export uib="$gdrive/uib"
export mnf130="$uib/semester2/mnf130"
export inf101="$uib/semester2/inf101"
export inf142="$uib/semester2/inf142"

# Plugins
plugins=(git zsh-syntax-highlighting)

# Source?
source $ZSH/oh-my-zsh.sh

# Aliases
alias typer="ttyper -l norwegian -w 25"

alias l="exa"
alias ls="exa"
alias ll="exa -l"
alias la="exa -a"
alias lla="exa -la"

# Starship
eval "$(starship init zsh)"
