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
		local opts = { buffer = ev.buf }

		-- stylua: ignore start
		vim.keymap.set("n", "gD", function() require("mini.extra").pickers.lsp({ scope = "declaration" }) end, vim.tbl_extend("force", opts, { desc = "Goto Declaration" }))
		vim.keymap.set("n", "gd", function() require("mini.extra").pickers.lsp({ scope = "definition" }) end, vim.tbl_extend("force", opts, { desc = "Goto Definition" }))
		vim.keymap.set("n", "gri", function() require("mini.extra").pickers.lsp({ scope = "implementation" }) end, vim.tbl_extend("force", opts, { desc = "Goto Implementation" }))
		vim.keymap.set("n", "grr", function() require("mini.extra").pickers.lsp({ scope = "references" }) end, vim.tbl_extend("force", opts, { desc = "Goto References" }))
		vim.keymap.set("n", "gra", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Actions" }))
		vim.keymap.set("n", "grn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
		vim.keymap.set("n", "gO", function() require("mini.extra").pickers.lsp({ scope = "document_symbol" }) end, vim.tbl_extend("force", opts, { desc = "Document Symbols" }))
		-- stylua: ignore end
		vim.keymap.set("n", "<leader>K", function()
			vim.lsp.buf.hover()
		end, { desc = "Hover" })
		vim.keymap.set(
			"n",
			"<C-k>",
			vim.lsp.buf.signature_help,
			vim.tbl_extend("force", opts, { desc = "Signature Help" })
		)
		vim.keymap.set(
			{ "n", "v" },
			"<leader>ca",
			vim.lsp.buf.code_action,
			vim.tbl_extend("force", opts, { desc = "Code Action" })
		)
		vim.keymap.set("n", "<leader>cA", function()
			vim.lsp.buf.code_action({ context = { only = { "source" }, diagnostics = {} } })
		end, vim.tbl_extend("force", opts, { desc = "Source Action" }))
		vim.keymap.set(
			{ "n", "v" },
			"<C-.>",
			vim.lsp.buf.code_action,
			vim.tbl_extend("force", opts, { desc = "Code Action" })
		)
	end,
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_blink, blink = pcall(require, "blink.cmp")
if has_blink then
	capabilities = blink.get_lsp_capabilities(capabilities)
end
vim.lsp.config("*", { capabilities = capabilities })

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
	"clojure_lsp",
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

-- Optionally enable Harper LSP if not disabled (still installed, so :ToggleHarper works)
local harper_disabled = vim.uv.fs_stat(vim.fn.stdpath("data") .. "/harper_disabled") ~= nil

local enabled_servers = vim.tbl_filter(function(server)
	return server ~= "harper_ls" or not harper_disabled
end, servers)

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = enabled_servers,
	automatic_enable = false,
})

vim.lsp.enable(enabled_servers)
