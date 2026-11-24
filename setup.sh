#!/usr/bin/env bash

set -euo pipefail

dry_run=false

usage() {
    printf 'Usage: %s [--dry-run|-n]\n' "${0##*/}"
}

while (($# > 0)); do
    case "$1" in
    --dry-run | -n)
        dry_run=true
        ;;
    --help | -h)
        usage
        exit 0
        ;;
    *)
        usage >&2
        exit 1
        ;;
    esac
    shift
done

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
common="$repo_root/hosts/common"
obook="$repo_root/hosts/obook"
oarch="$repo_root/hosts/oarch"
conf="$HOME/.config"
host="$(hostname 2>/dev/null || hostnamectl --static 2>/dev/null || uname -n 2>/dev/null || echo unknown)"

run() {
    if [[ "$dry_run" == true ]]; then
        printf 'Would run:'
        printf ' %q' "$@"
        printf '\n'
    else
        "$@"
    fi
}

link() {
    local source="$1"
    local target="$2"

    [[ -e "$source" ]] || {
        printf 'Missing source: %s\n' "$source" >&2
        return 1
    }

    local target_dir
    target_dir="$(dirname -- "$target")"
    if [[ ! -d "$target_dir" ]]; then
        run mkdir -p -- "$target_dir"
    fi

    if [[ -L "$target" ]]; then
        run rm -- "$target"
    elif [[ -e "$target" ]]; then
        printf 'Refusing to replace non-symlink target: %s\n' "$target" >&2
        return 1
    fi

    run ln -s -- "$source" "$target"
}

host_is() {
    [[ "$host" == "$1" ]]
}

file_exists() {
    [[ -e "$1" ]]
}

# Common
link "$common/config/helix" "$conf/helix"
link "$common/config/lazygit" "$conf/lazygit"
link "$common/config/nvim" "$conf/nvim"
link "$common/config/lsd" "$conf/lsd"
link "$common/config/jj" "$conf/jj"
link "$common/config/tmux" "$conf/tmux"
link "$common/config/zsh" "$conf/zsh"
link "$common/config/zsh-patina" "$conf/zsh-patina"
link "$common/config/starship.toml" "$conf/starship.toml"

# Mac (obook)
if host_is "MacBookPro.lan"; then
    link "$common/config/rex" "$conf/rex"
    link "$common/config/atuin" "$conf/atuin"
    link "$common/config/lazydocker" "$conf/lazydocker"
    link "$common/config/cheat" "$conf/cheat"
    link "$common/config/ghostty" "$conf/ghostty"
    link "$common/vimrc" "$HOME/.vimrc"
    link "$common/config/git" "$conf/git"
    link "$common/config/alacritty.toml" "$conf/alacritty.toml"
    link "$obook/config/nushell/config.nu" "$conf/nushell/config.nu"
    link "$obook/config/nushell/env.nu" "$conf/nushell/env.nu"
    # Nushell uses the macOS default when XDG_CONFIG_HOME is not inherited.
    link "$obook/config/nushell/config.nu" "$HOME/Library/Application Support/nushell/config.nu"
    link "$obook/config/nushell/env.nu" "$HOME/Library/Application Support/nushell/env.nu"
    link "$obook/config/fish" "$conf/fish"
    link "$common/config/zed" "$conf/zed"
    link "$obook/zshrc" "$HOME/.zshrc"
    link "$obook/config/tabbee" "$conf/tabbee"
fi

# Arch (oarch)
if host_is "oarch" || host_is "ofedora"; then
    link "$oarch/config/fish" "$conf/fish"
    # currently used as a home server, so no need for DE or WM configs
    # link "$oarch/config/bspwm" "$conf/bspwm"
    # link "$oarch/config/sxhkd" "$conf/sxhkd"
    # link "$oarch/config/dunst" "$conf/dunst"
    # link "$oarch/config/picom" "$conf/picom"
    # link "$oarch/config/rofi" "$conf/rofi"
    # link "$oarch/config/polybar" "$conf/polybar"
    # link "$oarch/config/betterlockscreenrc" "$conf/betterlockscreenrc"
    # link "$oarch/config/hypr" "$conf/hypr"
    link "$oarch/config/user-dirs.dirs" "$conf/user-dirs.dirs"
    link "$oarch/config/user-dirs.locale" "$conf/user-dirs.locale"
fi
