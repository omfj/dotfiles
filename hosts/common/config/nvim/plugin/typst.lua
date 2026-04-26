vim.pack.add({
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
})

require("typst-preview").setup({
	port = 9999,
	invert_colors = vim.g.typstdark and true or false,
	dependencies_bin = {
		["tinymist"] = "tinymist",
	},
})

vim.keymap.set("n", "<leader>tp", "<cmd>TypstPreviewToggle<cr>", { desc = "Toggle Typst Preview" })
vim.keymap.set("n", "<leader>tu", "<cmd>TypstPreviewUpdate<cr>", { desc = "Update Typst Preview" })
vim.keymap.set("n", "<leader>tf", "<cmd>TypstPreviewFollowCursorToggle<cr>", { desc = "Toggle Follow Cursor" })
vim.keymap.set("n", "<leader>ts", "<cmd>TypstPreviewStop<cr>", { desc = "Stop Typst Preview" })
vim.keymap.set("n", "<leader>tt", function()
	vim.g.typstdark = not vim.g.typstdark
	vim.notify("Typst theme toggled to " .. (vim.g.typstdark and "dark" or "light"))
end, { desc = "Toggle Typst theme" })
