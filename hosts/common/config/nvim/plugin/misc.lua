vim.pack.add({
	{ src = "https://github.com/tpope/vim-sleuth" },
	{ src = "https://github.com/windwp/nvim-ts-autotag" },
	{ src = "https://github.com/folke/ts-comments.nvim" },
	{ src = "https://github.com/dmmulroy/ts-error-translator.nvim" },
})

require("nvim-ts-autotag").setup()
require("ts-comments").setup()
require("ts-error-translator").setup()
