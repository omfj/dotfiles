return {
	"zbirenbaum/copilot.lua",
	event = "InsertEnter",
	opts = {
		suggestion = {
			enabled = true,
			auto_trigger = true,
			keymap = {
				accept = "<Tab>",
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
