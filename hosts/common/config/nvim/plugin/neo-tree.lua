vim.pack.add({
	{
		src = "https://github.com/nvim-neo-tree/neo-tree.nvim",
		version = vim.version.range("3"),
	},
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

require("nvim-web-devicons").setup({
	default = true,
})

require("neo-tree").setup({
	popup_border_style = "single",
	open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
	default_component_configs = {
		indent = {
			with_expanders = true,
		},
		icon = {
			folder_closed = "󰉋",
			folder_open = "󰉓",
			folder_empty = "󰉖",
			default = "󰈚",
		},
		git_status = {
			symbols = {
				added = "",
				modified = "",
				deleted = "✖",
				untracked = "",
				ignored = "",
				unstaged = "󰄱",
				staged = "",
				conflict = "",
			},
		},
	},
	filesystem = {
		filtered_items = {
			visible = true,
			hide_dotfiles = false,
			never_show = { ".DS_Store", "thumbs.db" },
		},
		follow_current_file = { enabled = true },
		use_libuv_file_watcher = true,
		window = {
			mappings = {
				["."] = "toggle_gitignored",
			},
		},
	},
})

vim.keymap.set("n", "<leader>e", "<cmd>Neotree reveal toggle<cr>", { desc = "Toggle explorer (current file)" })

vim.keymap.set("n", "<leader>fo", "<cmd>Neotree toggle<cr>", { desc = "Toggle explorer (cwd)" })
