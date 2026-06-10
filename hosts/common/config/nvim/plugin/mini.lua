vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.nvim" },
})

require("mini.surround").setup({
	mappings = {
		add = "gza",
		delete = "gzd",
		find = "gzf",
		find_left = "gzF",
		highlight = "gzh",
		replace = "gzr",
		update_n_lines = "gzn",
	},
})

require("mini.pairs").setup()
require("mini.comment").setup()
require("mini.move").setup()
require("mini.ai").setup()

local sessions = require("mini.sessions")

-- stylua: ignore start
sessions.setup({ autowrite = true })
vim.keymap.set("n", "<leader>qw", function() sessions.write() end, { desc = "Save session" })
vim.keymap.set("n", "<leader>qc", function()
  vim.ui.input({ prompt = "Session name: " }, function(name)
    if name and name ~= "" then
      sessions.write(name)
    end
  end)
end, { desc = "Create session" })
vim.keymap.set("n", "<leader>qs", function() sessions.read() end, { desc = "Restore session" })
vim.keymap.set("n", "<leader>qS", function() sessions.select() end, { desc = "Select session" })
vim.keymap.set("n", "<leader>ql", function() sessions.read() end, { desc = "Restore last session" })
vim.keymap.set("n", "<leader>qd", function() require("mini.sessions").config.autowrite = false end, { desc = "Don't save session" })
vim.keymap.set("n", "<leader>qD", function() sessions.select("delete") end, { desc = "Delete session" })
-- stylua: ignore end
