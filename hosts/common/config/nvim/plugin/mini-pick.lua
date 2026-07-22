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
vim.keymap.set("n", "<leader>,", function() pick.builtin.buffers() end, { desc = "Switch Buffer" })
vim.keymap.set("n", "<leader>fb", function() pick.builtin.buffers() end, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fr", function() extra.pickers.oldfiles() end, { desc = "Recent" })
vim.keymap.set("n", "<leader>fR", function() extra.pickers.oldfiles({ current_dir = true }) end, { desc = "Recent (cwd)" })

-- grep (mini.pick has no root-dir concept; everything is relative to cwd)
vim.keymap.set("n", "<leader>/", function() pick.builtin.grep_live() end, { desc = "Grep" })
vim.keymap.set("n", "<leader>sg", function() pick.builtin.grep_live() end, { desc = "Grep (cwd)" })
vim.keymap.set("n", "<leader>sf", function() pick.builtin.grep_live(nil, { source = { cwd = vim.fn.expand("%:p:h") } }) end, { desc = "Grep current folder" })
vim.keymap.set("n", "<leader>sw", function() pick.builtin.grep({ pattern = vim.fn.expand("<cword>") }) end, { desc = "Word (cwd)" })
vim.keymap.set("v", "<leader>sw", function() pick.builtin.grep({ pattern = visual_selection() }) end, { desc = "Selection (cwd)" })

-- git
vim.keymap.set("n", "<leader>gc", function() extra.pickers.git_commits() end, { desc = "commits" })
-- Show the two porcelain status columns before each path, colored like
-- `git status` (green = staged, red = unstaged, gray = untracked). Items are
-- tables: `text` is displayed/matched, `path` drives the icon and file opening.
local git_status_ns = vim.api.nvim_create_namespace("mini-pick-git-status")

local function git_status_show(buf_id, items, query)
	pick.default_show(buf_id, items, query, { show_icons = true })
	vim.api.nvim_buf_clear_namespace(buf_id, git_status_ns, 0, -1)
	local lines = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)
	for i, item in ipairs(items) do
		local line = lines[i]
		if line == nil then
			break
		end
		-- Locate where the item text starts in the rendered line (after the icon)
		local start = line:find(item.text, 1, true)
		if start then
			if item.status == "??" then
				vim.api.nvim_buf_set_extmark(buf_id, git_status_ns, i - 1, start - 1, { end_col = start + 1, hl_group = "Comment" })
			else
				local staged, unstaged = item.status:sub(1, 1), item.status:sub(2, 2)
				if staged ~= " " then
					vim.api.nvim_buf_set_extmark(buf_id, git_status_ns, i - 1, start - 1, { end_col = start, hl_group = "Added" })
				end
				if unstaged ~= " " then
					vim.api.nvim_buf_set_extmark(buf_id, git_status_ns, i - 1, start, { end_col = start + 1, hl_group = "Removed" })
				end
			end
		end
	end
end

vim.keymap.set("n", "<leader>gs", function()
	pick.builtin.cli({
		command = { "git", "-c", "core.quotepath=false", "status", "--porcelain" },
		postprocess = function(lines)
			local res = {}
			for _, line in ipairs(lines) do
				if line ~= "" then
					local status = line:sub(1, 2)
					local path = line:sub(4)
					res[#res + 1] = {
						text = status .. " " .. path,
						path = path:match(" -> (.+)") or path,
						status = status,
					}
				end
			end
			return res
		end,
	}, {
		source = {
			name = "Git status",
			show = git_status_show,
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
