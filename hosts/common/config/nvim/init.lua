-- fingers find the keys
-- plugins bloom in the dark
-- the buffer breathes on

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- globals
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.colorcolumn = "100"

-- Enable list mode immediately to show whitespace
vim.opt.list = true
vim.opt.listchars = {
	tab = "➙ ",
	trail = "␣",
	extends = "⟩",
	precedes = "⟨",
	nbsp = "·",
	eol = "¬",
	lead = "·",
}

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	checker = { enabled = true },
	ui = { border = "rounded" },
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})

if vim.g.neovide then
	vim.api.nvim_set_hl(0, "Normal", { bg = "#0a0a0a" })
	vim.o.guifont = "BlexMono Nerd Font:h14"
	vim.g.neovide_padding_top = 16
	vim.g.neovide_padding_bottom = 16
	vim.g.neovide_padding_left = 16
	vim.g.neovide_padding_right = 16
end

require("config.options")
require("config.keymaps")
require("config.autocmds")
