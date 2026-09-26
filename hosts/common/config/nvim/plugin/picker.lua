-- stylua: ignore start

-- find
vim.keymap.set("n", "<leader><space>", function() Snacks.picker.files() end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find Config File" })
vim.keymap.set("n", "<leader>,", function() Snacks.picker.buffers() end, { desc = "Switch Buffer" })
vim.keymap.set("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Recent" })
vim.keymap.set("n", "<leader>fR", function() Snacks.picker.recent({ filter = { cwd = true } }) end, { desc = "Recent (cwd)" })

-- grep (relative to cwd)
vim.keymap.set("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep" })
vim.keymap.set("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Grep (cwd)" })
vim.keymap.set("n", "<leader>sf", function() Snacks.picker.grep({ dirs = { vim.fn.expand("%:p:h") } }) end, { desc = "Grep current folder" })
vim.keymap.set("n", "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Word (cwd)" })
vim.keymap.set("x", "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Selection (cwd)" })

-- git
vim.keymap.set("n", "<leader>gc", function() Snacks.picker.git_log() end, { desc = "commits" })
vim.keymap.set("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "status" })

-- LSP
vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "LSP Info" })
vim.keymap.set("n", "<leader>lr", "<cmd>LspRestart<cr>", { desc = "Restart LSP" })

-- search
vim.keymap.set("n", '<leader>s"', function() Snacks.picker.registers() end, { desc = "Registers" })
vim.keymap.set("n", "<leader>sb", function() Snacks.picker.lines() end, { desc = "Buffer" })
vim.keymap.set("n", "<leader>sc", function() Snacks.picker.command_history() end, { desc = "Command History" })
vim.keymap.set("n", "<leader>sC", function() Snacks.picker.commands() end, { desc = "Commands" })
vim.keymap.set("n", "<leader>sd", function() Snacks.picker.diagnostics_buffer() end, { desc = "Document Diagnostics" })
vim.keymap.set("n", "<leader>sD", function() Snacks.picker.diagnostics() end, { desc = "Workspace Diagnostics" })
vim.keymap.set("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Help Pages" })
vim.keymap.set("n", "<leader>sH", function() Snacks.picker.highlights() end, { desc = "Search Highlight Groups" })
vim.keymap.set("n", "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Key Maps" })
vim.keymap.set("n", "<leader>sm", function() Snacks.picker.marks() end, { desc = "Jump to Mark" })
vim.keymap.set("n", "<leader>sR", function() Snacks.picker.resume() end, { desc = "Resume" })
vim.keymap.set("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, { desc = "Symbols" })
vim.keymap.set("n", "<leader>uC", function() Snacks.picker.colorschemes() end, { desc = "Colorscheme" })

-- stylua: ignore end
