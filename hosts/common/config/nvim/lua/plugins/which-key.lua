return {
	"folke/which-key.nvim",

	opts = {
		plugins = { spelling = true },
		defaults = {},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
	end,
}
