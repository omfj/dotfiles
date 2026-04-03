vim.pack.add({
	{ src = "https://github.com/crnvl96/lazydocker.nvim" },
})

require("lazydocker").setup({
	window = {
		settings = {
			width = 0.8,
			height = 0.8,
			border = "single",
			relative = "editor",
		},
	},
})

vim.keymap.set({ "n", "t" }, "<leader>gd", function()
	require("lazydocker").toggle({ engine = "docker" })
end, { desc = "LazyDocker" })
