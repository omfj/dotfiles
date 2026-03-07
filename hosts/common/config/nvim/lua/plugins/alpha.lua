return {
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")
			-- Add a button to load the last session
			dashboard.section.buttons.val = {
				dashboard.button("e", "   New file", ":ene <BAR> startinsert <CR>"),
				dashboard.button("f", "   Find file", ":Telescope find_files <CR>"),
				dashboard.button("r", "   Recent files", ":Telescope oldfiles <CR>"),
				dashboard.button("g", "   Find word", ":Telescope live_grep <CR>"),
				-- Persistence.nvim buttons
				dashboard.button("s", "   Restore Session", ":lua require('persistence').load()<CR>"),
				dashboard.button("S", "   Select Session", ":lua require('persistence').select()<CR>"),
				-- Quit
				dashboard.button("", ""),
				dashboard.button("q", "   Quit", ":qa<CR>"),
			}
			-- Footer: plugin count + nvim version
			local version = vim.version()
			local plugins = require("lazy").stats().count
			dashboard.section.footer.val = string.format(
				"  %d plugins   nvim %d.%d.%d",
				plugins,
				version.major,
				version.minor,
				version.patch
			)
			alpha.setup(dashboard.opts)
		end,
	},
}
