local diff = require("mini.diff")
diff.setup({
	view = {
		style = "sign",
		signs = {
			add = "│",
			change = "│",
			delete = "_",
		},
	},
})

-- Sign column colors (set after setup so mini.diff doesn't override them)
vim.api.nvim_set_hl(0, "MiniDiffSignAdd", { fg = "#a9dd9d" })
vim.api.nvim_set_hl(0, "MiniDiffSignChange", { fg = "#e3c78a" })
vim.api.nvim_set_hl(0, "MiniDiffSignDelete", { fg = "#cf6a4c" })
-- Overlay colors
vim.api.nvim_set_hl(0, "MiniDiffOverAdd", { bg = "#3a4a3a" })
vim.api.nvim_set_hl(0, "MiniDiffOverChange", { bg = "#4a4a2a" })
vim.api.nvim_set_hl(0, "MiniDiffOverDelete", { bg = "#4a2a2a" })
vim.api.nvim_set_hl(0, "MiniDiffOverContext", { bg = "#2a2a2a" })

local git = require("mini.git")
git.setup()

-- Navigation
vim.keymap.set("n", "]c", function()
	if vim.wo.diff then
		return "]c"
	end
	diff.goto_hunk("next")
	return "<Ignore>"
end, { expr = true, desc = "Next hunk" })

vim.keymap.set("n", "[c", function()
	if vim.wo.diff then
		return "[c"
	end
	diff.goto_hunk("prev")
	return "<Ignore>"
end, { expr = true, desc = "Previous hunk" })

-- Actions
vim.keymap.set("n", "<leader>hs", diff.operator, { desc = "Apply hunk (stage)" })
vim.keymap.set("n", "<leader>hr", function()
	diff.operator("reset")
end, { desc = "Reset hunk" })
vim.keymap.set("n", "<leader>hp", diff.toggle_overlay, { desc = "Toggle diff overlay" })
vim.keymap.set("n", "<leader>hb", git.show_at_cursor, { desc = "Show git object at cursor" })
vim.keymap.set("n", "<leader>gb", function()
	git.show_at_cursor({ split = "below" })
end, { desc = "Blame line (below)" })

-- Text object
vim.keymap.set({ "o", "x" }, "ih", diff.operator, { desc = "MiniDiff select hunk" })
