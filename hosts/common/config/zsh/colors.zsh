# ── Dark palette (Jellybeans)

COLORS_DARK_BG="#151515"
COLORS_DARK_FG="#e8e8d3"
COLORS_DARK_ACCENT="#8fbfdc"
COLORS_DARK_SECONDARY="#cf6a4c"
COLORS_DARK_ACCENT_FG="#1f1f1f"
COLORS_DARK_BORDER="#404040"
COLORS_DARK_MUTED="#888888"
COLORS_DARK_DIM="#b0b8c0"
COLORS_DARK_BRIGHT="#dddddd"
COLORS_DARK_SURFACE="#2a2a2a"

# ── Light palette (Jellybeans Light)

COLORS_LIGHT_BG="#eeeeee"
COLORS_LIGHT_FG="#252525"
COLORS_LIGHT_ACCENT="#234291"
COLORS_LIGHT_SECONDARY="#954d3b"
COLORS_LIGHT_ACCENT_FG="#eeeeee"
COLORS_LIGHT_BORDER="#c0c0c0"
COLORS_LIGHT_MUTED="#787878"
COLORS_LIGHT_DIM="#7a8490"
COLORS_LIGHT_BRIGHT="#252525"
COLORS_LIGHT_SURFACE="#e0dcd7"

function _colors_is_dark() {
    [[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]]
}

function apply-tmux-theme() {
    if _colors_is_dark; then
        local bg=$COLORS_DARK_BG fg=$COLORS_DARK_FG
        local accent=$COLORS_DARK_ACCENT secondary=$COLORS_DARK_SECONDARY
        local accent_fg=$COLORS_DARK_ACCENT_FG border=$COLORS_DARK_BORDER
        local muted=$COLORS_DARK_MUTED dim=$COLORS_DARK_DIM
        local bright=$COLORS_DARK_BRIGHT surface=$COLORS_DARK_SURFACE
    else
        local bg=$COLORS_LIGHT_BG fg=$COLORS_LIGHT_FG
        local accent=$COLORS_LIGHT_ACCENT secondary=$COLORS_LIGHT_SECONDARY
        local accent_fg=$COLORS_LIGHT_ACCENT_FG border=$COLORS_LIGHT_BORDER
        local muted=$COLORS_LIGHT_MUTED dim=$COLORS_LIGHT_DIM
        local bright=$COLORS_LIGHT_BRIGHT surface=$COLORS_LIGHT_SURFACE
    fi

    tmux set-option -gq mode-style "bg=${accent},fg=${accent_fg}"
    tmux set-option -gq status-bg "${bg}"
    tmux set-option -gq status-fg "${fg}"
    tmux set-option -gq status-right "#[fg=${secondary},bold]#(cd '#{pane_current_path}' && git rev-parse --show-toplevel 2>/dev/null | xargs -I{} basename {} | awk '{print \"  \" \$0 \" \"}')#[fg=${muted}] #S  #[fg=${bright}]%H:%M #[default]"
    tmux set-option -gq window-status-format "#[fg=${muted}]  #I #W "
    tmux set-option -gq window-status-current-format "#{?client_prefix,#[bg=${secondary} fg=${accent_fg}],#[bg=${accent} fg=${accent_fg}]} #I #[bg=${surface} fg=${dim}] #W "
    tmux set-option -gq pane-border-style "fg=${border}"
    tmux set-option -gq pane-active-border-style "fg=${muted}"
    tmux set-option -gq message-style "bg=${accent},fg=${accent_fg}"
    tmux set-option -gq message-command-style "bg=${accent},fg=${accent_fg}"
    tmux set-option -gq clock-mode-colour "${accent}"
    tmux set-option -gq window-status-activity-style "bg=${bg},fg=#e8a87c,bold"
}

if [[ -n "$TMUX" ]]; then
    apply-tmux-theme
fi
