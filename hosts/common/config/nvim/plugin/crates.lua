vim.pack.add({
	{ src = "https://github.com/saecki/crates.nvim" },
})

require("crates").setup({
	lsp = {
		enabled = true,
		actions = true,
		completion = true,
		hover = true,
	},
	completion = {
		crates = {
			enabled = true,
			max_results = 5,
			min_chars = 3,
		},
	},
})

vim.keymap.set({ "n", "v" }, "<leader>tC", function()
	require("crates").toggle()
end, { desc = "Toggle Crate Info" })
vim.keymap.set({ "n", "v" }, "<leader>Ca", function()
	require("crates").show_popup()
end, { desc = "Show Crate Info" })
vim.keymap.set({ "n", "v" }, "<leader>Cu", function()
	require("crates").update_crate()
end, { desc = "Update Crate" })
vim.keymap.set({ "n", "v" }, "<leader>Cr", function()
	require("crates").reload()
end, { desc = "Reload Crate Info" })
vim.keymap.set({ "n", "v" }, "<leader>Cf", function()
	require("crates").show_features_popup()
end, { desc = "Open Crate Features" })
vim.keymap.set("n", "<leader>Ch", function()
	require("crates").open_homepage()
end, { desc = "Open Crate Homepage" })
vim.keymap.set("n", "<leader>Cd", function()
	require("crates").open_documentation()
end, { desc = "Open Crate Documentation" })
