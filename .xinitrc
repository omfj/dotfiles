$HOME/.local/bin/mount-drives &
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

betterlockscreen --lock blur
source ~/.fehbg

export QT_STYLE_OVERIDE=GTK+
export TERMINAL=kitty
