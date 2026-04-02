vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "telescope-fzf-native.nvim" and (kind == "install" or kind == "update") then
			vim.system({ "make" }, { cwd = ev.data.path })
		end
	end,
})

vim.pack.add({
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-ui-select.nvim" },
})

local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown(),
		},
	},
	defaults = {
		file_ignore_patterns = {
			"^.git/",
			"^node_modules/",
			"^.next/",
			"^dist/",
			"^build/",
			"^target/",
			"^.svelte%-kit/",
			"^.astro/",
			"^.turbo/",
		},
		prompt_prefix = " ",
		selection_caret = ">",
		get_selection_window = function()
			local wins = vim.api.nvim_list_wins()
			table.insert(wins, 1, vim.api.nvim_get_current_win())
			for _, win in ipairs(wins) do
				local buf = vim.api.nvim_win_get_buf(win)
				if vim.bo[buf].buftype == "" then
					return win
				end
			end
			return 0
		end,
		mappings = {
			n = {
				["q"] = actions.close,
			},
		},
	},
})
pcall(telescope.load_extension, "fzf")
telescope.load_extension("ui-select")

vim.keymap.set("n", "<leader>,", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", { desc = "Switch Buffer" })
vim.keymap.set("n", "<leader>/", "<cmd>Telescope live_grep<cr>", { desc = "Grep (root dir)" })
vim.keymap.set("n", "<leader>:", function()
	require("noice").cmd("history")
end, { desc = "Command History" })
vim.keymap.set("n", "<leader><space>", "<cmd>Telescope find_files hidden=true<cr>", { desc = "Find Files (root dir)" })

-- find
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", { desc = "Buffers" })
vim.keymap.set("n", "<leader>fc", "<cmd>Telescope find_files cwd=false<cr>", { desc = "Find Config File" })
vim.keymap.set("n", "<leader>fF", "<cmd>Telescope find_files cwd=false<cr>", { desc = "Find Files (cwd)" })
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent" })
vim.keymap.set("n", "<leader>fR", "<cmd>Telescope oldfiles cwd_only=true<cr>", { desc = "Recent (cwd)" })

-- git
vim.keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "commits" })
vim.keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "status" })

-- search
vim.keymap.set("n", '<leader>s"', "<cmd>Telescope registers<cr>", { desc = "Registers" })
vim.keymap.set("n", "<leader>sa", "<cmd>Telescope autocommands<cr>", { desc = "Auto Commands" })
vim.keymap.set("n", "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", { desc = "Buffer" })
vim.keymap.set("n", "<leader>sc", function()
	require("noice").cmd("history")
end, { desc = "Command History" })
vim.keymap.set("n", "<leader>sC", "<cmd>Telescope commands<cr>", { desc = "Commands" })
vim.keymap.set("n", "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", { desc = "Document diagnostics" })
vim.keymap.set("n", "<leader>sD", "<cmd>Telescope diagnostics<cr>", { desc = "Workspace diagnostics" })
vim.keymap.set("n", "<leader>sg", "<cmd>Telescope live_grep<cr>", { desc = "Grep (root dir)" })
vim.keymap.set("n", "<leader>sG", "<cmd>Telescope live_grep cwd=false<cr>", { desc = "Grep (cwd)" })
vim.keymap.set("n", "<leader>sf", function()
	require("telescope.builtin").live_grep({ cwd = vim.fn.getcwd() })
end, { desc = "Grep current folder" })
vim.keymap.set("n", "<leader>sh", "<cmd>Telescope help_tags<cr>", { desc = "Help Pages" })
vim.keymap.set("n", "<leader>sH", "<cmd>Telescope highlights<cr>", { desc = "Search Highlight Groups" })
vim.keymap.set("n", "<leader>sk", "<cmd>Telescope keymaps<cr>", { desc = "Key Maps" })
vim.keymap.set("n", "<leader>sM", "<cmd>Telescope man_pages<cr>", { desc = "Man Pages" })
vim.keymap.set("n", "<leader>sm", "<cmd>Telescope marks<cr>", { desc = "Jump to Mark" })
vim.keymap.set("n", "<leader>so", "<cmd>Telescope vim_options<cr>", { desc = "Options" })
vim.keymap.set("n", "<leader>sR", "<cmd>Telescope resume<cr>", { desc = "Resume" })
vim.keymap.set("n", "<leader>ss", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Symbols" })
vim.keymap.set("n", "<leader>sw", "<cmd>Telescope grep_string word_match=-w<cr>", { desc = "Word (root dir)" })
vim.keymap.set("n", "<leader>sW", "<cmd>Telescope grep_string cwd=false word_match=-w<cr>", { desc = "Word (cwd)" })
vim.keymap.set("v", "<leader>sw", "<cmd>Telescope grep_string<cr>", { desc = "Selection (root dir)" })
vim.keymap.set("v", "<leader>sW", "<cmd>Telescope grep_string cwd=false<cr>", { desc = "Selection (cwd)" })
vim.keymap.set("n", "<leader>uC", "<cmd>Telescope colorscheme enable_preview=true<cr>", { desc = "Colorscheme with preview" })
