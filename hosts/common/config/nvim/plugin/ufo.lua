local marker_open = { "//#startregion", "//#region", "{{{" }
local marker_close = { "//#endregion", "}}}" }

local function matches_any(line, patterns)
	for _, p in ipairs(patterns) do
		if line:find(p, 1, true) then
			return true
		end
	end
	return false
end

function _G.custom_foldexpr()
	local line = vim.api.nvim_buf_get_lines(0, vim.v.lnum - 1, vim.v.lnum, false)[1] or ""
	if matches_any(line, marker_open) then
		return ">1"
	elseif matches_any(line, marker_close) then
		return "<1"
	end
	return vim.lsp.foldexpr()
end

vim.opt.foldexpr = "v:lua.custom_foldexpr()"

vim.keymap.set("n", "K", function()
	if vim.fn.foldclosed(vim.fn.line(".")) ~= -1 then
		vim.cmd("normal! zo")
	else
		vim.lsp.buf.hover()
	end
end, { desc = "Open fold or hover" })
