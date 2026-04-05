vim.pack.add({
	{ src = "https://github.com/folke/snacks.nvim" },
})

require("snacks").setup({
	input = { enabled = true },
	picker = {
		enabled = true,
		layout = {
			preset = "default",
			layout = {
				width = 0.85,
				height = 0.85,
			},
		},
	},
	dashboard = {
		enabled = true,
		-- Override sections to avoid the default `startup` section which requires lazy.nvim
		sections = {
			{ section = "header" },
			{ section = "keys", gap = 1, padding = 1 },
			{
				text = {
					string.format(
						"  nvim %d.%d.%d   %.0fms",
						vim.version().major,
						vim.version().minor,
						vim.version().patch,
						(vim.uv.hrtime() - vim.g.start_time) / 1e6
					),
					align = "center",
					hl = "SnacksDashboardFooter",
				},
				padding = 1,
			},
		},
		preset = {
			keys = {
				{ icon = " ", key = "e", desc = "New file", action = ":ene | startinsert" },
				{
					icon = " ",
					key = "f",
					desc = "Find file",
					action = function()
						Snacks.picker.files({ hidden = true })
					end,
				},
				{
					icon = " ",
					key = "r",
					desc = "Recent files",
					action = function()
						Snacks.picker.recent()
					end,
				},
				{
					icon = " ",
					key = "g",
					desc = "Find word",
					action = function()
						Snacks.picker.grep()
					end,
				},
				{
					icon = " ",
					key = "s",
					desc = "Restore Session",
					action = function()
						require("mini.sessions").read()
					end,
				},
				{
					icon = " ",
					key = "S",
					desc = "Select Session",
					action = function()
						require("mini.sessions").select()
					end,
				},
				{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
			},
		},
	},
	lazygit = { enabled = true },
	scratch = { enabled = true },
	terminal = { enabled = true, win = { border = "single" } },
	notifier = { enabled = true },
	words = { enabled = true },
	bigfile = { enabled = true },
})

-- stylua: ignore start

vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "LazyGit" })
vim.keymap.set("n", "<leader>ft", function() Snacks.terminal.toggle(nil, { win = { style = "float" } }) end, { desc = "Float Terminal" })
vim.keymap.set("n", "<leader>fT", function() Snacks.terminal.toggle(nil, { win = { position = "bottom" } }) end, { desc = "Horizontal Terminal" })
vim.keymap.set("n", "<c-/>", function() Snacks.terminal.toggle(nil, { win = { style = "float" } }) end, { desc = "Float Terminal" })
vim.keymap.set("n", "<c-_>", function() Snacks.terminal.toggle(nil, { win = { style = "float" } }) end, { desc = "which_key_ignore" })
vim.keymap.set("n", "<leader>.", function() Snacks.scratch() end, { desc = "Scratch Buffer" })

-- telescope like

vim.keymap.set("n", "<leader>,", function() Snacks.picker.buffers() end, { desc = "Switch Buffer" })
vim.keymap.set("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep" })
vim.keymap.set("n", "<leader>:", function() require("noice").cmd("history") end, { desc = "Command History" })
vim.keymap.set("n", "<leader><space>", function() Snacks.picker.files({ hidden = true }) end, { desc = "Find Files" })

-- find
vim.keymap.set("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find Config File" })
vim.keymap.set("n", "<leader>fF", function() Snacks.picker.files({ cwd = vim.fn.getcwd() }) end, { desc = "Find Files (cwd)" })
vim.keymap.set("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent" })
vim.keymap.set("n", "<leader>fR", function() Snacks.picker.recent({ filter = { cwd = true } }) end, { desc = "Recent (cwd)" })

-- git
vim.keymap.set("n", "<leader>gc", function() Snacks.picker.git_log() end, { desc = "commits" })
vim.keymap.set("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "status" })

-- search
vim.keymap.set("n", '<leader>s"', function() Snacks.picker.registers() end, { desc = "Registers" })
vim.keymap.set("n", "<leader>sa", function() Snacks.picker.autocmds() end, { desc = "Auto Commands" })
vim.keymap.set("n", "<leader>sb", function() Snacks.picker.lines() end, { desc = "Buffer" })
vim.keymap.set("n", "<leader>sc", function() require("noice").cmd("history") end, { desc = "Command History" })
vim.keymap.set("n", "<leader>sC", function() Snacks.picker.commands() end, { desc = "Commands" })
vim.keymap.set("n", "<leader>sd", function() Snacks.picker.diagnostics({ buf = 0 }) end, { desc = "Document Diagnostics" })
vim.keymap.set("n", "<leader>sD", function() Snacks.picker.diagnostics() end, { desc = "Workspace Diagnostics" })
vim.keymap.set("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Grep (root dir)" })
vim.keymap.set("n", "<leader>sG", function() Snacks.picker.grep({ cwd = vim.fn.getcwd() }) end, { desc = "Grep (cwd)" })
vim.keymap.set("n", "<leader>sf", function() Snacks.picker.grep({ cwd = vim.fn.getcwd() }) end, { desc = "Grep current folder" })
vim.keymap.set("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Help Pages" })
vim.keymap.set("n", "<leader>sH", function() Snacks.picker.highlights() end, { desc = "Search Highlight Groups" })
vim.keymap.set("n", "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Key Maps" })
vim.keymap.set("n", "<leader>sM", function() Snacks.picker.man() end, { desc = "Man Pages" })
vim.keymap.set("n", "<leader>sm", function() Snacks.picker.marks() end, { desc = "Jump to Mark" })
vim.keymap.set("n", "<leader>so", function() Snacks.picker.vim_options() end, { desc = "Options" })
vim.keymap.set("n", "<leader>sR", function() Snacks.picker.resume() end, { desc = "Resume" })
vim.keymap.set("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, { desc = "Symbols" })
vim.keymap.set("n", "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Word (root dir)" })
vim.keymap.set("n", "<leader>sW", function() Snacks.picker.grep_word({ cwd = vim.fn.getcwd() }) end, { desc = "Word (cwd)" })
vim.keymap.set("v", "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Selection (root dir)" })
vim.keymap.set("v", "<leader>sW", function() Snacks.picker.grep_word({ cwd = vim.fn.getcwd() }) end, { desc = "Selection (cwd)" })
vim.keymap.set("n", "<leader>uC", function() Snacks.picker.colorschemes() end, { desc = "Colorscheme with preview" })

-- stylua: ignore end
