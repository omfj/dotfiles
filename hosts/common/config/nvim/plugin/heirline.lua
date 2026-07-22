vim.pack.add({
	{ src = "https://github.com/rebelot/heirline.nvim" },
})

local utils = require("heirline.utils")

local function colors()
	if vim.o.background == "light" then
		return {
			accent = "#234291",
			accent_fg = "#eeeeee",
			added = "#3f7d3b",
			bg = "#eeeeee",
			changed = "#876820",
			deleted = "#b64432",
			dim = "#7a8490",
			error = "#b64432",
			hint = "#5d5d5d",
			info = "#234291",
			modified = "#876820",
			muted = "#787878",
			readonly = "#787878",
			surface = "#e0dcd7",
			warn = "#876820",
		}
	end

	return {
		accent = "#8fbfdc",
		accent_fg = "#1f1f1f",
		added = "#a9dd9d",
		bg = "#151515",
		changed = "#f0922b",
		deleted = "#e03030",
		dim = "#b0b8c0",
		error = "#e03030",
		hint = "#888888",
		info = "#8fbfdc",
		modified = "#f0922b",
		muted = "#888888",
		readonly = "#888888",
		surface = "#2a2a2a",
		warn = "#f0922b",
	}
end

local function listed_buffers()
	return vim.tbl_filter(function(bufnr)
		return vim.bo[bufnr].buflisted
	end, vim.api.nvim_list_bufs())
end

local function buffer_index(bufnr)
	for index, buffer in ipairs(listed_buffers()) do
		if buffer == bufnr then
			return index
		end
	end
end

local function neo_tree_width()
	for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		local bufnr = vim.api.nvim_win_get_buf(winid)
		local _, col = unpack(vim.api.nvim_win_get_position(winid))
		if col == 0 and vim.bo[bufnr].filetype == "neo-tree" then
			return vim.api.nvim_win_get_width(winid) + 1
		end
	end
	return 0
end

local function status_color(bufnr, palette)
	local diagnostics = vim.diagnostic.count(bufnr)
	if (diagnostics[vim.diagnostic.severity.ERROR] or 0) > 0 then
		return palette.error
	end
	if (diagnostics[vim.diagnostic.severity.WARN] or 0) > 0 then
		return palette.warn
	end
	if (diagnostics[vim.diagnostic.severity.INFO] or 0) > 0 then
		return palette.info
	end
	if (diagnostics[vim.diagnostic.severity.HINT] or 0) > 0 then
		return palette.hint
	end

	if vim.bo[bufnr].modified then
		return palette.modified
	end

	local git = vim.b[bufnr].gitsigns_status_dict
	if git then
		if git.removed and git.removed > 0 then
			return palette.deleted
		end
		if git.changed and git.changed > 0 then
			return palette.changed
		end
		if git.added and git.added > 0 then
			return palette.added
		end
	end

	if vim.bo[bufnr].readonly or not vim.bo[bufnr].modifiable then
		return palette.readonly
	end
end

local Buffer = {
	init = function(self)
		self.index = buffer_index(self.bufnr)
		local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.bufnr), ":t")
		self.name = name ~= "" and name or "[No Name]"
	end,
	on_click = {
		callback = function(_, minwid)
			vim.api.nvim_win_set_buf(0, minwid)
		end,
		minwid = function(self)
			return self.bufnr
		end,
		name = "heirline_buffer",
	},
	{
		provider = function(self)
			return " " .. self.index .. " "
		end,
		hl = function(self)
			local palette = colors()
			if self.is_active then
				return { bg = palette.accent, fg = palette.accent_fg }
			end
			return { bg = palette.bg, fg = palette.muted }
		end,
	},
	{
		provider = function(self)
			return " " .. self.name .. " "
		end,
		hl = function(self)
			local palette = colors()
			local foreground = status_color(self.bufnr, palette)
			if self.is_active then
				return { bg = palette.surface, fg = foreground or palette.dim }
			end
			return { bg = palette.bg, fg = foreground or palette.muted }
		end,
	},
	{
		provider = " ",
		hl = function()
			return { bg = colors().bg }
		end,
	},
}

local NeoTreeOffset = {
	condition = function()
		return neo_tree_width() > 0
	end,
	provider = function()
		return string.rep(" ", neo_tree_width())
	end,
	hl = function()
		return { bg = colors().bg }
	end,
}

local BufferLine = utils.make_buflist(Buffer, nil, nil, listed_buffers, false)

require("heirline").setup({
	tabline = {
		hl = function()
			return { bg = colors().bg }
		end,
		update = {
			"BufAdd",
			"BufDelete",
			"BufEnter",
			"BufWritePost",
			"ColorScheme",
			"DiagnosticChanged",
			"TextChanged",
			"TextChangedI",
			"WinEnter",
			"WinNew",
			"WinClosed",
		},
		NeoTreeOffset,
		BufferLine,
		{ provider = "%=" },
	},
})

vim.o.showtabline = 2
vim.api.nvim_create_autocmd("User", {
	pattern = "GitSignsUpdate",
	callback = vim.schedule_wrap(function()
		vim.cmd.redrawtabline()
	end),
})

local bufremove = require("mini.bufremove")
bufremove.setup()

vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bc", function()
	bufremove.delete(0, false)
end, { desc = "Close current buffer" })
vim.keymap.set("n", "<leader>bD", function()
	bufremove.delete(0, true)
end, { desc = "Delete Buffer (force)" })
vim.keymap.set("n", "<leader>bo", function()
	local current = vim.api.nvim_get_current_buf()
	for _, bufnr in ipairs(listed_buffers()) do
		if bufnr ~= current then
			bufremove.delete(bufnr, false)
		end
	end
end, { desc = "Delete Other Buffers" })

for index = 1, 9 do
	vim.keymap.set("n", "<C-w>" .. index, function()
		local bufnr = listed_buffers()[index]
		if bufnr then
			vim.api.nvim_set_current_buf(bufnr)
		end
	end, { desc = "Go to buffer " .. index })
end
