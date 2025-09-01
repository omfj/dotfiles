if not set -q ZELLIJ
    if not zellij list-sessions 2>/dev/null | grep -q "base"
        zellij -s base -d
    end
    zellij --layout ~/.config/zellij/layouts/default.kdl attach base
end
