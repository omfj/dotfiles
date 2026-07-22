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
			if vim.bo.filetype ~= "alpha" then
				map.open()
			end
		end)
	end,
})

-- stylua: ignore start
vim.keymap.set("n", "<leader>Mo", function() map.open() end, { desc = "Open minimap" })
vim.keymap.set("n", "<leader>Mc", function() map.close() end, { desc = "Close minimap" })
vim.keymap.set("n", "<leader>Mt", function() map.toggle() end, { desc = "Toggle minimap" })
vim.keymap.set("n", "<leader>Mr", function() map.refresh() end, { desc = "Refresh minimap" })
vim.keymap.set("n", "<leader>Mf", function() map.toggle_focus() end, { desc = "Toggle focus" })
vim.keymap.set("n", "<leader>Ms", function() map.toggle_side() end, { desc = "Toggle side" })
-- stylua: ignore end
