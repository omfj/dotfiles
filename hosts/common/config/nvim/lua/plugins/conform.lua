return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = { "n", "v" },
			desc = "Format",
		},
		{
			"<leader>uF",
			function()
				vim.g.disable_autoformat = not vim.g.disable_autoformat
				if vim.g.disable_autoformat then
					vim.notify("Autoformat disabled")
				else
					vim.notify("Autoformat enabled")
				end
			end,
			desc = "Toggle autoformat",
		},
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			javascriptreact = { "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "prettierd", "prettier", stop_after_first = true },
			svelte = { "prettierd", "prettier", stop_after_first = true },
			css = { "prettierd", "prettier", stop_after_first = true },
			html = { "prettierd", "prettier", stop_after_first = true },
			json = { "prettierd", "prettier", stop_after_first = true },
			markdown = { "prettierd", "prettier", stop_after_first = true },
			mdx = { "prettierd", "prettier", stop_after_first = true },
			astro = { "prettierd", "prettier", stop_after_first = true },
			python = { "ruff_format", "ruff_organize_imports" },
			kotlin = { "ktlint" },
			typst = { "typstyle" },
			go = { "goimports", "gofumpt" },
			toml = { "taplo" },
			rust = { "rustfmt" },
		},
		formatters = {
			prettier = {
				require_cwd = true,
			},
			prettierd = {
				require_cwd = true,
			},
		},
		format_on_save = function(bufnr)
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			return { timeout_ms = 2000, lsp_fallback = true }
		end,
	},
}
