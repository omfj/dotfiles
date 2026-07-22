vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.nvim" },
})

local notify = require("mini.notify")

notify.setup({
	lsp_progress = { enable = false },
})

vim.notify = notify.make_notify()

-- stylua: ignore start
vim.keymap.set("n", "<leader>n", function() notify.show_history() end, { desc = "Notifications History" })
vim.keymap.set("n", "<leader>sn", function() notify.show_history() end, { desc = "Notification History" })
vim.keymap.set("n", "<leader>sN", function() notify.clear() end, { desc = "Dismiss Notifications" })
-- stylua: ignore end
