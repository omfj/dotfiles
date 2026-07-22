vim.pack.add({
	{ src = "https://github.com/goolord/alpha-nvim" },
})

local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = require("util.banners").pryda
dashboard.section.buttons.val = {
	dashboard.button("n", "New file", "<cmd>enew | startinsert<cr>"),
	dashboard.button("f", "Find file", "<cmd>lua require('mini.pick').builtin.files()<cr>"),
	dashboard.button("r", "Recent files", "<cmd>lua require('mini.extra').pickers.oldfiles()<cr>"),
	dashboard.button("g", "Grep", "<cmd>lua require('mini.pick').builtin.grep_live()<cr>"),
	dashboard.button("s", "Restore session", "<cmd>lua require('mini.sessions').read()<cr>"),
	dashboard.button("S", "Select session", "<cmd>lua require('mini.sessions').select()<cr>"),
	dashboard.button("q", "Quit", "<cmd>qa<cr>"),
}

require("alpha").setup(dashboard.config)
