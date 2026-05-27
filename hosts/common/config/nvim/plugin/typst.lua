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

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if not client or client.name ~= "tinymist" then
			return
		end
		local bufnr = ev.buf

		if not vim.g.typst_manual_pin then
			local root = client.root_dir or vim.fn.getcwd()
			for _, rel in ipairs({ "main.typ", "src/main.typ" }) do
				local path = root .. "/" .. rel
				if vim.fn.filereadable(path) == 1 then
					client:exec_cmd({
						title = "pin",
						command = "tinymist.pinMain",
						arguments = { path },
					}, { bufnr = bufnr })
					break
				end
			end
		end

		vim.keymap.set("n", "<leader>tP", function()
			vim.g.typst_manual_pin = true
			client:exec_cmd({
				title = "pin",
				command = "tinymist.pinMain",
				arguments = { vim.api.nvim_buf_get_name(0) },
			}, { bufnr = bufnr })
		end, { desc = "Tinymist Pin", noremap = true, buffer = bufnr })

		vim.keymap.set("n", "<leader>tU", function()
			vim.g.typst_manual_pin = true
			client:exec_cmd({
				title = "unpin",
				command = "tinymist.pinMain",
				arguments = { vim.v.null },
			}, { bufnr = bufnr })
		end, { desc = "Tinymist Unpin", noremap = true, buffer = bufnr })
	end,
})
