local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

keymap("n", "<Leader>f", ":CocCommand prettier.formatFile<CR>", opts)

