# Jellybeans Dark

export COLORS_DARK_BG="#151515"
export COLORS_DARK_FG="#e8e8d3"
export COLORS_DARK_ACCENT="#8fbfdc"
export COLORS_DARK_SECONDARY="#cf6a4c"
export COLORS_DARK_ACCENT_FG="#1f1f1f"
export COLORS_DARK_BORDER="#404040"
export COLORS_DARK_MUTED="#888888"
export COLORS_DARK_DIM="#b0b8c0"
export COLORS_DARK_BRIGHT="#dddddd"
export COLORS_DARK_SURFACE="#2a2a2a"

# Jellybeans Light

export COLORS_LIGHT_BG="#eeeeee"
export COLORS_LIGHT_FG="#252525"
export COLORS_LIGHT_ACCENT="#234291"
export COLORS_LIGHT_SECONDARY="#954d3b"
export COLORS_LIGHT_ACCENT_FG="#eeeeee"
export COLORS_LIGHT_BORDER="#c0c0c0"
export COLORS_LIGHT_MUTED="#787878"
export COLORS_LIGHT_DIM="#7a8490"
export COLORS_LIGHT_BRIGHT="#252525"
export COLORS_LIGHT_SURFACE="#e0dcd7"

() {
    local palette=DARK key variable
    if command -v defaults >/dev/null 2>&1 &&
        [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" != Dark ]]; then
        palette=LIGHT
    fi

    for key in BG FG ACCENT SECONDARY ACCENT_FG BORDER MUTED DIM BRIGHT SURFACE; do
        variable="COLORS_${palette}_${key}"
        export "COLORS_${key}=${(P)variable}"
    done
}
