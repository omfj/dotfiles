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
		vim.keymap.set("n", "gi", function() Snacks.picker.lsp_implementations() end, vim.tbl_extend("force", opts, { desc = "Goto Implementation" }))
		vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
		vim.keymap.set("n", "<leader>cS", function() require("config.copilot-rename").suggest() end, vim.tbl_extend("force", opts, { desc = "Suggest name (Copilot)" }))
		vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end, vim.tbl_extend("force", opts, { desc = "Goto References" }))
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

-- Get capabilities for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_blink, blink = pcall(require, "blink.cmp")
if has_blink then
	capabilities = blink.get_lsp_capabilities(capabilities)
end

-- Set up language servers
local servers = {
	lua_ls = {
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				diagnostics = { globals = { "vim" } },
				workspace = {
					checkThirdParty = false,
					library = vim.api.nvim_get_runtime_file("", true),
				},
				completion = { callSnippet = "Replace" },
			},
		},
	},
	bashls = {},
	denols = {
		root_markers = { "deno.json", "deno.jsonc" },
	},
	ts_ls = {
		root_markers = { "package.json", "tsconfig.json" },
		init_options = {
			plugins = {
				{
					name = "@vue/typescript-plugin",
					location = vim.fn.expand("$MASON/packages/vue-language-server/node_modules/@vue/language-server"),
					languages = { "vue" },
				},
			},
		},
		filetypes = {
			"javascript",
			"javascriptreact",
			"javascript.jsx",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
			"vue",
		},
	},
	svelte = {},
	astro = {},
	html = {},
	cssls = {
		settings = {
			css = {
				lint = {
					unknownAtRules = "ignore",
				},
			},
		},
	},
	kotlin_language_server = {
		settings = {
			kotlin = {
				compiler = {
					jvm = {
						target = "17",
					},
				},
				completion = {
					snippets = {
						enabled = true,
					},
				},
			},
		},
	},
	rust_analyzer = {
		settings = {
			["rust-analyzer"] = {
				cargo = { allFeatures = true },
				checkOnSave = { command = "clippy" },
				imports = {
					granularity = {
						group = "module",
					},
					prefix = "self",
				},
				procMacro = {
					enable = true,
				},
			},
		},
	},
	eslint = {
		-- Don't activate when oxlint is present for this project
		root_dir = function(bufnr)
			local fname = type(bufnr) == "number" and vim.api.nvim_buf_get_name(bufnr) or bufnr
			if type(fname) ~= "string" or fname == "" then
				return nil
			end

			local path = vim.fs.dirname(fname)
			if
				vim.fs.find(
					{ ".oxlintrc.json", ".oxlintrc", "oxlint.json", "oxlint.jsonc" },
					{ upward = true, path = path }
				)[1]
			then
				return nil
			end
			return vim.fs.root(
				fname,
				{ "package.json", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json", ".eslintrc" }
			)
		end,
	},
	basedpyright = {
		settings = {
			basedpyright = {
				analysis = {
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					diagnosticMode = "openFilesOnly",
					diagnosticSeverityOverrides = {
						reportUnusedCallResult = "none",
						reportUnknownVariableType = "none",
						reportUnknownMemberType = "none",
						reportUnknownParameterType = "none",
						reportUnknownArgumentType = "none",
						reportMissingTypeArgument = "none",
						reportAny = "none",
						reportMissingParameterType = "none",
						reportDeprecated = "none",
						reportUnannotatedClassAttribute = "none",
					},
				},
			},
		},
		before_init = function(_, config)
			local cwd = vim.fn.getcwd()
			for _, name in ipairs({ ".venv", "venv", "env" }) do
				local venv = cwd .. "/" .. name
				if vim.fn.isdirectory(venv) == 1 then
					config.settings.basedpyright.pythonPath = venv .. "/bin/python"
					break
				end
			end
		end,
	},
	ruff = {},
	tinymist = {},
	yamlls = {
		on_attach = function(client)
			client.server_capabilities.documentFormattingProvider = false
		end,
	},
	jsonls = {
		settings = {
			json = {
				schemas = require("schemastore").json.schemas(),
				validate = { enable = true },
			},
		},
	},
	taplo = {},
	harper_ls = {
		settings = {
			["harper-ls"] = {
				isolateEnglish = true,
			},
		},
	},
	gopls = {
		settings = {
			gopls = {
				analyses = {
					unusedparams = true,
					shadow = true,
					ST1000 = false,
					ST1003 = false,
				},
				staticcheck = true,
				gofumpt = true,
			},
		},
	},
	vue_language_server = {
		filetypes = { "vue" },
	},
	oxlint = {
		root_markers = { ".oxlintrc.json" },
	},
}

local harper_disabled = vim.uv.fs_stat(vim.fn.stdpath("data") .. "/harper_disabled") ~= nil

for server, config in pairs(servers) do
	vim.lsp.config(
		server,
		vim.tbl_deep_extend("force", {
			capabilities = capabilities,
		}, config)
	)
	if not (server == "harper_ls" and harper_disabled) then
		vim.lsp.enable(server)
	end
end

-- Mason setup
require("mason").setup({
	ui = { border = "single" },
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
	},
})
