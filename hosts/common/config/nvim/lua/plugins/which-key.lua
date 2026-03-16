return {
	"folke/which-key.nvim",

	opts = {
		plugins = { spelling = true },
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
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
	end,
}
