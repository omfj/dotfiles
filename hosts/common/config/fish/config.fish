# Where this file is located:
set -gx FISH_CONFIG $HOME/.config/fish/config.fish

set -g fish_greeting

if status is-interactive
    # ...
end

if test "$USER" = "ojohnsen"
    fish_add_path /home/ojohnsen/.opencode/bin
end

