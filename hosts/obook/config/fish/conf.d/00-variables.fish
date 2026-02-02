# Environment variables

set -gx EDITOR nvim
set -gx GOPATH $HOME/go
set -gx CARGO_NAME "Ole Magnus Johnsen"
set -gx CARGO_EMAIL "ole.magnus@me.com"
set -gx XDG_CONFIG_HOME $HOME/.config
set -gx PROGRAMMING $HOME/Developer
set -gx DOTFILES $PROGRAMMING/github/dotfiles
set -gx BUN_INSTALL $HOME/.bun
set -gx PNPM_HOME $HOME/Library/pnpm
set -gx PYENV_ROOT $HOME/.pyenv
set -gx PHP_INI_SCAN_DIR $HOME/.config/herd-lite/bin:$PHP_INI_SCAN_DIR
set -gx DOCKERHOST unix://$COLIMA_HOME/default/docker.sock

