if command -q zoxide; and not set -q DISABLE_ZOXIDE
    zoxide init --cmd cd fish | source
end