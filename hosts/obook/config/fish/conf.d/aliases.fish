# Aliases
abbr -a l "lsd -l"
abbr -a ls "lsd"
abbr -a la "lsd -a"
abbr -a ll "lsd -l"
abbr -a lla "lsd -la"
abbr -a lt "lsd --tree"

# Common git commands
abbr -a g "git"
abbr -a ga "git add"
abbr -a gc "git commit -m"
abbr -a gpf "git push --force-with-lease"

# brew
abbr -a b "brew"
abbr -a bi "brew install"
abbr -a bu "$DOTFILES/bin/update-mac"

# Lazygit
abbr -a lg "lazygit"

# dotdot
abbr -a .. "cd .."
abbr -a ... "cd ../.."
abbr -a .... "cd ../../.."
abbr -a ..... "cd ../../../.."
abbr -a ...... "cd ../../../../.."
abbr -a ......... "cd ../../../../../.."
abbr -a .......... "cd ../../../../../../.."

# Project navigation
abbr -a dots "cd $DOTFILES"
abbr -a conf "cd $HOME/.config"
