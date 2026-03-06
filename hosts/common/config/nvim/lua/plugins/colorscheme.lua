return {
	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("gruvbox").setup({
				terminal_colors = true, -- add neovim terminal colors
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
				invert_tabline = false,
				inverse = true, -- invert background for search, diffs, statuslines and errors
				contrast = "hard", -- can be "hard", "soft" or empty string
				palette_overrides = {},
				overrides = {},
				dim_inactive = false,
				transparent_mode = false,
			})
		end,
	},
	{
		"Mofiqul/vscode.nvim",
		lazy = true,
		priority = 1000,
		config = function()
			require("vscode").setup({
				italic_comments = true,
			})
		end,
	},
	{
		"wtfox/jellybeans.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			transparent = true,
		},
	},
	{
		"roerohan/orng.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("orng").setup({
				variant = "dark", -- "dark" or "light"
				transparent = false,
				italic_comment = true,
			})
			-- vim.cmd("colorscheme orng")
		end,
	},
	{ "catppuccin/nvim", name = "catppuccin", lazy = true, priority = 1000 },
	{ "folke/tokyonight.nvim", lazy = true, priority = 1000 },
	{ "rebelot/kanagawa.nvim", lazy = true, priority = 1000 },
	{ "EdenEast/nightfox.nvim", lazy = true, priority = 1000 },
	{ "navarasu/onedark.nvim", lazy = true, priority = 1000 },
	{ "sainnhe/everforest", lazy = true, priority = 1000 },
	{ "rose-pine/neovim", name = "rose-pine", lazy = true, priority = 1000 },
	{ "sainnhe/gruvbox-material", lazy = true, priority = 1000 },
	{ "bluz71/vim-moonfly-colors", name = "moonfly", lazy = true, priority = 1000 },
	{ "Mofiqul/dracula.nvim", lazy = true, priority = 1000 },
	{ "projekt0n/github-nvim-theme", lazy = true, priority = 1000 },
	{ "NLKNguyen/papercolor-theme", lazy = true, priority = 1000 },
	{ "sainnhe/edge", lazy = true, priority = 1000 },
}
