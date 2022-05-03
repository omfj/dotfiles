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

## ENV
export TERMINAL=kitty
export XDG_CONFIG_HOME=$HOME/.config
export npm_config_prefix="$HOME/.local"

# Style QT
export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_STYLE_OVERIDE="GTK+"
  

# Plugins
plugins=(git zsh-syntax-highlighting)

# Source
source $ZSH/oh-my-zsh.sh

# Aliases

## Ttyper
alias typer="ttyper -l norwegian -w 25"

## Better ls
alias l="exa"
alias ls="exa"
alias ll="exa -l"
alias la="exa -a"
alias lla="exa -la"

## SSH with kitty
alias ssh="kitty +kitten ssh"

## Get around quick
alias cddot="cd $HOME/Documents/github/dotfiles"
alias cdscr="cd $HOME/Documents/github/scripts"
alias cdwal="cd $HOME/Documents/github/wallpapers"
alias cdsch="cd $HOME/Documents/school"
alias cdrea="cd $HOME/Documents/reading"
alias cdpic="cd $HOME/Pictures"
alias cdlec="cd $HOME/Videos/lectures"

# Starship
eval "$(starship init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
