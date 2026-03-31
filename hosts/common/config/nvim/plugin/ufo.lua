vim.pack.add({
	{ src = "https://github.com/kevinhwang91/nvim-ufo" },
	{ src = "https://github.com/kevinhwang91/promise-async" },
})

require("ufo").setup({
	provider_selector = function()
		return { "treesitter", "indent" }
	end,
})

vim.keymap.set("n", "zR", function()
	require("ufo").openAllFolds()
end, { desc = "Open all folds" })
vim.keymap.set("n", "zM", function()
	require("ufo").closeAllFolds()
end, { desc = "Close all folds" })
vim.keymap.set("n", "zr", function()
	require("ufo").openFoldsExceptKinds()
end, { desc = "Open folds except kinds" })
vim.keymap.set("n", "zm", function()
	require("ufo").closeFoldsWith()
end, { desc = "Close folds with" })
vim.keymap.set("n", "K", function()
	local foldclosed = vim.fn.foldclosed(vim.fn.line("."))
	if foldclosed ~= -1 then
		require("ufo").peekFoldedLinesUnderCursor()
	else
		vim.lsp.buf.hover()
	end
end, { desc = "Peek fold or hover" })
