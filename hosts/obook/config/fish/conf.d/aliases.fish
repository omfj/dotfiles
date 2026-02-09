# Aliases
abbr -a l "eza"
abbr -a ls "eza"
abbr -a la "eza -a"
abbr -a ll "eza -l"
abbr -a lla "eza -la"
abbr -a i "pnpm i"
abbr -a cat "bat"

# Common git commands
abbr -a g "git"
abbr -a ga "git add"
abbr -a gc "git commit -m"

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

# UUID
abbr -a uuid "echo \"$(uuidgen)\" | tr \"[:upper:][:lower:]\" \"[:lower:][:upper:]\""

