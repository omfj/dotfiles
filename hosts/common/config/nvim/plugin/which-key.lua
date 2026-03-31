vim.pack.add({
	{ src = "https://github.com/folke/which-key.nvim" },
})

local wk = require("which-key")
wk.setup({ plugins = { spelling = true } })
wk.add({
	{ "<leader>b", group = "Buffers" },
	{ "<leader>c", group = "Code" },
	{ "<leader>f", group = "Files" },
	{ "<leader>g", group = "Git" },
	{ "<leader>h", group = "Git Hunks" },
	{ "<leader>q", group = "Sessions" },
	{ "<leader>s", group = "Search" },
	{ "<leader>t", group = "Toggle" },
	{ "<leader>u", group = "UI" },
	{ "<leader>w", group = "Windows" },
	{ "<leader>x", group = "Diagnostics" },
	{ "<leader><tab>", group = "Tabs" },
})
