vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.nvim" },
})

require("mini.surround").setup({
	mappings = {
		add = "sa",
		delete = "sd",
		find = "sf",
		find_left = "sF",
		highlight = "sh",
		replace = "sr",
		update_n_lines = "sn",
	},
})

require("mini.pairs").setup()
require("mini.comment").setup()
require("mini.move").setup()
require("mini.ai").setup()
vim.api.nvim_set_hl(0, "HipatternsFixme", { fg = "#ff0000", bold = true })
vim.api.nvim_set_hl(0, "HipatternsHack", { fg = "#ffaa00", bold = true })
vim.api.nvim_set_hl(0, "HipatternsTodo", { fg = "#00ff00", bold = true })
vim.api.nvim_set_hl(0, "HipatternsNote", { fg = "#00aaff", bold = true })
vim.api.nvim_set_hl(0, "HipatternsWarn", { fg = "#ffaa00", bold = true })

local hipatterns = require("mini.hipatterns")
hipatterns.setup({
	highlighters = {
		fixme = { pattern = "%f[%w]()FIXME.*", group = "MiniHipatternsFixme" },
		hack = { pattern = "%f[%w]()HACK.*", group = "MiniHipatternsHack" },
		todo = { pattern = "%f[%w]()TODO.*", group = "MiniHipatternsTodo" },
		note = { pattern = "%f[%w]()NOTE.*", group = "MiniHipatternsNote" },
		warn = { pattern = "%f[%w]()WARN.*", group = "MiniHipatternsWarn" },
		hex_color = hipatterns.gen_highlighter.hex_color(),
	},
})
require("mini.bufremove").setup()

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
