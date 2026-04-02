vim.pack.add({
	{ src = "https://github.com/akinsho/bufferline.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/echasnovski/mini.nvim" },
})

-- mini.bufremove is needed by bufferline keymaps
require("mini.bufremove").setup()

require("bufferline").setup({
	options = {
		mode = "buffers",
		themable = true,
		numbers = "ordinal",
		close_command = "bdelete! %d",
		right_mouse_command = "bdelete! %d",
		left_mouse_command = "buffer %d",
		middle_mouse_command = nil,
		indicator = {
			icon = "▎",
			style = "icon",
		},
		buffer_close_icon = "󰅖",
		modified_icon = "●",
		close_icon = "",
		left_trunc_marker = "",
		right_trunc_marker = "",
		max_name_length = 30,
		max_prefix_length = 30,
		truncate_names = true,
		tab_size = 21,
		diagnostics = "nvim_lsp",
		diagnostics_update_in_insert = false,
		show_buffer_icons = false,
		show_buffer_close_icons = true,
		show_close_icon = true,
		show_tab_indicators = true,
		show_duplicate_prefix = true,
		persist_buffer_sort = true,
		separator_style = "thin",
		enforce_regular_tabs = true,
		always_show_bufferline = true,
		hover = {
			enabled = true,
			delay = 200,
			reveal = { "close" },
		},
		sort_by = "insert_after_current",
		offsets = {
			{
				filetype = "neo-tree",
				text = "Explorer",
				highlight = "Directory",
				text_align = "left",
			},
		},
	},
})

local bufremove = require("mini.bufremove")
vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bc", function()
	bufremove.delete(0, false)
end, { desc = "Close current buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>BufferLinePickClose<cr>", { desc = "Pick buffer to close" })
vim.keymap.set("n", "<leader>bD", function()
	bufremove.delete(0, true)
end, { desc = "Delete Buffer (force)" })
vim.keymap.set("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", { desc = "Delete Other Buffers" })

for i = 1, 9 do
	vim.keymap.set("n", "<C-w>" .. i, "<cmd>BufferLineGoToBuffer " .. i .. "<cr>", { desc = "Go to buffer " .. i })
end
