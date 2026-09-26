vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
})

local conform = require("conform")

local prettier = { "prettierd", "prettier", stop_after_first = true }
local oxfmt_or_prettier = { "oxfmt", "prettierd", "prettier", stop_after_first = true }

conform.setup({
	formatters = {
		oxfmt = {
			condition = function(_, ctx)
				return vim.fs.find({ ".oxfmtrc.json", ".oxfmtrc.jsonc" }, { path = ctx.filename, upward = true })[1]
					~= nil
			end,
		},
	},
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = oxfmt_or_prettier,
		typescript = oxfmt_or_prettier,
		javascriptreact = oxfmt_or_prettier,
		typescriptreact = oxfmt_or_prettier,
		svelte = prettier,
		vue = prettier,
		css = prettier,
		html = prettier,
		json = { "fixjson", "prettierd", "prettier", stop_after_first = true },
		markdown = prettier,
		mdx = prettier,
		astro = prettier,
		python = { "ruff_format", "ruff_organize_imports" },
		kotlin = { "ktlint" },
		typst = { "typstyle" },
		go = { "goimports", "gofumpt" },
		toml = { "taplo" },
		rust = { "rustfmt" },
		ocaml = { "ocamlformat" },
		zig = { "zigfmt" },
		c = { "clang_format" },
		cpp = { "clang_format" },
		jinja = { "djlint" },
		templ = { "templ" },
		java = { "google-java-format" },
		bib = { "bibtex-tidy" },
		sh = { "shfmt" },
		bash = { "shfmt" },
		zsh = { "shfmt" },
	},
	format_on_save = function(bufnr)
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		return { timeout_ms = 2000, lsp_format = "fallback" }
	end,
})

vim.keymap.set({ "n", "v" }, "<leader>cf", function()
	conform.format({ async = true, lsp_format = "fallback" })
end, { desc = "Format" })

vim.keymap.set("n", "<leader>uF", function()
	vim.g.disable_autoformat = not vim.g.disable_autoformat
	vim.notify("Autoformat " .. (vim.g.disable_autoformat and "disabled" or "enabled") .. " (global)")
end, { desc = "Toggle autoformat (global)" })
