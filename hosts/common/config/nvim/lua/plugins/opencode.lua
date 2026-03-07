return {
	"nickjvandyke/opencode.nvim",
	version = "*",
	dependencies = {
		{ "folke/snacks.nvim", optional = true },
	},
	keys = {
		{ "<leader>aa", function() require("opencode").ask() end, mode = { "n", "v" }, desc = "Ask opencode" },
		{ "<leader>as", function() require("opencode").select() end, mode = { "n", "v" }, desc = "Select opencode prompt" },
		{ "<leader>at", function() require("opencode").toggle() end, desc = "Toggle opencode" },
	},
	config = function()
		vim.g.opencode_opts = {}
		vim.o.autoread = true
	end,
}
