return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		input = { enabled = true },
		picker = {
			enabled = true,
			layout = {
				preset = "default",
				layout = {
					width = 0.85,
					height = 0.85,
				},
			},
		},
		lazygit = { enabled = true },
		scratch = { enabled = true },
		terminal = {
			enabled = true,
			win = { border = "rounded" },
		},
		scroll = { enabled = false },
		notifier = { enabled = true },
		words = { enabled = true },
		gh = { enabled = true },
		bigfile = { enabled = true },
	},
	keys = {
		{
			"<leader>gg",
			function()
				Snacks.lazygit()
			end,
			desc = "LazyGit",
		},
		{
			"<leader>ft",
			function()
				Snacks.terminal.toggle(nil, { win = { style = "float" } })
			end,
			desc = "Float Terminal",
		},
		{
			"<leader>fT",
			function()
				Snacks.terminal.toggle(nil, { win = { position = "bottom" } })
			end,
			desc = "Horizontal Terminal",
		},
		{
			"<c-/>",
			function()
				Snacks.terminal.toggle(nil, { win = { style = "float" } })
			end,
			desc = "Float Terminal",
		},
		{
			"<c-_>",
			function()
				Snacks.terminal.toggle(nil, { win = { style = "float" } })
			end,
			desc = "which_key_ignore",
		},
		{
			"<leader>.",
			function()
				Snacks.scratch()
			end,
			desc = "Scratch Buffer",
		},
	},
}
