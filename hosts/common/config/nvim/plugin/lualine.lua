vim.pack.add({
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

local function copilot()
	return vim.g.copilot_suggestion_enabled == false and "\u{f4b9}" or "\u{f4b8}"
end

local function autoformat()
	return vim.g.disable_autoformat and "fmt:off" or ""
end

local function recording()
	local reg = vim.fn.reg_recording()
	return reg ~= "" and ("recording @" .. reg) or ""
end

local function searchcount()
	local ok, result = pcall(vim.fn.searchcount, { reltime = vim.o.timeout / 1000 })
	if not ok or not result or result.incomplete == 1 then
		return ""
	end
	local total = result.total or 0
	if total == 0 then
		return ""
	end
	return string.format("%d/%d", result.current or 0, total)
end

require("lualine").setup({
	options = {
		theme = "jellybeans-nvim",
		globalstatus = true,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { "filename" },
		lualine_x = { copilot, autoformat, "encoding", "fileformat", "filetype", "filesize" },
		lualine_y = { searchcount },
		lualine_z = { recording, "location" },
	},
})

vim.o.showmode = false

-- The statusline only redraws on certain events, so force one for macros
vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
	command = "redrawstatus",
})
