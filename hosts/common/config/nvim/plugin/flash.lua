vim.pack.add({
	{ src = "https://github.com/folke/flash.nvim" },
})

require("flash").setup({
	modes = {
		char = { jump_labels = true },
	},
})

vim.keymap.set({ "n", "x", "o" }, "gS", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
vim.keymap.set({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })
vim.keymap.set("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })
