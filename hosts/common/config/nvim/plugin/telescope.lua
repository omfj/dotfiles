vim.pack.add({
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
})

local actions = require("telescope.actions")

require("telescope").setup({
	defaults = {
		sorting_strategy = "ascending",
		layout_config = {
			horizontal = {
				width = 0.85,
				height = 0.85,
				prompt_position = "top",
				preview_width = 0.5,
			},
		},
		mappings = {
			i = {
				["<esc>"] = actions.close,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
			},
		},
	},
})

local builtin = require("telescope.builtin")

-- Yank the current visual selection and return it, restoring the register
local function visual_selection()
	local saved = vim.fn.getreg("v")
	vim.cmd('normal! "vy')
	local text = vim.fn.getreg("v")
	vim.fn.setreg("v", saved)
	return text
end

-- stylua: ignore start
vim.keymap.set("n", "<leader><space>", function() builtin.find_files() end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fc", function() builtin.find_files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find Config File" })
vim.keymap.set("n", "<leader>fF", function() builtin.find_files({ cwd = vim.fn.getcwd() }) end, { desc = "Find Files (cwd)" })
vim.keymap.set("n", "<leader>/", function() builtin.live_grep() end, { desc = "Grep" })
vim.keymap.set("n", "<leader>sg", function() builtin.live_grep() end, { desc = "Grep (root dir)" })
vim.keymap.set("n", "<leader>sG", function() builtin.live_grep({ cwd = vim.fn.getcwd() }) end, { desc = "Grep (cwd)" })
vim.keymap.set("n", "<leader>sf", function() builtin.live_grep({ cwd = vim.fn.expand("%:p:h") }) end, { desc = "Grep current folder" })
vim.keymap.set("n", "<leader>sw", function() builtin.grep_string() end, { desc = "Word (root dir)" })
vim.keymap.set("n", "<leader>sW", function() builtin.grep_string({ cwd = vim.fn.getcwd() }) end, { desc = "Word (cwd)" })
vim.keymap.set("v", "<leader>sw", function() builtin.grep_string({ search = visual_selection() }) end, { desc = "Selection (root dir)" })
vim.keymap.set("v", "<leader>sW", function() builtin.grep_string({ search = visual_selection(), cwd = vim.fn.getcwd() }) end, { desc = "Selection (cwd)" })
-- stylua: ignore end
