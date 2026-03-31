vim.pack.add({
	{ src = "https://github.com/lewis6991/satellite.nvim" },
})

require("satellite").setup({
	handlers = {
		cursor = { enable = true },
		diagnostic = { enable = true, min_severity = vim.diagnostic.severity.INFO },
		gitsigns = { enable = true },
		marks = { enable = true },
		search = { enable = true },
	},
})
