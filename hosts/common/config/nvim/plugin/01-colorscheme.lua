vim.pack.add({
	{ src = "https://github.com/wtfox/jellybeans.nvim" },
	{ src = "https://github.com/f-person/auto-dark-mode.nvim" },
})

require("jellybeans").setup({
	transparent = true,
	plugins = {
		all = true,
		auto = true,
	},
})

-- mini.diff sign column and overlay colors
local function apply_minidiff_highlights()
	vim.api.nvim_set_hl(0, "MiniDiffSignAdd", { fg = "#a9dd9d" })
	vim.api.nvim_set_hl(0, "MiniDiffSignChange", { fg = "#f0922b" })
	vim.api.nvim_set_hl(0, "MiniDiffSignDelete", { fg = "#e03030" })
	vim.api.nvim_set_hl(0, "MiniDiffOverAdd", { bg = "#3a4a3a" })
	vim.api.nvim_set_hl(0, "MiniDiffOverChange", { bg = "#4a4a2a" })
	vim.api.nvim_set_hl(0, "MiniDiffOverDelete", { bg = "#4a2a2a" })
	vim.api.nvim_set_hl(0, "MiniDiffOverContext", { bg = "#2a2a2a" })
end

local function apply_blink_highlights()
	if vim.o.background == "light" then
		vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "#eeeeee" })
		vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = "#e0dcd7" })
		vim.api.nvim_set_hl(0, "BlinkCmpLabelDetail", { bg = "#eeeeee", fg = "#787878", italic = true })
		vim.api.nvim_set_hl(0, "BlinkCmpLabelDescription", { bg = "#eeeeee", fg = "#787878", italic = true })
		vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = "#eeeeee" })
		vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { bg = "#eeeeee" })
		vim.api.nvim_set_hl(0, "BlinkCmpDocSeparator", { bg = "#eeeeee", fg = "#c0c0c0" })
		vim.api.nvim_set_hl(0, "BlinkCmpScrollBarThumb", { bg = "#c0c0c0" })
		vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { fg = "#876820", bold = true })
	else
		vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "#151515" })
		vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = "#222222" })
		vim.api.nvim_set_hl(0, "BlinkCmpLabelDetail", { bg = "#151515", fg = "#555555", italic = true })
		vim.api.nvim_set_hl(0, "BlinkCmpLabelDescription", { bg = "#151515", fg = "#555555", italic = true })
		vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = "#151515" })
		vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { bg = "#151515" })
		vim.api.nvim_set_hl(0, "BlinkCmpDocSeparator", { bg = "#151515", fg = "#444444" })
		vim.api.nvim_set_hl(0, "BlinkCmpScrollBarThumb", { bg = "#444444" })
		vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { fg = "#fad07a", bold = true })
	end
end

local function apply_dark()
	vim.cmd.colorscheme("jellybeans-muted")
	vim.api.nvim_set_hl(0, "CursorLine", { bg = "#222222" }) -- softer cursor line, to not interfere with ghost text
	vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#222222" }) -- softer color column, to match cursor line
	vim.api.nvim_set_hl(0, "NonText", { fg = "#222222" }) -- softer whitespace characters
	vim.api.nvim_set_hl(0, "MiniHipatternsNbsp", { bg = "#4a3a00" }) -- dark yellow bg on non-breaking spaces (opt+space)
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#151515" })
	vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#444444", bg = "NONE" })
	vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = "#555555", italic = true }) -- a bit harder color so to not be invisible in the cursor line
	vim.api.nvim_set_hl(0, "LspInlayHint", { link = "GitSignsCurrentLineBlame" }) -- match blame text; default link to NonText is too dark
	vim.api.nvim_set_hl(0, "LspCodeLens", { fg = "#555555" })
	-- diff colors
	vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#3a4a3a" })
	vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#4a2a2a" })
	vim.api.nvim_set_hl(0, "DiffChange", { bg = "#4a4a2a" })
	vim.api.nvim_set_hl(0, "DiffText", { bg = "#4a4a2a", bold = true })
	apply_blink_highlights()
	apply_minidiff_highlights()
end

local function apply_light()
	vim.cmd.colorscheme("jellybeans-light")
	vim.api.nvim_set_hl(0, "LspInlayHint", { link = "GitSignsCurrentLineBlame" }) -- match blame text
	vim.api.nvim_set_hl(0, "LspCodeLens", { fg = "#555555" })
	apply_blink_highlights()
end

require("auto-dark-mode").setup({
	update_interval = 1000,
	set_dark_mode = apply_dark,
	set_light_mode = apply_light,
})
