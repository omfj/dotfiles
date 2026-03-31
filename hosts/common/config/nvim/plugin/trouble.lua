vim.pack.add({
	{ src = "https://github.com/folke/trouble.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

require("trouble").setup({
	modes = {
		symbols = { win = { size = 55 } },
		lsp = { win = { size = 55 } },
		diagnostics = { win = { size = 20 } },
		loclist = { win = { size = 20 } },
		qflist = { win = { size = 20 } },
	},
})

vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
vim.keymap.set("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", { desc = "LSP Definitions / references / ... (Trouble)" })
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
