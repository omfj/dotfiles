vim.pack.add({
	{ src = "https://github.com/crnvl96/lazydocker.nvim" },
})

require("lazydocker").setup({
	window = {
		settings = {
			width = 0.618,
			height = 0.618,
			border = "rounded",
			relative = "editor",
		},
	},
})

vim.keymap.set({ "n", "t" }, "<leader>gd", function()
	require("lazydocker").toggle({ engine = "docker" })
end, { desc = "LazyDocker" })
