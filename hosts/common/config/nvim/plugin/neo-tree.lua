vim.pack.add({
	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

require("neo-tree").setup({
	close_if_last_window = true,
	diagnostics = {
		enabled = true,
		show_on_dirs = true,
		severity = {
			min = vim.diagnostic.severity.WARN,
			max = vim.diagnostic.severity.ERROR,
		},
	},
	default_component_configs = {
		icon = {
			folder_closed = "▸",
			folder_open = "▾",
			folder_empty = "▸",
			default = "·",
		},
		git_status = {
			symbols = {
				added = "+",
				modified = "~",
				deleted = "-",
				renamed = "→",
				untracked = "?",
				ignored = "◌",
				unstaged = "✗",
				staged = "✓",
				conflict = "!",
			},
		},
	},
	filesystem = {
		renderers = {
			directory = {
				{ "indent" },
				{ "icon" },
				{ "current_filter" },
				{ "name", use_git_status_colors = true },
				{ "clipboard" },
				{ "diagnostics", errors_only = true },
				{ "git_status" },
			},
			file = {
				{ "indent" },
				{ "name", use_git_status_colors = true },
				{ "clipboard" },
				{ "bufnr" },
				{ "modified", zindex = 20, align = "right" },
				{ "diagnostics" },
				{ "git_status", zindex = 10, align = "right" },
			},
		},
		follow_current_file = {
			enabled = true,
		},
		use_libuv_file_watcher = true,
		filtered_items = {
			visible = true,
			hide_dotfiles = false,
			hide_gitignored = false,
			never_show = {
				".DS_Store",
				".git",
			},
		},
	},
	window = {
		width = 40,
		position = "left",
		mappings = {},
		title = "",
	},
	event_handlers = {
		{
			event = "neo_tree_window_after_open",
			handler = function()
				vim.opt_local.number = false
				vim.opt_local.relativenumber = false
			end,
		},
	},
})

vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle explorer" })
