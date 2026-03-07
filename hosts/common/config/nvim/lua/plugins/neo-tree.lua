return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	keys = {
		-- Toggle Neo-tree
		{ "<leader>o", "<cmd>Neotree toggle<cr>", desc = "Toggle explorer" },
		-- Jump between Neo-tree and the last active buffer
		{
			"<leader>e",
			function()
				if vim.bo.filetype == "neo-tree" then
					vim.cmd("wincmd p")
				else
					vim.cmd("Neotree focus")
				end
			end,
			desc = "Toggle explorer focus",
		},
	},
	lazy = false,
	-- Opens Neo-tree when entering a directory or opening Neovim without a file
	init = function()
		vim.api.nvim_create_autocmd("BufEnter", {
			callback = function()
				-- Don't open Neo-tree if the buffer is a special type (like alpha) or if it's already a file
				if vim.bo.buftype == "" and vim.bo.filetype ~= "alpha" and vim.bo.filetype ~= "" then
					vim.cmd("Neotree show")
					return true -- removes the autocmd after first trigger
				end
			end,
		})
	end,
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
				width = 35,
				position = "left",
			},
		})
	end,
}
