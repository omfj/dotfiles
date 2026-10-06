vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.nvim" },
})

require("mini.surround").setup()

local hipatterns = require("mini.hipatterns")

hipatterns.setup({
	highlighters = {
		hex_color = hipatterns.gen_highlighter.hex_color(),
		fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
		hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
		todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
		note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
		nbsp = { pattern = "\xC2\xA0", group = "MiniHipatternsNbsp" },
	},
})

require("mini.pairs").setup()

require("mini.move").setup()
require("mini.ai").setup()
require("mini.trailspace").setup()
vim.api.nvim_create_autocmd("User", {
	pattern = "SnacksDashboardOpened",
	callback = function()
		vim.b.minitrailspace_disable = true
		MiniTrailspace.unhighlight()
	end,
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
vim.keymap.set("n", "<leader>qd", function() sessions.config.autowrite = false end, { desc = "Don't save session" })
vim.keymap.set("n", "<leader>qD", function() sessions.select("delete") end, { desc = "Delete session" })
-- stylua: ignore end
