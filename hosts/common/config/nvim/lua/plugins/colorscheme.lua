return {
	{
		"wtfox/jellybeans.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("jellybeans").setup({
				transparent = true,
			})
			vim.cmd.colorscheme("jellybeans")
			vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#222222" })
			vim.api.nvim_set_hl(0, "CursorLine", { bg = "#222222" })
			vim.api.nvim_set_hl(0, "NonText", { fg = "#222222" })
			vim.api.nvim_set_hl(0, "SpecialKey", { fg = "#222222" })
			-- Snacks picker: make file names and directory paths visible
			vim.api.nvim_set_hl(0, "SnacksPickerFile", { fg = "#e8e8d3" })
			vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = "#888888" })
		end,
	},
	{
		"ellisonleao/gruvbox.nvim",
		event = "VeryLazy",
		config = function()
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
		end,
	},
	{ "Mofiqul/vscode.nvim", event = "VeryLazy" },
	{ "catppuccin/nvim", name = "catppuccin", event = "VeryLazy" },
	{ "folke/tokyonight.nvim", event = "VeryLazy" },
	{ "rebelot/kanagawa.nvim", event = "VeryLazy" },
	{ "EdenEast/nightfox.nvim", event = "VeryLazy" },
	{ "navarasu/onedark.nvim", event = "VeryLazy" },
	{ "sainnhe/everforest", event = "VeryLazy" },
	{ "rose-pine/neovim", name = "rose-pine", event = "VeryLazy" },
	{ "sainnhe/gruvbox-material", event = "VeryLazy" },
	{ "bluz71/vim-moonfly-colors", name = "moonfly", event = "VeryLazy" },
	{ "Mofiqul/dracula.nvim", event = "VeryLazy" },
	{ "projekt0n/github-nvim-theme", event = "VeryLazy" },
	{ "NLKNguyen/papercolor-theme", event = "VeryLazy" },
	{ "sainnhe/edge", event = "VeryLazy" },
}
