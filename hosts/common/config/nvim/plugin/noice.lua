vim.pack.add({
	{ src = "https://github.com/folke/noice.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
})

require("noice").setup({
	views = {
		hover = {
			size = { max_width = 60, max_height = 10 },
			position = { row = 2, col = 0 },
			win_options = {
				winhighlight = "Normal:NoiceHoverNormal,NormalFloat:NoiceHoverNormal",
			},
		},
		cmdline_popup = {
			position = { row = 0, col = "50%" },
		},
	},
	lsp = {
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
		},
	},
	cmdline = {
		enabled = true,
		view = "cmdline_popup",
	},
	messages = { enabled = true },
	presets = {
		bottom_search = true,
		command_palette = false,
		long_message_to_split = true,
		inc_rename = false,
	},
})
