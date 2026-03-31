-- Load plugins
vim.loader.enable()
vim.g.start_time = vim.uv.hrtime()

-- Specific settings for Neovide
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
