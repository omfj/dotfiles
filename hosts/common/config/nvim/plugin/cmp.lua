vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "LuaSnip" and (kind == "install" or kind == "update") then
			vim.system({ "make", "install_jsregexp" }, { cwd = ev.data.path })
		end
	end,
})

vim.pack.add({
	{ src = "https://github.com/hrsh7th/nvim-cmp" },
	{ src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
	{ src = "https://github.com/hrsh7th/cmp-path" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/saadparwaiz1/cmp_luasnip" },
})

require("luasnip.loaders.from_vscode").lazy_load()

vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

local cmp = require("cmp")
local luasnip = require("luasnip")
local defaults = require("cmp.config.default")()

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

cmp.setup({
	completion = {
		completeopt = "menu,menuone,noinsert",
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<S-CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<C-CR>"] = function(fallback)
			cmp.abort()
			fallback()
		end,
		["<Tab>"] = cmp.mapping(function(fallback)
			local copilot = require("copilot.suggestion")
			if copilot.is_visible() then
				copilot.accept()
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if luasnip.locally_jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp", group_index = 1 },
		{ name = "luasnip", group_index = 1 },
		{ name = "path", group_index = 1 },
	}),
	formatting = {
		format = function(_, item)
			if icons[item.kind] then
				item.kind = icons[item.kind] .. " " .. item.kind
			end
			return item
		end,
	},
	experimental = {
		ghost_text = false,
	},
	sorting = defaults.sorting,
})
