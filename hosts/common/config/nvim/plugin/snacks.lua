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
						vim.version().major, vim.version().minor, vim.version().patch,
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
				{ icon = " ", key = "f", desc = "Find file", action = function() Snacks.picker.files({ hidden = true }) end },
				{ icon = " ", key = "r", desc = "Recent files", action = function() Snacks.picker.recent() end },
				{ icon = " ", key = "g", desc = "Find word", action = function() Snacks.picker.grep() end },
				{ icon = " ", key = "s", desc = "Restore Session", action = function() require("persistence").load() end },
				{ icon = " ", key = "S", desc = "Select Session", action = function() require("persistence").select() end },
				{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
			},
		},
	},
	lazygit = { enabled = true },
	scratch = { enabled = true },
	terminal = {
		enabled = true,
		win = { border = "single" },
	},
	notifier = { enabled = true },
	words = { enabled = true },
	bigfile = { enabled = true },
})

vim.keymap.set("n", "<leader>gg", function()
	Snacks.lazygit()
end, { desc = "LazyGit" })
vim.keymap.set("n", "<leader>ft", function()
	Snacks.terminal.toggle(nil, { win = { style = "float" } })
end, { desc = "Float Terminal" })
vim.keymap.set("n", "<leader>fT", function()
	Snacks.terminal.toggle(nil, { win = { position = "bottom" } })
end, { desc = "Horizontal Terminal" })
vim.keymap.set("n", "<c-/>", function()
	Snacks.terminal.toggle(nil, { win = { style = "float" } })
end, { desc = "Float Terminal" })
vim.keymap.set("n", "<c-_>", function()
	Snacks.terminal.toggle(nil, { win = { style = "float" } })
end, { desc = "which_key_ignore" })
vim.keymap.set("n", "<leader>.", function()
	Snacks.scratch()
end, { desc = "Scratch Buffer" })
