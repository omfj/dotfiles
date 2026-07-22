vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.nvim" },
})

local pick = require("mini.pick")
local extra = require("mini.extra")

-- Centered window, similar to the old telescope layout.
-- height/width exclude the border, so size the outer box (content + 2 border
-- cells) to 85% of the rows free between the tabline, statusline and cmdline.
local win_config = function()
	local free_rows = vim.o.lines - vim.o.cmdheight - 2
	local outer_height = math.floor(0.85 * free_rows)
	local outer_width = math.floor(0.85 * vim.o.columns)
	return {
		anchor = "NW",
		border = "single",
		height = outer_height - 2,
		width = outer_width - 2,
		row = 1 + math.floor(0.5 * (free_rows - outer_height)),
		col = math.floor(0.5 * (vim.o.columns - outer_width)),
	}
end

pick.setup({
	mappings = {
		move_down = "<C-j>",
		move_up = "<C-k>",
	},
	window = { config = win_config },
})

extra.setup()

vim.ui.select = pick.ui_select

-- Yank the current visual selection and return it, restoring the register
local function visual_selection()
	local saved = vim.fn.getreg("v")
	local saved_type = vim.fn.getregtype("v")
	vim.cmd('normal! "vy')
	local text = vim.fn.getreg("v")
	vim.fn.setreg("v", saved, saved_type)
	return text
end

-- stylua: ignore start

-- find
vim.keymap.set("n", "<leader><space>", function() pick.builtin.files() end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fc", function() pick.builtin.files(nil, { source = { cwd = vim.fn.stdpath("config") } }) end, { desc = "Find Config File" })
vim.keymap.set("n", "<leader>fF", function() pick.builtin.files(nil, { source = { cwd = vim.fn.getcwd() } }) end, { desc = "Find Files (cwd)" })
vim.keymap.set("n", "<leader>,", function() pick.builtin.buffers() end, { desc = "Switch Buffer" })
vim.keymap.set("n", "<leader>fb", function() pick.builtin.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fr", function() extra.pickers.oldfiles() end, { desc = "Recent" })
vim.keymap.set("n", "<leader>fR", function() extra.pickers.oldfiles({ current_dir = true }) end, { desc = "Recent (cwd)" })

-- grep
vim.keymap.set("n", "<leader>/", function() pick.builtin.grep_live() end, { desc = "Grep" })
vim.keymap.set("n", "<leader>sg", function() pick.builtin.grep_live() end, { desc = "Grep (root dir)" })
vim.keymap.set("n", "<leader>sG", function() pick.builtin.grep_live(nil, { source = { cwd = vim.fn.getcwd() } }) end, { desc = "Grep (cwd)" })
vim.keymap.set("n", "<leader>sf", function() pick.builtin.grep_live(nil, { source = { cwd = vim.fn.expand("%:p:h") } }) end, { desc = "Grep current folder" })
vim.keymap.set("n", "<leader>sw", function() pick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end, { desc = "Word (root dir)" })
vim.keymap.set("n", "<leader>sW", function() pick.builtin.grep({ pattern = vim.fn.expand("<cword>") }, { source = { cwd = vim.fn.getcwd() } }) end, { desc = "Word (cwd)" })
vim.keymap.set("v", "<leader>sw", function() pick.builtin.grep({ pattern = visual_selection() }) end, { desc = "Selection (root dir)" })
vim.keymap.set("v", "<leader>sW", function() pick.builtin.grep({ pattern = visual_selection() }, { source = { cwd = vim.fn.getcwd() } }) end, { desc = "Selection (cwd)" })

-- git
vim.keymap.set("n", "<leader>gc", function() extra.pickers.git_commits() end, { desc = "commits" })
vim.keymap.set("n", "<leader>gs", function()
	pick.builtin.cli({
		command = { "git", "-c", "core.quotepath=false", "status", "--porcelain" },
		postprocess = function(lines)
			local res = {}
			for _, line in ipairs(lines) do
				if line ~= "" then
					local path = line:sub(4)
					res[#res + 1] = path:match(" -> (.+)") or path
				end
			end
			return res
		end,
	}, {
		source = {
			name = "Git status",
			show = function(buf_id, items, query) pick.default_show(buf_id, items, query, { show_icons = true }) end,
		},
	})
end, { desc = "status" })

-- search
vim.keymap.set("n", '<leader>s"', function() extra.pickers.registers() end, { desc = "Registers" })
vim.keymap.set("n", "<leader>sb", function() extra.pickers.buf_lines({ scope = "current" }) end, { desc = "Buffer" })
vim.keymap.set("n", "<leader>sc", function() extra.pickers.history({ scope = ":" }) end, { desc = "Command History" })
vim.keymap.set("n", "<leader>sC", function() extra.pickers.commands() end, { desc = "Commands" })
vim.keymap.set("n", "<leader>sd", function() extra.pickers.diagnostic({ scope = "current" }) end, { desc = "Document Diagnostics" })
vim.keymap.set("n", "<leader>sD", function() extra.pickers.diagnostic() end, { desc = "Workspace Diagnostics" })
vim.keymap.set("n", "<leader>sh", function() pick.builtin.help() end, { desc = "Help Pages" })
vim.keymap.set("n", "<leader>sH", function() extra.pickers.hl_groups() end, { desc = "Search Highlight Groups" })
vim.keymap.set("n", "<leader>sk", function() extra.pickers.keymaps() end, { desc = "Key Maps" })
vim.keymap.set("n", "<leader>sm", function() extra.pickers.marks() end, { desc = "Jump to Mark" })
vim.keymap.set("n", "<leader>so", function() extra.pickers.options() end, { desc = "Options" })
vim.keymap.set("n", "<leader>sR", function() pick.builtin.resume() end, { desc = "Resume" })
vim.keymap.set("n", "<leader>ss", function() extra.pickers.lsp({ scope = "document_symbol" }) end, { desc = "Symbols" })
vim.keymap.set("n", "<leader>uC", function() extra.pickers.colorschemes() end, { desc = "Colorscheme" })

-- stylua: ignore end
