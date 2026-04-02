vim.pack.add({
	{ src = "https://github.com/MagicDuck/grug-far.nvim" },
})

require("grug-far").setup()

vim.keymap.set("n", "<leader>sr", "<cmd>GrugFar<cr>", { desc = "Search and Replace" })
vim.keymap.set("v", "<leader>sr", function()
	require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
end, { desc = "Search and Replace (selection)" })
