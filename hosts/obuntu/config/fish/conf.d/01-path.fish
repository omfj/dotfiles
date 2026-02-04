fish_add_path $HOME/.ghcup/bin # GHCup for Haskell
fish_add_path $HOME/.cargo/bin # Rust
fish_add_path $HOME/.local/bin # User local binaries
fish_add_path $HOME/.deno/bin # Deno
fish_add_path $HOME/.atuin/bin/ # Atuin for shell history
fish_add_path $HOME/go/bin # Go binaries

fish_add_path $BUN_INSTALL/bin # Bun JavaScript runtime

fish_add_path /usr/local/bin

# Add PNPM to PATH if not already there
if not contains $PNPM_HOME $PATH
    fish_add_path $PNPM_HOME
end
