local function blink_build(path)
	vim.notify("blink.cmp: building from source...", vim.log.levels.INFO)
	vim.system({ "cargo", "build", "--release" }, { cwd = path }, function(result)
		vim.schedule(function()
			if result.code == 0 then
				vim.notify("blink.cmp: build complete", vim.log.levels.INFO)
			else
				vim.notify("blink.cmp: build failed\n" .. (result.stderr or ""), vim.log.levels.ERROR)
			end
		end)
	end)
end

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "blink.cmp" and (kind == "install" or kind == "update") then
			blink_build(ev.data.path)
		end
	end,
})

local function blink_path()
	return vim.tbl_filter(function(p)
		return p:match("blink%.cmp$")
	end, vim.api.nvim_list_runtime_paths())[1]
end

vim.keymap.set("n", "<leader>dB", function()
	local path = blink_path()
	if path then
		blink_build(path)
	else
		vim.notify("blink.cmp: could not find install path", vim.log.levels.ERROR)
	end
end, { desc = "Build blink.cmp" })

-- Build on startup if the native binary is missing
vim.defer_fn(function()
	local path = blink_path()
	if not path then
		return
	end
	local ext = vim.fn.has("mac") == 1 and "dylib" or "so"
	local bin = path .. "/target/release/libblink_cmp_fuzzy." .. ext
	if vim.uv.fs_stat(bin) == nil then
		blink_build(path)
	end
end, 100)

vim.pack.add({
	{ src = "https://github.com/Saghen/blink.cmp" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
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
		["<C-e>"] = { "hide", "fallback" },
		["<CR>"] = { "accept", "fallback" },
		["<C-CR>"] = { "cancel", "fallback" },
		["<C-p>"] = { "show", "select_prev", "fallback" },
		["<C-n>"] = { "show", "select_next", "fallback" },
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
	},
	snippets = { preset = "default" },
	completion = {
		accept = { auto_brackets = { enabled = false } },
		list = {
			selection = {
				preselect = true,
				auto_insert = false,
			},
		},
		menu = {
			border = "single",
			winhighlight = "Normal:Normal,CursorLine:BlinkCmpMenuSelection,Search:None",
		},
		documentation = {
			auto_show = true,
			window = {
				border = "single",
				winhighlight = "Normal:Normal",
			},
		},
		ghost_text = { enabled = false },
	},
})

local function apply_blink_highlights()
	vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = "#222222" })
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
