vim.pack.add({
	{ src = "https://github.com/goolord/alpha-nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

local alpha = require("alpha")
local dashboard = require("alpha.themes.dashboard")

dashboard.section.buttons.val = {
	dashboard.button("e", "   New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("f", "   Find file", ":Telescope find_files <CR>"),
	dashboard.button("r", "   Recent files", ":Telescope oldfiles <CR>"),
	dashboard.button("g", "   Find word", ":Telescope live_grep <CR>"),
	dashboard.button("s", "   Restore Session", ":lua require('persistence').load()<CR>"),
	dashboard.button("S", "   Select Session", ":lua require('persistence').select()<CR>"),
	dashboard.button("", ""),
	dashboard.button("q", "   Quit", ":qa<CR>"),
}

local version = vim.version()
local ms = (vim.uv.hrtime() - vim.g.start_time) / 1e6
dashboard.section.footer.val =
	string.format("  nvim %d.%d.%d   %.0fms", version.major, version.minor, version.patch, ms)

-- To use a banner as the header, comment out the following lines:
--local banners = require("banners")
--dashboard.section.header.val = banners.pryda

vim.api.nvim_set_hl(0, "AlphaHeader", { fg = "#f31019" })
dashboard.section.header.opts.hl = "AlphaHeader"
alpha.setup(dashboard.opts)
