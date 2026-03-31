vim.pack.add({
	{ src = "https://github.com/wtfox/jellybeans.nvim" },
	{ src = "https://github.com/ellisonleao/gruvbox.nvim" },
	{ src = "https://github.com/Mofiqul/vscode.nvim" },
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
	{ src = "https://github.com/folke/tokyonight.nvim" },
	{ src = "https://github.com/rebelot/kanagawa.nvim" },
	{ src = "https://github.com/EdenEast/nightfox.nvim" },
	{ src = "https://github.com/navarasu/onedark.nvim" },
	{ src = "https://github.com/sainnhe/everforest" },
	{ src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
	{ src = "https://github.com/sainnhe/gruvbox-material" },
	{ src = "https://github.com/bluz71/vim-moonfly-colors", name = "moonfly" },
	{ src = "https://github.com/Mofiqul/dracula.nvim" },
	{ src = "https://github.com/projekt0n/github-nvim-theme" },
	{ src = "https://github.com/NLKNguyen/papercolor-theme" },
	{ src = "https://github.com/sainnhe/edge" },
})

require("jellybeans").setup({ transparent = true })
vim.cmd.colorscheme("jellybeans")
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#222222" })
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#222222" })
vim.api.nvim_set_hl(0, "NonText", { fg = "#222222" })
vim.api.nvim_set_hl(0, "SpecialKey", { fg = "#222222" })
vim.api.nvim_set_hl(0, "SnacksPickerFile", { fg = "#e8e8d3" })
vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = "#888888" })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#444444", bg = "NONE" })

require("gruvbox").setup({
	terminal_colors = true,
	undercurl = true,
	underline = true,
	bold = true,
	italic = {
		strings = true,
		emphasis = true,
		comments = true,
		operators = false,
		folds = true,
	},
	strikethrough = true,
	invert_selection = false,
	invert_signs = false,
	inverse = true,
	contrast = "hard",
	palette_overrides = {},
	overrides = {},
	dim_inactive = false,
	transparent_mode = false,
})
