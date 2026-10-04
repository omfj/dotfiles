vim.pack.add({
	{ src = "https://github.com/folke/snacks.nvim" },
})

local picker_search = {
	hidden = true,
	ignored = true,
	exclude = {
		".git",
		".DS_Store",
		-- build output
		"target",
		"build",
		"dist",
		-- js
		"node_modules",
		".turbo",
		".svelte-kit",
		".wrangler",
		".next",
		".output",
		".vercel",
		".astro",
		"coverage",
		-- python
		".venv",
		"__pycache__",
		".mypy_cache",
		".pytest_cache",
		".ruff_cache",
		-- misc caches
		".cache",
		".terraform",
		-- lock files
		"*.lock",
		"*.lockb",
		"pnpm-lock.yaml",
		"package-lock.json",
	},
}

require("snacks").setup({
	lazygit = { enabled = true },
	scratch = { enabled = true },
	terminal = { enabled = true },
	words = { enabled = true },
	bigfile = { enabled = true },
	picker = {
		enabled = true,
		sources = {
			files = picker_search,
			grep = picker_search,
			grep_word = picker_search,
			explorer = picker_search,
		},
	},
	input = { enabled = true },
})

-- stylua: ignore start

vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "LazyGit" })
vim.keymap.set("n", "<leader>uz", function()
	Snacks.zen({
		toggles = {},
		show = {
			statusline = true,
			tabline = true,
		},
	})
end, { desc = "Centered Buffer" })
vim.keymap.set("n", "<leader>ft", function() Snacks.terminal.toggle(nil, { win = { style = "float" } }) end, { desc = "Float Terminal" })
vim.keymap.set("n", "<leader>fT", function() Snacks.terminal.toggle(nil, { win = { position = "bottom" } }) end, { desc = "Horizontal Terminal" })
vim.keymap.set("n", "<c-/>", function() Snacks.terminal.toggle(nil, { win = { style = "float" } }) end, { desc = "Float Terminal" })
vim.keymap.set("n", "<c-_>", function() Snacks.terminal.toggle(nil, { win = { style = "float" } }) end, { desc = "Float Terminal" })
vim.keymap.set("n", "<leader>.", function() Snacks.scratch() end, { desc = "Scratch Buffer" })

-- stylua: ignore end
