local marker_open = { "//#startregion", "#startregion", "//#region", "#region", "{{{" }
local marker_close = { "//#endregion", "#endregion", "}}}" }

local function matches_any(line, patterns)
	for _, p in ipairs(patterns) do
		if line:find(p, 1, true) then
			return true
		end
	end
	return false
end

function _G.custom_foldexpr()
	local line = vim.fn.getline(vim.v.lnum)
	if matches_any(line, marker_open) then
		return ">1"
	elseif matches_any(line, marker_close) then
		return "<1"
	end
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients > 0 then
		return vim.lsp.foldexpr()
	end
	return "0"
end

vim.opt.foldexpr = "v:lua.custom_foldexpr()"

vim.keymap.set("n", "K", function()
	if vim.fn.foldclosed(vim.fn.line(".")) ~= -1 then
		vim.cmd("normal! zo")
	else
		vim.lsp.buf.hover()
	end
end, { desc = "Open fold or hover" })
