vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.nvim" },
})

local map = require("mini.map")

map.setup({
	symbols = {
		scroll_line = "█",
		scroll_view = "┃",
	},
	integrations = {
		map.gen_integration.diff(),
	},
	window = {
		show_integration_count = false,
	},
})

-- Open by default, except on the start screen
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.schedule(function()
			if vim.bo.filetype ~= "snacks_dashboard" then
				map.open()
			end
		end)
	end,
})

-- stylua: ignore start
vim.keymap.set("n", "<leader>uMo", function() map.open() end, { desc = "Open minimap" })
vim.keymap.set("n", "<leader>uMc", function() map.close() end, { desc = "Close minimap" })
vim.keymap.set("n", "<leader>uMt", function() map.toggle() end, { desc = "Toggle minimap" })
vim.keymap.set("n", "<leader>uMr", function() map.refresh() end, { desc = "Refresh minimap" })
vim.keymap.set("n", "<leader>uMf", function() map.toggle_focus() end, { desc = "Toggle focus" })
vim.keymap.set("n", "<leader>uMs", function() map.toggle_side() end, { desc = "Toggle side" })
-- stylua: ignore end
