vim.pack.add({
	{ src = "https://github.com/zbirenbaum/copilot.lua" },
})

require("copilot").setup({
	suggestion = {
		enabled = true,
		auto_trigger = true,
		keymap = {
			accept = false,
			accept_word = "<C-Right>",
			accept_line = "<C-Down>",
			next = "<M-]>",
			prev = "<M-[>",
			dismiss = "<C-]>",
		},
	},
	panel = { enabled = false },
})

-- Disable Copilot suggestions during macro execution to prevent interference
vim.api.nvim_create_autocmd("TextChangedI", {
	callback = function()
		if vim.fn.reg_executing() ~= "" then
			require("copilot.suggestion").dismiss()
		end
	end,
	desc = "Dismiss Copilot suggestion during macro execution",
})

-- Toggle Copilot suggestions
vim.keymap.set("n", "<leader>ap", function()
	require("copilot.suggestion").toggle_auto_trigger()
	vim.g.copilot_suggestion_enabled = not (vim.g.copilot_suggestion_enabled ~= false)
end, { desc = "Toggle Copilot" })
