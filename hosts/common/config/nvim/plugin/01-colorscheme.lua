vim.pack.add({
	{ src = "https://github.com/wtfox/jellybeans.nvim" },
})

require("jellybeans").setup({
	transparent = true,
	plugins = {
		all = true,
		auto = true,
	},
})

vim.cmd.colorscheme("jellybeans")
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#222222" }) -- softer cursor line, to not interfere with ghost text
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#222222" }) -- softer color column, to match cursor line

vim.api.nvim_set_hl(0, "NonText", { fg = "#222222" }) -- softer whitespace characters
vim.api.nvim_set_hl(0, "MiniHipatternsNbsp", { bg = "#4a3a00" }) -- dark yellow bg on non-breaking spaces (opt+space)
--vim.api.nvim_set_hl(0, "SpecialKey", { fg = "#222222" })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#444444", bg = "NONE" })
vim.api.nvim_set_hl(0, "NoiceHoverNormal", { bg = "#141414" })

-- override some colors for better visibility. without these they are almost the same as the background
vim.api.nvim_set_hl(0, "SnacksPickerFile", { fg = "#e8e8d3" })
vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = "#888888" })
vim.api.nvim_set_hl(0, "SnacksPickerTotals", { fg = "#888888" })

vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = "#555555", italic = true }) -- a bit harder color so to not be invisible in the cursor line:w

-- neo-tree and line number backgrounds
vim.api.nvim_set_hl(0, "LineNr", { fg = "#555555", bg = "#151515" })
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#555555", bg = "#151515" })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#555555", bg = "#151515" })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#e8e8d3", bg = "#151515" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "#151515" })
vim.api.nvim_set_hl(0, "FoldColumn", { bg = "#151515" })

-- diff colors
vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#3a4a3a" })
vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#4a2a2a" })
vim.api.nvim_set_hl(0, "DiffChange", { bg = "#4a4a2a" })
vim.api.nvim_set_hl(0, "DiffText", { bg = "#4a4a2a", bold = true })
