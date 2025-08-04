# Where this file is located:
set -gx FISH_CONFIG $HOME/.config/fish/config.fish

set -g fish_greeting

if status is-interactive
    # Start vi-mode
    fish_vi_key_bindings
end
