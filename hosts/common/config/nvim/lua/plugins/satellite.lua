return {
	"lewis6991/satellite.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		handlers = {
			cursor = { enable = true },
			diagnostic = { enable = true, min_severity = vim.diagnostic.severity.INFO },
			gitsigns = { enable = true },
			marks = { enable = true },
			search = { enable = true },
		},
	},
}
