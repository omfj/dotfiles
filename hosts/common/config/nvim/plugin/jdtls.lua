vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",
	callback = function()
		dofile(vim.fn.stdpath("config") .. "/lsp/jdtls.lua")
	end,
})
