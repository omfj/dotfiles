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
	close_if_last_window = false,
	popup_border_style = "single",
	enable_git_status = true,
	enable_diagnostics = true,
	open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
	default_component_configs = {
		indent = {
			indent_size = 2,
			padding = 1,
			with_markers = true,
			indent_marker = "│",
			last_indent_marker = "└",
			highlight = "NeoTreeIndentMarker",
			with_expanders = true,
			expander_collapsed = "",
			expander_expanded = "",
			expander_highlight = "NeoTreeExpander",
		},
		icon = {
			folder_closed = "󰉋",
			folder_open = "󰉓",
			folder_empty = "󰉖",
			default = "󰈚",
			highlight = "NeoTreeFileIcon",
		},
		name = {
			use_git_status_colors = true,
			highlight = "NeoTreeFileName",
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
	window = {
		position = "left",
		width = 40,
		mapping_options = {
			noremap = true,
			nowait = true,
		},
		mappings = {
			["<space>"] = { "toggle_node", nowait = false },
			["<2-LeftMouse>"] = "open",
			["<cr>"] = "open",
			["<esc>"] = "cancel",
			["P"] = {
				"toggle_preview",
				config = { use_float = true },
			},
			["l"] = "focus_preview",
			["S"] = "open_split",
			["s"] = "open_vsplit",
			["t"] = "open_tabnew",
			["C"] = "close_node",
			["z"] = "close_all_nodes",
			["a"] = { "add", config = { show_path = "none" } },
			["A"] = "add_directory",
			["d"] = "delete",
			["r"] = "rename",
			["b"] = "rename_basename",
			["y"] = "copy_to_clipboard",
			["x"] = "cut_to_clipboard",
			["p"] = "paste_from_clipboard",
			["<C-r>"] = "clear_clipboard",
			["c"] = "copy",
			["m"] = "move",
			["q"] = "close_window",
			["R"] = "refresh",
			["?"] = "show_help",
		},
	},
	filesystem = {
		filtered_items = {
			visible = true,
			hide_dotfiles = false,
			hide_gitignored = true,
			hide_by_name = {},
			hide_by_pattern = {},
			always_show = {},
			never_show = { ".DS_Store", "thumbs.db" },
			never_show_by_pattern = {},
		},
		follow_current_file = {
			enabled = true,
			leave_dirs_open = false,
		},
		hijack_netrw_behavior = "open_default",
		use_libuv_file_watcher = true,
		window = {
			mappings = {
				["<bs>"] = "navigate_up",
				["."] = "toggle_gitignored",
				["H"] = "toggle_hidden",
				["/"] = "fuzzy_finder",
				["<c-x>"] = "clear_filter",
				["[g"] = "prev_git_modified",
				["]g"] = "next_git_modified",
			},
		},
	},
	buffers = {
		follow_current_file = { enabled = true, leave_dirs_open = false },
		group_empty_dirs = true,
	},
})

vim.keymap.set("n", "<leader>e", "<cmd>Neotree reveal toggle<cr>", { desc = "Toggle explorer (current file)" })

vim.keymap.set("n", "<leader>fo", "<cmd>Neotree toggle<cr>", { desc = "Toggle explorer (cwd)" })
