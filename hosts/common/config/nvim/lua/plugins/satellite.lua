return {
	"lewis6991/satellite.nvim",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		handlers = {
			cursor = { enable = true },
			diagnostic = { enable = true },
			gitsigns = { enable = true },
			marks = { enable = true },
			search = { enable = true },
		},
	},
}
