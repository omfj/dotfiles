vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.nvim" },
})

local miniclue = require("mini.clue")

miniclue.setup({
	triggers = {
		{ mode = "n", keys = "<Leader>" },
		{ mode = "x", keys = "<Leader>" },
		{ mode = "i", keys = "<C-x>" },
		{ mode = "n", keys = "g" },
		{ mode = "x", keys = "g" },
		{ mode = "n", keys = "'" },
		{ mode = "n", keys = "`" },
		{ mode = "x", keys = "'" },
		{ mode = "x", keys = "`" },
		{ mode = "n", keys = '"' },
		{ mode = "x", keys = '"' },
		{ mode = "i", keys = "<C-r>" },
		{ mode = "c", keys = "<C-r>" },
		{ mode = "n", keys = "<C-w>" },
		{ mode = "n", keys = "z" },
		{ mode = "x", keys = "z" },
		{ mode = "n", keys = "[" },
		{ mode = "n", keys = "]" },
	},
	clues = {
		miniclue.gen_clues.builtin_completion(),
		miniclue.gen_clues.g(),
		miniclue.gen_clues.marks(),
		miniclue.gen_clues.registers(),
		miniclue.gen_clues.windows(),
		miniclue.gen_clues.z(),
		-- stylua: ignore start
		{ mode = "n", keys = "<Leader>a", desc = "+Agents" },
		{ mode = "n", keys = "<Leader>b", desc = "+Buffers" },
		{ mode = "n", keys = "<Leader>d", desc = "+Debug" },
		{ mode = "n", keys = "<Leader>dg", desc = "+Go" },
		{ mode = "n", keys = "<Leader>D", desc = "+Dependencies" },
		{ mode = "n", keys = "<Leader>C", desc = "+Crate (Rust)" },
		{ mode = "n", keys = "<Leader>c", desc = "+Code" },
		{ mode = "n", keys = "<Leader>f", desc = "+Files" },
		{ mode = "n", keys = "<Leader>g", desc = "+Git" },
		{ mode = "n", keys = "<Leader>h", desc = "+Git Hunks" },
		{ mode = "n", keys = "<Leader>m", desc = "+Mason" },
		{ mode = "n", keys = "<Leader>M", desc = "+Minimap" },
		{ mode = "n", keys = "<Leader>q", desc = "+Sessions" },
		{ mode = "n", keys = "<Leader>s", desc = "+Search" },
		{ mode = "n", keys = "<Leader>t", desc = "+Toggle" },
		{ mode = "n", keys = "<Leader>u", desc = "+UI" },
		{ mode = "n", keys = "<Leader>w", desc = "+Windows" },
		{ mode = "n", keys = "<Leader>x", desc = "+Diagnostics" },
		{ mode = "n", keys = "<Leader><tab>", desc = "+Tabs" },
		-- overrides
		{ mode = "n", keys = "grt", desc = "Goto Type Definition" },
		{ mode = "n", keys = "grx", desc = "Run codelens" },
		-- stylua: ignore end
	},
	window = {
		delay = 200,
		config = { width = "auto" },
	},
})

-- stylua: ignore start
vim.keymap.set("n", "<leader>Du", function() vim.pack.update() end, { desc = "Update (preview)" })
vim.keymap.set("n", "<leader>DU", function() vim.pack.update(nil, { force = true }) end, { desc = "Update (apply all)" })
vim.keymap.set("n", "<leader>Ds", function() vim.pack.update(nil, { target = "lockfile", force = true }) end, { desc = "Sync to lockfile" })
-- stylua: ignore end
