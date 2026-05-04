local function blink_build()
	vim.notify("blink.cmp: downloading native library...", vim.log.levels.INFO)
	local ok, err = pcall(function()
		require("blink.cmp").build():wait(60000)
	end)
	if ok then
		vim.notify("blink.cmp: build complete", vim.log.levels.INFO)
	else
		vim.notify("blink.cmp: build failed\n" .. tostring(err), vim.log.levels.ERROR)
	end
end

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "blink.cmp" and (kind == "install" or kind == "update") then
			blink_build()
		end
	end,
})

vim.keymap.set("n", "<leader>dB", blink_build, { desc = "Build blink.cmp" })

vim.pack.add({
	{ src = "https://github.com/Saghen/blink.lib" },
	{ src = "https://github.com/Saghen/blink.cmp" },
})

local icons = {
	Text = "󰉿",
	Method = "󰆧",
	Function = "󰊕",
	Constructor = "",
	Field = "󰜢",
	Variable = "󰀫",
	Class = "󰠱",
	Interface = "",
	Module = "",
	Property = "󰜢",
	Unit = "󰑭",
	Value = "󰎠",
	Enum = "",
	Keyword = "󰌋",
	Snippet = "",
	Color = "󰏘",
	File = "󰈙",
	Reference = "󰈇",
	Folder = "󰉋",
	EnumMember = "",
	Constant = "󰏿",
	Struct = "󰙅",
	Event = "",
	Operator = "󰆕",
	TypeParameter = "",
}

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "blink-cmp-menu", "blink-cmp-documentation", "blink-cmp-signature" },
	callback = function()
		vim.wo.colorcolumn = ""
		vim.wo.cursorcolumn = false
	end,
})

require("blink.cmp").setup({
	keymap = {
		preset = "none",
		["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-.>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-e>"] = { "hide", "fallback" },
		["<CR>"] = { "accept", "fallback" },
		["<C-CR>"] = { "cancel", "fallback" },
		["<C-p>"] = { "show", "select_prev", "fallback" },
		["<C-n>"] = { "show", "select_next", "fallback" },
		["<Up>"] = { "select_prev", "fallback" },
		["<Down>"] = { "select_next", "fallback" },
		["<C-b>"] = { "scroll_documentation_up", "fallback" },
		["<C-f>"] = { "scroll_documentation_down", "fallback" },
		["<Tab>"] = {
			function(cmp)
				local copilot = require("copilot.suggestion")
				if copilot.is_visible() then
					copilot.accept()
					return true
				end
				if cmp.snippet_active() then
					return cmp.snippet_forward()
				end
			end,
			"fallback",
		},
		["<S-Tab>"] = {
			function(cmp)
				if cmp.snippet_active() then
					return cmp.snippet_backward()
				end
			end,
			"fallback",
		},
	},
	appearance = {
		kind_icons = icons,
		nerd_font_variant = "mono",
	},
	sources = {
		default = { "lsp", "path", "snippets" },
		providers = {
			snippets = {
				opts = {
					search_paths = { vim.fn.stdpath("config") .. "/snippets" },
				},
			},
		},
	},
	completion = {
		accept = { auto_brackets = { enabled = false } },
		list = {
			selection = {
				preselect = true,
				auto_insert = false,
			},
		},
		menu = {
			winhighlight = "Normal:BlinkCmpMenu,CursorLine:BlinkCmpMenuSelection,Search:None",
		},
		documentation = {
			auto_show = true,
			window = {
				winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder",
			},
		},
		ghost_text = { enabled = false },
	},
})

local function apply_blink_highlights()
	vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "#151515" })
	vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = "#222222" })
	vim.api.nvim_set_hl(0, "BlinkCmpLabelDetail", { bg = "#151515", fg = "#555555", italic = true })
	vim.api.nvim_set_hl(0, "BlinkCmpLabelDescription", { bg = "#151515", fg = "#555555", italic = true })
	vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = "#151515" })
	vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { bg = "#151515" })
	vim.api.nvim_set_hl(0, "BlinkCmpDocSeparator", { bg = "#151515", fg = "#444444" })
	vim.api.nvim_set_hl(0, "BlinkCmpScrollBarThumb", { bg = "#444444" })
	vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { fg = "#fad07a", bold = true })
end

local kind_bg_cleared = false
local function clear_kind_bg()
	if kind_bg_cleared then
		return
	end
	kind_bg_cleared = true
	vim.api.nvim_set_hl(0, "BlinkCmpKind", { bg = "NONE" })
	for _, kind in ipairs(vim.tbl_values(vim.lsp.protocol.CompletionItemKind)) do
		if type(kind) == "string" then
			local name = "BlinkCmpKind" .. kind
			local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
			hl.bg = nil
			vim.api.nvim_set_hl(0, name, hl)
		end
	end
end

apply_blink_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		kind_bg_cleared = false
		apply_blink_highlights()
	end,
})
vim.api.nvim_create_autocmd("User", {
	pattern = "BlinkCmpMenuOpen",
	callback = function()
		require("copilot.suggestion").dismiss()
		clear_kind_bg()
	end,
})
