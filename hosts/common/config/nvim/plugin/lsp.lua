vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/b0o/SchemaStore.nvim" },
})

vim.diagnostic.config({
	underline = true,
	update_in_insert = false,
	virtual_text = {
		spacing = 4,
		source = "if_many",
		prefix = "●",
		severity = { min = vim.diagnostic.severity.INFO },
	},
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "✘",
			[vim.diagnostic.severity.WARN] = "▲",
			[vim.diagnostic.severity.HINT] = "⚑",
			[vim.diagnostic.severity.INFO] = "»",
		},
	},
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
		end

		-- stylua: ignore start
		map("n", "gD", function() Snacks.picker.lsp_declarations() end, "Goto Declaration")
		map("n", "gd", function() Snacks.picker.lsp_definitions() end, "Goto Definition")
		map("n", "gri", function() Snacks.picker.lsp_implementations() end, "Goto Implementation")
		map("n", "grr", function() Snacks.picker.lsp_references() end, "Goto References")
		map("n", "gO", function() Snacks.picker.lsp_symbols() end, "Document Symbols")
		map("n", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")
		map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
		map({ "n", "v" }, "<C-.>", vim.lsp.buf.code_action, "Code Action")
		map("n", "<leader>cA", function() vim.lsp.buf.code_action({ context = { only = { "source" }, diagnostics = {} } }) end, "Source Action")
		-- stylua: ignore end
	end,
})

-- Completion capabilities are registered by blink.cmp's plugin/ file.

-- LSP servers to install and enable. Adding a language is one entry here.
local servers = {
	"lua_ls",
	"bashls",
	"denols",
	"ts_ls",
	"svelte",
	"astro",
	"html",
	"cssls",
	"emmet_language_server",
	"tailwindcss",
	"kotlin_language_server",
	"rust_analyzer",
	"eslint",
	"basedpyright",
	"ruff",
	"tinymist",
	"yamlls",
	"jsonls",
	"taplo",
	"gopls",
	"vue_ls",
	"oxlint",
	"zls",
	"jinja_lsp",
	"templ",
	"texlab",
	"harper_ls",
}

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = servers,
	automatic_enable = false,
})

-- harper_ls is always installed, but enabled through a persistent toggle
vim.lsp.enable(vim.tbl_filter(function(server)
	return server ~= "harper_ls"
end, servers))

local pt = require("util.persist_toggle")
pt.define("harper", {
	steps = {
		{
			label = "on",
			apply = function()
				vim.lsp.enable("harper_ls")
			end,
		},
		{
			label = "off",
			apply = function()
				vim.lsp.enable("harper_ls", false)
			end,
		},
	},
	default = 1,
})

vim.api.nvim_create_user_command("ToggleHarper", function()
	pt.cycle("harper")
end, { desc = "Toggle harper_ls spelling LSP" })
