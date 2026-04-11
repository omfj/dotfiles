vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "mason.nvim" and (kind == "install" or kind == "update") then
			vim.schedule(function()
				if not ev.data.active then
					vim.cmd.packadd("mason.nvim")
				end
				vim.cmd("MasonUpdate")
			end)
		end
	end,
})

vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/b0o/SchemaStore.nvim" },
})

-- Set up diagnostics
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

-- LSP keymaps
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts = { buffer = ev.buf }

		-- stylua: ignore start
		vim.keymap.set("n", "gD", function() Snacks.picker.lsp_declarations() end, vim.tbl_extend("force", opts, { desc = "Goto Declaration" }))
		vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end, vim.tbl_extend("force", opts, { desc = "Goto Definition" }))
		vim.keymap.set("n", "gri", function() Snacks.picker.lsp_implementations() end, vim.tbl_extend("force", opts, { desc = "Goto Implementation" }))
		vim.keymap.set("n", "grr", function() Snacks.picker.lsp_references() end, vim.tbl_extend("force", opts, { desc = "Goto References" }))
		vim.keymap.set("n", "gra", function() Snacks.picker.lsp_code_actions() end, vim.tbl_extend("force", opts, { desc = "Code Actions" }))
		vim.keymap.set("n", "grn", function() Snacks.picker.lsp_rename() end, vim.tbl_extend("force", opts, { desc = "Rename" }))
		vim.keymap.set("n", "gO", function() Snacks.picker.lsp_symbols() end, vim.tbl_extend("force", opts, { desc = "Document Symbols" }))
		vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
		vim.keymap.set("n", "<leader>cS", function() require("config.copilot-rename").suggest() end, vim.tbl_extend("force", opts, { desc = "Suggest name (Copilot)" }))
		-- stylua: ignore end

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

-- Show LSP progress in the cmdline
vim.api.nvim_create_autocmd("LspProgress", {
	callback = function(ev)
		local value = ev.data.params.value
		vim.api.nvim_echo({ { value.message or "done" } }, false, {
			id = "lsp." .. ev.data.client_id,
			kind = "progress",
			source = "vim.lsp",
			title = value.title,
			status = value.kind ~= "end" and "running" or "success",
			percent = value.percentage,
		})
	end,
})

-- Get the latest LSP log
vim.api.nvim_create_user_command("LspLog", function(_)
	local state_path = vim.fn.stdpath("state")
	local log_path = vim.fs.joinpath(state_path, "lsp.log")

	vim.cmd(string.format("edit %s", log_path))
end, {
	desc = "Show LSP log",
})

-- Restart the LSP servers
vim.api.nvim_create_user_command("LspRestart", "lsp restart", {
	desc = "Restart LSP",
})

vim.api.nvim_create_user_command("LspInfo", "checkhealth vim.lsp", {
	desc = "Check LSP health",
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_blink, blink = pcall(require, "blink.cmp")
if has_blink then
	capabilities = blink.get_lsp_capabilities(capabilities)
end
vim.lsp.config("*", { capabilities = capabilities })

local servers = {
	"lua_ls",
	"bashls",
	"denols",
	"ts_ls",
	"svelte",
	"astro",
	"html",
	"cssls",
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
	"vue_language_server",
	"oxlint",
	"zls",
}

-- Optionally enable Harper LSP if not disabled
local harper_disabled = vim.uv.fs_stat(vim.fn.stdpath("data") .. "/harper_disabled") ~= nil
if not harper_disabled then
	table.insert(servers, "harper_ls")
end

vim.lsp.enable(servers)

-- Mason setup
require("mason").setup({
	ui = {},
	ensure_installed = {
		"stylua",
		"lua-language-server",
		"shfmt",
		"bash-language-server",
		"typescript-language-server",
		"deno",
		"svelte-language-server",
		"astro-language-server",
		"html-lsp",
		"css-lsp",
		"tailwindcss-language-server",
		"kotlin-language-server",
		"rust-analyzer",
		"eslint-lsp",
		"oxlint",
		"prettierd",
		"prettier",
		"ktlint",
		"tinymist",
		"typstyle",
		"gopls",
		"goimports",
		"gofumpt",
		"yaml-language-server",
		"taplo",
		"basedpyright",
		"ruff",
		"harper-ls",
		"fixjson",
		"json-lsp",
		"vue-language-server",
		"zls",
	},
})
