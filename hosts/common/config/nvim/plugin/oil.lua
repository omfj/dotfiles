vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
})

require("oil").setup({
	default_file_explorer = false,
	view_options = {
		show_hidden = true,
	},
	float = {
		padding = 2,
		max_width = 80,
		max_height = 30,
		border = "single",
	},
})

vim.keymap.set("n", "<leader>fo", "<cmd>Oil --float<cr>", { desc = "Open oil (float)" })
