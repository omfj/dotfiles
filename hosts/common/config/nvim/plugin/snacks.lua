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
