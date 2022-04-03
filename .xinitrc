# $HOME/.local/bin/mount-drives &
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

source ~/.fehbg

export QT_STYLE_OVERIDE=GTK+
export TERMINAL=kitty
export XDG_CONFIG_HOME=$HOME/.config

exec bspwm
