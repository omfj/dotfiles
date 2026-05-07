vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if not client or client.name ~= "tinymist" then
			return
		end
		local bufnr = ev.buf
		vim.keymap.set("n", "<leader>tP", function()
			client:exec_cmd({
				title = "pin",
				command = "tinymist.pinMain",
				arguments = { vim.api.nvim_buf_get_name(0) },
			}, { bufnr = bufnr })
		end, { desc = "Tinymist Pin", noremap = true, buffer = bufnr })

		vim.keymap.set("n", "<leader>tU", function()
			client:exec_cmd({
				title = "unpin",
				command = "tinymist.pinMain",
				arguments = { vim.v.null },
			}, { bufnr = bufnr })
		end, { desc = "Tinymist Unpin", noremap = true, buffer = bufnr })
	end,
})

return {}
