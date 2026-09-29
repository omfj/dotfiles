if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv fish | source
    set -gx HOMEBREW_NO_ANALYTICS 1
end
