vim.pack.add({
	{ src = "https://github.com/chomosuke/typst-preview.nvim" },
})

local function get_invert_colors()
	return vim.g.typstdark and "always" or "never"
end

local opts = {
	port = 9999,
	invert_colors = get_invert_colors(),
	dependencies_bin = {
		["tinymist"] = "tinymist",
	},
}

require("typst-preview").setup(opts)

vim.keymap.set("n", "<leader>tp", "<cmd>TypstPreviewToggle<cr>", { desc = "Toggle Typst Preview" })
vim.keymap.set("n", "<leader>tu", "<cmd>TypstPreviewUpdate<cr>", { desc = "Update Typst Preview" })
vim.keymap.set("n", "<leader>tf", "<cmd>TypstPreviewFollowCursorToggle<cr>", { desc = "Toggle Follow Cursor" })
vim.keymap.set("n", "<leader>ts", "<cmd>TypstPreviewStop<cr>", { desc = "Stop Typst Preview" })
vim.keymap.set("n", "<leader>tt", function()
	vim.g.typstdark = not vim.g.typstdark
	opts.invert_colors = get_invert_colors()
	require("typst-preview").setup(opts)
	vim.cmd("TypstPreviewStop")
	vim.notify("Typst theme toggled to " .. (vim.g.typstdark and "dark" or "light"))
	vim.notify("Please restart the preview to see the changes.")
end, { desc = "Toggle Typst theme" })
