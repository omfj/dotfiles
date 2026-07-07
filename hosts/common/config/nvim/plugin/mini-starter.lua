vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.nvim" },
})

local starter = require("mini.starter")

starter.setup({
	evaluate_single = true,
	items = {
		-- stylua: ignore start
		{ name = "New file", action = "enew | startinsert", section = "Actions" },
		{ name = "Find file", action = function() require("mini.pick").builtin.files() end, section = "Actions" },
		{ name = "Recent files", action = function() require("mini.extra").pickers.oldfiles() end, section = "Actions" },
		{ name = "Grep", action = function() require("mini.pick").builtin.grep_live() end, section = "Actions" },
		{ name = "Quit", action = "qa", section = "Actions" },
		{ name = "Restore session", action = function() require("mini.sessions").read() end, section = "Sessions" },
		{ name = "Select session", action = function() require("mini.sessions").select() end, section = "Sessions" },
		-- stylua: ignore end
	},
	footer = function()
		return string.format(
			"nvim %d.%d.%d   %.0fms",
			vim.version().major,
			vim.version().minor,
			vim.version().patch,
			(vim.uv.hrtime() - vim.g.start_time) / 1e6
		)
	end,
})
