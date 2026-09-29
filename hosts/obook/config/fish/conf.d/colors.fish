set -gx COLORS_DARK_BG "#151515"
set -gx COLORS_DARK_FG "#e8e8d3"
set -gx COLORS_DARK_ACCENT "#8fbfdc"
set -gx COLORS_DARK_SECONDARY "#cf6a4c"
set -gx COLORS_DARK_ACCENT_FG "#1f1f1f"
set -gx COLORS_DARK_BORDER "#404040"
set -gx COLORS_DARK_MUTED "#888888"
set -gx COLORS_DARK_DIM "#b0b8c0"
set -gx COLORS_DARK_BRIGHT "#dddddd"
set -gx COLORS_DARK_SURFACE "#2a2a2a"
set -gx COLORS_LIGHT_BG "#eeeeee"
set -gx COLORS_LIGHT_FG "#252525"
set -gx COLORS_LIGHT_ACCENT "#234291"
set -gx COLORS_LIGHT_SECONDARY "#954d3b"
set -gx COLORS_LIGHT_ACCENT_FG "#eeeeee"
set -gx COLORS_LIGHT_BORDER "#c0c0c0"
set -gx COLORS_LIGHT_MUTED "#787878"
set -gx COLORS_LIGHT_DIM "#7a8490"
set -gx COLORS_LIGHT_BRIGHT "#252525"
set -gx COLORS_LIGHT_SURFACE "#e0dcd7"

set -l palette DARK
if command -q defaults
    if test "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" != Dark
        set palette LIGHT
    end
end
for key in BG FG ACCENT SECONDARY ACCENT_FG BORDER MUTED DIM BRIGHT SURFACE
    set -l variable COLORS_{$palette}_{$key}
    set -gx COLORS_{$key} $$variable
end

set -g fish_color_command blue --bold
set -g fish_color_error red --bold
set -g fish_color_param normal
