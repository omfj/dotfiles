local function map(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = opts.silent ~= false
	if opts.remap and not vim.g.vscode then
		opts.remap = nil
	end
	vim.keymap.set(mode, lhs, rhs, opts)
end

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down" })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up" })

-- Resize window using <C-w> + HJKL
map("n", "<C-w>K", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-w>J", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-w>H", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-w>L", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- buffers (non-bufferline specific)
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
	"n",
	"<leader>ur",
	"<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
	{ desc = "Redraw / clear hlsearch / diff update" }
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Add undo break-points
map("i", ",", ",<c-g>u", { desc = "Undo breakpoint" })
map("i", ".", ".<c-g>u", { desc = "Undo breakpoint" })
map("i", ";", ";<c-g>u", { desc = "Undo breakpoint" })

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

--keywordprg
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- better indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- tools
map("n", "<leader>m", "<cmd>Mason<cr>", { desc = "Mason" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- copy relative path
map("n", "<leader>fy", function()
	local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":~:.")
	vim.fn.setreg("+", path)
	vim.notify("Copied: " .. path)
end, { desc = "Copy Relative Path" })

-- copy relative path with line range (visual mode)
map("v", "<leader>fy", function()
	local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":~:.")
	local start_line = vim.fn.line("v")
	local end_line = vim.fn.line(".")
	if start_line > end_line then
		start_line, end_line = end_line, start_line
	end
	local result = path .. "#" .. start_line .. "-" .. end_line
	vim.fn.setreg("+", result)
	vim.notify("Copied: " .. result)
end, { desc = "Copy Relative Path with Line Range" })

map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

map("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })

-- toggle cursorline
map("n", "<leader>uv", function()
	vim.wo.cursorline = not vim.wo.cursorline
end, { desc = "Toggle Cursorline" })

-- toggle colorcolumn
map("n", "<leader>uS", function()
	if vim.wo.colorcolumn == "" then
		vim.wo.colorcolumn = vim.g.colorcolumn or "100"
	else
		vim.wo.colorcolumn = ""
	end
end, { desc = "Toggle ColorColumn" })

-- formatting
map({ "n", "v" }, "<leader>cf", function()
	vim.lsp.buf.format({ async = true })
end, { desc = "Format" })

-- diagnostic
local diagnostic_goto = function(next, severity)
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		vim.diagnostic.jump({ count = next and 1 or -1, severity = severity })
	end
end

map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- stylua: ignore start

-- toggle options
map("n", "<leader>uf", function() vim.g.autoformat = not vim.g.autoformat end, { desc = "Toggle auto format (global)" })
map("n", "<leader>uF", function() vim.b.autoformat = not vim.b.autoformat end, { desc = "Toggle auto format (buffer)" })
map("n", "<leader>us", function() vim.wo.spell = not vim.wo.spell end, { desc = "Toggle Spelling" })
map("n", "<leader>uw", function() vim.wo.wrap = not vim.wo.wrap end, { desc = "Toggle Word Wrap" })
map("n", "<leader>uL", function() vim.wo.relativenumber = not vim.wo.relativenumber end, { desc = "Toggle Relative Line Numbers" })
map("n", "<leader>ul", function() vim.wo.number = not vim.wo.number end, { desc = "Toggle Line Numbers" })
map("n", "<leader>ud", function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end, { desc = "Toggle Diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map("n", "<leader>uc", function() vim.wo.conceallevel   = vim.wo.conceallevel == 0 and conceallevel or 0 end, { desc = "Toggle Conceal" })
if vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint then
  map("n", "<leader>uh", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, { desc = "Toggle Inlay Hints" })
end
map("n", "<leader>uT", function() if vim.b.ts_highlight then vim.treesitter.stop() else vim.treesitter.start() end end, { desc = "Toggle Treesitter Highlight" })
map("n", "<leader>uH", "<cmd>ToggleHarper<cr>", { desc = "Toggle Harper (spelling)" })
map("n", "<leader>uA", function()
  local buf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = buf })
  if #clients > 0 then
    vim.b.detached_lsp_clients = vim.tbl_map(function(c) return c.id end, clients)
    for _, client in ipairs(clients) do
      vim.lsp.buf_detach_client(buf, client.id)
    end
    vim.notify("LSP detached", vim.log.levels.INFO)
  else
    local ids = vim.b.detached_lsp_clients or {}
    for _, id in ipairs(ids) do
      local client = vim.lsp.get_client_by_id(id)
      if client then
        vim.lsp.buf_attach_client(buf, id)
      end
    end
    vim.b.detached_lsp_clients = nil
    vim.notify("LSP reattached", vim.log.levels.INFO)
  end
end, { desc = "Toggle LSP (buffer)" })

-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- highlights under cursor
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })

-- notifications
map("n", "<leader>sn", function() Snacks.notifier.show_history() end, { desc = "Notification History" })
map("n", "<leader>sN", function() Snacks.notifier.hide() end, { desc = "Dismiss Notifications" })



-- Terminal Mappings
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
map("t", "<C-w>h", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
map("t", "<C-w>j", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
map("t", "<C-w>k", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
map("t", "<C-w>l", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- windows
map("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
map("n", "<leader>w-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>w|", "<C-W>v", { desc = "Split window right", remap = true })
map("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
