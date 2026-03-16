return {
	"zbirenbaum/copilot.lua",
	event = "InsertEnter",
	keys = {
		{
			"<leader>ap",
			function()
				require("copilot.suggestion").toggle_auto_trigger()
				vim.g.copilot_suggestion_enabled = not (vim.g.copilot_suggestion_enabled ~= false)
				vim.notify(vim.g.copilot_suggestion_enabled and "Copilot enabled" or "Copilot disabled")
			end,
			desc = "Toggle Copilot",
		},
	},
	opts = {
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
	},
}
