return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = "Telescope",
		keys = {
			{
				"<leader>,",
				"<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
				desc = "Switch Buffer",
			},
			{
				"<leader>/",
				"<cmd>Telescope live_grep<cr>",
				desc = "Grep (root dir)",
			},
			{
				"<leader>:",
				"<cmd>Telescope command_history<cr>",
				desc = "Command History",
			},
			{
				"<leader><space>",
				"<cmd>Telescope find_files<cr>",
				desc = "Find Files (root dir)",
			},
			-- find
			{ "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
			{
				"<leader>fc",
				"<cmd>Telescope find_files cwd=false<cr>",
				desc = "Find Config File",
			},
			{
				"<leader>ff",
				"<cmd>Telescope find_files<cr>",
				desc = "Find Files (root dir)",
			},
			{
				"<leader>fF",
				"<cmd>Telescope find_files cwd=false<cr>",
				desc = "Find Files (cwd)",
			},
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
			{ "<leader>fR", "<cmd>Telescope oldfiles cwd_only=true<cr>", desc = "Recent (cwd)" },
			-- git
			{ "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
			{ "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
			-- search
			{ '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
			{
				"<leader>sa",
				"<cmd>Telescope autocommands<cr>",
				desc = "Auto Commands",
			},
			{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
			{
				"<leader>sc",
				"<cmd>Telescope command_history<cr>",
				desc = "Command History",
			},
			{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
			{
				"<leader>sd",
				"<cmd>Telescope diagnostics bufnr=0<cr>",
				desc = "Document diagnostics",
			},
			{
				"<leader>sD",
				"<cmd>Telescope diagnostics<cr>",
				desc = "Workspace diagnostics",
			},
			{
				"<leader>sg",
				"<cmd>Telescope live_grep<cr>",
				desc = "Grep (root dir)",
			},
			{ "<leader>sG", "<cmd>Telescope live_grep cwd=false<cr>", desc = "Grep (cwd)" },
			{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
			{
				"<leader>sH",
				"<cmd>Telescope highlights<cr>",
				desc = "Search Highlight Groups",
			},
			{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
			{ "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
			{ "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
			{ "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
			{ "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
			{
				"<leader>sw",
				"<cmd>Telescope grep_string word_match=-w<cr>",
				desc = "Word (root dir)",
			},
			{ "<leader>sW", "<cmd>Telescope grep_string cwd=false word_match=-w<cr>", desc = "Word (cwd)" },
			{
				"<leader>sw",
				"<cmd>Telescope grep_string<cr>",
				mode = "v",
				desc = "Selection (root dir)",
			},
			{
				"<leader>sW",
				"<cmd>Telescope grep_string cwd=false<cr>",
				mode = "v",
				desc = "Selection (cwd)",
			},
			{
				"<leader>uC",
				"<cmd>Telescope colorscheme enable_preview=true<cr>",
				desc = "Colorscheme with preview",
			},
		},
		opts = function()
			local actions = require("telescope.actions")

			return {
				defaults = {
					prompt_prefix = " ",
					selection_caret = ">",
					get_selection_window = function()
						local wins = vim.api.nvim_list_wins()
						table.insert(wins, 1, vim.api.nvim_get_current_win())
						for _, win in ipairs(wins) do
							local buf = vim.api.nvim_win_get_buf(win)
							if vim.bo[buf].buftype == "" then
								return win
							end
						end
						return 0
					end,
					mappings = {
						n = {
							["q"] = actions.close,
						},
					},
				},
			}
		end,
	},
}

