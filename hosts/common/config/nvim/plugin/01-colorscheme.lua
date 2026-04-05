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
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#444444", bg = "NONE" })
vim.api.nvim_set_hl(0, "SnacksPickerFile", { fg = "#e8e8d3" })
vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = "#888888" })
vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = "#555555", italic = true })
-- Native diff view colors (matches MiniDiff palette from diffgit.lua)
vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#3a4a3a" })
vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#4a2a2a" })
vim.api.nvim_set_hl(0, "DiffChange", { bg = "#4a4a2a" })
vim.api.nvim_set_hl(0, "DiffText", { bg = "#4a4a2a", bold = true })

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
