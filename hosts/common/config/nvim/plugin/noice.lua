vim.pack.add({
	{ src = "https://github.com/folke/noice.nvim" },
	{ src = "https://github.com/MunifTanjim/nui.nvim" },
})

require("noice").setup({
	views = {
		hover = {
			border = { style = "none" },
			size = { max_width = 120, max_height = 25 },
		},
	},
	lsp = {
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
		},
	},
	cmdline = { enabled = false },
	messages = { enabled = false },
	presets = {
		bottom_search = true,
		command_palette = false,
		long_message_to_split = true,
		inc_rename = false,
		lsp_doc_border = false,
	},
})
