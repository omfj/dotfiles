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
local hipatterns = require("mini.hipatterns")
hipatterns.setup({
	highlighters = {
		hex_color = hipatterns.gen_highlighter.hex_color(),
		fixme = { pattern = "%f[%w]()FIXME:?()%f[%W]", group = "DiagnosticError" },
		hack = { pattern = "%f[%w]()HACK:?()%f[%W]", group = "DiagnosticWarn" },
		todo = { pattern = "%f[%w]()TODO:?()%f[%W]", group = "DiagnosticOk" },
		note = { pattern = "%f[%w]()NOTE:?()%f[%W]", group = "DiagnosticInfo" },
		warn = { pattern = "%f[%w]()WARN:?()%f[%W]", group = "DiagnosticWarn" },
	},
})
require("mini.bufremove").setup()

local sessions = require("mini.sessions")
sessions.setup({ autowrite = true })
vim.keymap.set("n", "<leader>qs", function()
	sessions.read()
end, { desc = "Restore session" })
vim.keymap.set("n", "<leader>qS", function()
	sessions.select()
end, { desc = "Select session" })
vim.keymap.set("n", "<leader>ql", function()
	sessions.read()
end, { desc = "Restore last session" })
vim.keymap.set("n", "<leader>qd", function()
	require("mini.sessions").config.autowrite = false
end, { desc = "Don't save session" })

require("mini.jump2d").setup({
	mappings = { start_jumping = "s" },
})
