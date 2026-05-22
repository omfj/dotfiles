local hostname = dotty.hostname()

local link = dotty.link

local function common(path)
	return "hosts/common/" .. path
end

local function obook(path)
	return "hosts/obook/" .. path
end

local function obuntu(path)
	return "hosts/obuntu/" .. path
end

local function oarch(path)
	return "hosts/oarch/" .. path
end

local function config(path)
	return "~/.config/" .. path
end

-- Common
link(common("config/ghostty"), config("ghostty"))
link(common("config/helix"), config("helix"))
link(common("config/starship.toml"), config("starship.toml"))
link(common("vimrc"), "~/.vimrc")
link(common("config/atuin"), config("atuin"))
link(common("config/lazydocker"), config("lazydocker"))
link(common("config/lazygit"), config("lazygit"))
link(common("config/cheat"), config("cheat"))
link(common("config/tmux"), config("tmux"))
link(common("config/nvim"), config("nvim"))

-- Shared between main computers
if hostname == "obook.local" or hostname == "oarch" then
	link(common("config/git"), config("git"))
end

-- Mac (obook)
if hostname == "obook.local" then
	link(obook("config/fish"), config("fish"))
	link(common("config/zed"), config("zed"))
	link(obook("zshrc"), "~/.zshrc")
end

-- Arch (oarch)
if hostname == "oarch" then
	link(oarch("config/fish"), config("fish"))
	link(oarch("config/bspwm"), config("bspwm"))
	link(oarch("config/sxhkd"), config("sxhkd"))
	link(oarch("config/dunst"), config("dunst"))
	link(oarch("config/picom"), config("picom"))
	link(oarch("config/rofi"), config("rofi"))
	link(oarch("config/polybar"), config("polybar"))
	link(oarch("config/betterlockscreenrc"), config("betterlockscreenrc"))
	link(oarch("config/user-dirs.dirs"), config("user-dirs.dirs"))
	link(oarch("config/user-dirs.locale"), config("user-dirs.locale"))
	link(oarch("config/hypr"), config("hypr"))
end

-- obuntu
if dotty.file_exists("~/.obuntu") then
	link(obuntu("zshrc"), "~/.zshrc")
end
