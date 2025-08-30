return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Explorer" },
	},
	lazy = false,
	config = function()
		require("neo-tree").setup({
			close_if_last_window = true,
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
					}
				},
			},
			filesystem = {
				follow_current_file = {
					enabled = true,
				},
				use_libuv_file_watcher = true,
			},
			window = {
				width = 30,
			},
		})
	end,
}
