vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.nvim" },
})

local notify = require("mini.notify")

notify.setup({
	-- LSP progress is rendered by the LspProgress autocmd in plugin/lsp.lua
	lsp_progress = { enable = false },
})

vim.notify = notify.make_notify()

-- stylua: ignore start
vim.keymap.set("n", "<leader>n", function() notify.show_history() end, { desc = "Notifications History" })
vim.keymap.set("n", "<leader>sn", function() notify.show_history() end, { desc = "Notification History" })
vim.keymap.set("n", "<leader>sN", function() notify.clear() end, { desc = "Dismiss Notifications" })
-- stylua: ignore end

-- Notify on vim.pack install/update/remove
local kind_icons = { install = "󰏗", update = "󰚰", remove = "󰆴" }
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		local icon = kind_icons[kind] or "󰏗"
		vim.notify(name, vim.log.levels.INFO, { title = icon .. " " .. kind })
	end,
})
