if command -q brew
    fish_add_path /opt/homebrew/sbin

    set -gx HOMEBREW_NO_ANALYTICS 1
end

