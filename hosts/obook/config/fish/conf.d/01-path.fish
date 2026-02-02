fish_add_path $HOME/.ghcup/bin # GHCup for Haskell 
fish_add_path $HOME/.cargo/bin # Rust
fish_add_path $HOME/.emacs.d/bin # Emacs
fish_add_path $HOME/.local/bin # User local binaries
fish_add_path $HOME/.deno/bin # Deno
fish_add_path $HOME/.atuin/bin/ # Atuin for shell history
fish_add_path $HOME/.composer/vendor/bin # PHP Composer
fish_add_path $HOME/go/bin # Go binaries
fish_add_path $HOME/.slack/bin # Slack CLI

fish_add_path $BUN_INSTALL/bin # Bun JavaScript runtime

fish_add_path /usr/local/bin
fish_add_path /usr/local/sbin

fish_add_path /usr/local/opt/openjdk/bin # OpenJDK

# Homebrew
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/opt/openjdk/bin
fish_add_path /opt/homebrew/opt/llvm/bin
fish_add_path /opt/homebrew/opt/postgresql@15/bin
fish_add_path /opt/homebrew/opt/openjdk@17/bin
fish_add_path /opt/homebrew/opt/sqlite/bin
fish_add_path /opt/homebrew/opt/rustup/bin

fish_add_path /Library/Developer/CommandLineTools/usr/bin # Xcode Command Line Tools
fish_add_path /Library/Frameworks/Python.framework/Versions/3.10/bin # Python 3.10

# Add PNPM to PATH if not already there
if not contains $PNPM_HOME $PATH
    fish_add_path $PNPM_HOME
end

# Add PYENV bin to PATH if directory exists
if test -d $PYENV_ROOT/bin
    fish_add_path $PYENV_ROOT/bin
end
