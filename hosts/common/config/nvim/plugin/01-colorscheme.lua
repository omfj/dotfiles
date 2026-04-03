vim.pack.add({
	{ src = "https://github.com/wtfox/jellybeans.nvim" },
	{ src = "https://github.com/ellisonleao/gruvbox.nvim" },
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
