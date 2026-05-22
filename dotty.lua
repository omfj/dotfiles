local hostname = dotty.hostname()

local link = dotty.link

-- Common
link("hosts/common/config/ghostty", "~/.config/ghostty")
link("hosts/common/config/helix", "~/.config/helix")
link("hosts/common/config/starship.toml", "~/.config/starship.toml")
link("hosts/common/vimrc", "~/.vimrc")
link("hosts/common/config/atuin", "~/.config/atuin")
link("hosts/common/config/lazydocker", "~/.config/lazydocker")
link("hosts/common/config/lazygit", "~/.config/lazygit")
link("hosts/common/config/cheat", "~/.config/cheat")
link("hosts/common/config/tmux", "~/.config/tmux")
link("hosts/common/config/nvim", "~/.config/nvim")

-- Shared between main computers
if hostname == "obook.local" or hostname == "oarch" then
	link("hosts/common/config/git", "~/.config/git")
end

-- Mac (obook)
if hostname == "obook.local" then
	link("hosts/obook/config/fish", "~/.config/fish")
	link("hosts/common/config/zed", "~/.config/zed")
	link("hosts/obook/zshrc", "~/.zshrc")
end

-- Arch (oarch)
if hostname == "oarch" then
	link("hosts/oarch/config/fish", "~/.config/fish")
	link("hosts/oarch/config/bspwm", "~/.config/bspwm")
	link("hosts/oarch/config/sxhkd", "~/.config/sxhkd")
	link("hosts/oarch/config/dunst", "~/.config/dunst")
	link("hosts/oarch/config/picom", "~/.config/picom")
	link("hosts/oarch/config/rofi", "~/.config/rofi")
	link("hosts/oarch/config/polybar", "~/.config/polybar")
	link("hosts/oarch/config/betterlockscreenrc", "~/.config/betterlockscreenrc")
	link("hosts/oarch/config/user-dirs.dirs", "~/.config/user-dirs.dirs")
	link("hosts/oarch/config/user-dirs.locale", "~/.config/user-dirs.locale")
	link("hosts/oarch/config/hypr", "~/.config/hypr")
end

-- obuntu
if dotty.file_exists("~/.obuntu") then
	link("hosts/obuntu/zshrc", "~/.zshrc")
end
