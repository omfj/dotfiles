return {
	"chomosuke/typst-preview.nvim",
	lazy = false, -- or ft = 'typst'
	version = "1.*",
	opts = {
		port = 9999,
		invert_colors = "auto", -- 'always', 'never' or 'auto'
		dependencies_bin = {
			["tinymist"] = "tinymist",
		},
	},
	keys = {
		{ "<leader>a", nil, desc = "Typst" },
		{ "<leader>tp", "<cmd>TypstPreviewToggle<cr>", desc = "Toggle Typst Preview" },
		{ "<leader>tu", "<cmd>TypstPreviewUpdate<cr>", desc = "Update Typst Preview" },
	},
}
