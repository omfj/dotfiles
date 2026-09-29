set -g fish_user_paths
fish_add_path --path \
    $HOME/.vite-plus/bin \
    $HOME/.ghcup/bin \
    $HOME/.cargo/bin \
    $HOME/.local/bin \
    $HOME/.deno/bin \
    $HOME/.atuin/bin \
    $GOPATH/bin \
    $HOME/.slack/bin \
    $BUN_INSTALL/bin \
    $HOME/.emacs.d/bin \
    /usr/local/bin \
    /usr/local/sbin \
    /usr/local/opt/openjdk/bin \
    /opt/homebrew/bin \
    /opt/homebrew/opt/openjdk/bin \
    /opt/homebrew/opt/llvm/bin \
    /opt/homebrew/opt/postgresql@15/bin \
    /opt/homebrew/opt/openjdk@17/bin \
    /opt/homebrew/opt/sqlite/bin \
    /opt/homebrew/opt/rustup/bin \
    /Library/Frameworks/Python.framework/Versions/3.13/bin \
    $PNPM_HOME \
    $PNPM_HOME/bin \
    $PYENV_ROOT/bin
