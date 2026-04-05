vim.pack.add({
	{ src = "https://github.com/coder/claudecode.nvim" },
	{ src = "https://github.com/zbirenbaum/copilot.lua" },
})

require("claudecode").setup()

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

vim.keymap.set("n", "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })
vim.keymap.set("n", "<leader>af", "<cmd>ClaudeCodeFocus<cr>", { desc = "Focus Claude" })
vim.keymap.set("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>", { desc = "Resume Claude" })
vim.keymap.set("n", "<leader>aC", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue Claude" })
vim.keymap.set("n", "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Select Claude model" })
vim.keymap.set("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add current buffer" })
vim.keymap.set("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send to Claude" })
vim.keymap.set("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept diff" })
vim.keymap.set("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny diff" })
