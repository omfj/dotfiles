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
	{ src = "https://github.com/b0o/SchemaStore.nvim" },
	{ src = "https://github.com/mfussenegger/nvim-jdtls" },
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
		vim.keymap.set("n", "gD", function() require("mini.extra").pickers.lsp({ scope = "declaration" }) end, vim.tbl_extend("force", opts, { desc = "Goto Declaration" }))
		vim.keymap.set("n", "gd", function() require("mini.extra").pickers.lsp({ scope = "definition" }) end, vim.tbl_extend("force", opts, { desc = "Goto Definition" }))
		vim.keymap.set("n", "gri", function() require("mini.extra").pickers.lsp({ scope = "implementation" }) end, vim.tbl_extend("force", opts, { desc = "Goto Implementation" }))
		vim.keymap.set("n", "grr", function() require("mini.extra").pickers.lsp({ scope = "references" }) end, vim.tbl_extend("force", opts, { desc = "Goto References" }))
		vim.keymap.set("n", "gra", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Actions" }))
		vim.keymap.set("n", "grn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
		vim.keymap.set("n", "gO", function() require("mini.extra").pickers.lsp({ scope = "document_symbol" }) end, vim.tbl_extend("force", opts, { desc = "Document Symbols" }))
		vim.keymap.set("n", "<leader>cS", function() require("util.copilot-rename").suggest() end, vim.tbl_extend("force", opts, { desc = "Suggest name (Copilot)" }))
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

-- LSP servers to enable, mapped to the Mason package that provides them
-- (false = installed outside Mason). Adding a language is one entry here.
local servers = {
	lua_ls = "lua-language-server",
	bashls = "bash-language-server",
	denols = "deno",
	ts_ls = "typescript-language-server",
	svelte = "svelte-language-server",
	astro = "astro-language-server",
	html = "html-lsp",
	cssls = "css-lsp",
	emmet_language_server = "emmet-language-server",
	tailwindcss = "tailwindcss-language-server",
	kotlin_language_server = "kotlin-language-server",
	clojure_lsp = "clojure-lsp",
	rust_analyzer = "rust-analyzer",
	eslint = "eslint-lsp",
	basedpyright = "basedpyright",
	ruff = "ruff",
	tinymist = "tinymist",
	yamlls = "yaml-language-server",
	jsonls = "json-lsp",
	taplo = "taplo",
	gopls = "gopls",
	vue_language_server = "vue-language-server",
	oxlint = "oxlint",
	zls = "zls",
	jinja_lsp = "jinja-lsp",
	templ = "templ",
	texlab = "texlab",
	harper_ls = "harper-ls",
}

-- Optionally enable Harper LSP if not disabled (still installed, so :ToggleHarper works)
local harper_disabled = vim.uv.fs_stat(vim.fn.stdpath("data") .. "/harper_disabled") ~= nil

local enabled_servers = {}
for server in pairs(servers) do
	if server ~= "harper_ls" or not harper_disabled then
		table.insert(enabled_servers, server)
	end
end

vim.lsp.enable(enabled_servers)

-- Mason setup
require("mason").setup()

-- Non-LSP tools (formatters, linters, debug adapters)
local tools = {
	"stylua",
	"shfmt",
	"prettierd",
	"prettier",
	"ktlint",
	"typstyle",
	"goimports",
	"gofumpt",
	"fixjson",
	"djlint",
	"clang-format",
	"jdtls",
	"java-debug-adapter",
	"google-java-format",
	"delve",
	"js-debug-adapter",
	"codelldb",
}

-- mason.nvim has no ensure_installed setting, so install missing packages
-- ourselves: every tool plus the Mason package for each enabled server
local ensure_installed = vim.deepcopy(tools)
for _, pkg in pairs(servers) do
	if pkg then
		table.insert(ensure_installed, pkg)
	end
end

vim.api.nvim_create_autocmd("VimEnter", {
	once = true,
	callback = function()
		local registry = require("mason-registry")
		local missing = vim.tbl_filter(function(name)
			local ok, pkg = pcall(registry.get_package, name)
			return not ok or not pkg:is_installed()
		end, ensure_installed)
		if #missing == 0 then
			return
		end
		registry.refresh(function()
			for _, name in ipairs(missing) do
				local ok, pkg = pcall(registry.get_package, name)
				if ok and not pkg:is_installed() then
					pkg:install()
				end
			end
		end)
	end,
})
