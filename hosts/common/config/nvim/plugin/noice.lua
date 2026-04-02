vim.pack.add({
	{ src = "https://github.com/folke/noice.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
})

require("noice").setup({
	views = {
		hover = {
			border = { style = "single" },
			size = { max_width = 120, max_height = 25 },
		},
		cmdline_popup = {
			position = {
				row = 10,
				col = "50%",
			},
		},
	},
	cmdline = { enabled = true, view = "cmdline_popup" },
	lsp = {
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
	},
	presets = {
		bottom_search = true,
		command_palette = false,
		long_message_to_split = true,
		inc_rename = false,
		lsp_doc_border = false,
	},
})
