local function augroup(name)
	return vim.api.nvim_create_augroup("config_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	group = augroup("checktime"),
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = augroup("resize_splits"),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = { "help", "man", "qf", "query", "checkhealth" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true, desc = "Close window" })
	end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("wrap_spell"),
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = augroup("auto_create_dir"),
	callback = function(event)
		if event.match:match("^%w%w+:[\\/][\\/]") then
			return
		end
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- Restore persistent toggles
-- stylua: ignore start
local pt = require("util.persist_toggle")
pt.define("wrap", {
    steps = {
        { label = "off", apply = function() vim.opt.wrap = false; vim.opt.linebreak = false end },
        { label = "on",  apply = function() vim.opt.wrap = true;  vim.opt.linebreak = true  end },
    },
    default = 1,
})
pt.define("listchars", {
    steps = {
        { label = "on",  apply = function() vim.opt.list = true  end },
        { label = "off", apply = function() vim.opt.list = false end },
    },
    default = 1,
})
pt.define("conceal", {
    steps = {
        { label = "off (0)", apply = function() vim.opt.conceallevel = 0 end },
        { label = "on (2)",  apply = function() vim.opt.conceallevel = 2 end },
        { label = "full (3)", apply = function() vim.opt.conceallevel = 3 end },
    },
    default = 1,
})
pt.define("colorcolumn", {
    steps = {
	{ label = "off", apply = function() vim.opt.colorcolumn = "" end },
	{ label = "on",  apply = function() vim.opt.colorcolumn = "100" end },
    },
    default = 2,
})
pt.define("cursorline", {
    steps = {
	{ label = "off", apply = function() vim.opt.cursorline = false end },
	{ label = "on",  apply = function() vim.opt.cursorline = true  end },
    },
    default = 2,
})
pt.define("spelling", {
    steps = {
	{ label = "off", apply = function() vim.opt.spell = false end },
	{ label = "on",  apply = function() vim.opt.spell = true  end },
    },
    default = 1,
})
-- stylua: ignore end

-- Toggle relative line numbers based on mode, only restoring it if it was
-- on when insert mode was entered (so <leader>uL stays effective)
vim.api.nvim_create_autocmd("InsertEnter", {
	group = augroup("relnum_insert"),
	callback = function()
		vim.w.relnum_restore = vim.wo.relativenumber
		vim.wo.relativenumber = false
	end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
	group = augroup("relnum_insert_leave"),
	callback = function()
		if vim.w.relnum_restore then
			vim.wo.relativenumber = true
		end
		vim.w.relnum_restore = nil
	end,
})
