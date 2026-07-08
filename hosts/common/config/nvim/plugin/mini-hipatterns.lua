vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.nvim" },
})

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
