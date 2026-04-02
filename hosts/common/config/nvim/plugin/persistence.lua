vim.pack.add({
	{ src = "https://github.com/folke/persistence.nvim" },
})

local pers = require("persistence")

pers.setup()

vim.keymap.set("n", "<leader>qs", function()
	pers.load()
end, { desc = "Restore session" })
vim.keymap.set("n", "<leader>qS", function()
	pers.select()
end, { desc = "Select session" })
vim.keymap.set("n", "<leader>ql", function()
	pers.load({ last = true })
end, { desc = "Restore last session" })
vim.keymap.set("n", "<leader>qd", function()
	pers.stop()
end, { desc = "Don't save session" })
