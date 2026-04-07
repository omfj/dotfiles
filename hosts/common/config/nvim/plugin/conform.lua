vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
})

require("conform").setup({
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
		javascript = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
		typescript = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
		javascriptreact = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
		typescriptreact = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
		svelte = { "prettierd", "prettier", stop_after_first = true },
		vue = { "prettierd", "prettier", stop_after_first = true },
		css = { "prettierd", "prettier", stop_after_first = true },
		html = { "prettierd", "prettier", stop_after_first = true },
		json = { "fixjson", "prettierd", "prettier", stop_after_first = true },
		markdown = { "prettierd", "prettier", stop_after_first = true },
		mdx = { "prettierd", "prettier", stop_after_first = true },
		astro = { "prettierd", "prettier", stop_after_first = true },
		python = { "ruff_format", "ruff_organize_imports" },
		kotlin = { "ktlint" },
		typst = { "typstyle" },
		go = { "goimports", "gofumpt" },
		toml = { "taplo" },
		rust = { "rustfmt" },
		zig = { "zigfmt" },
	},
	format_on_save = function(bufnr)
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		return { timeout_ms = 2000, lsp_fallback = true }
	end,
})

vim.keymap.set({ "n", "v" }, "<leader>cf", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format" })

vim.keymap.set("n", "<leader>uF", function()
	vim.g.disable_autoformat = not vim.g.disable_autoformat
	if vim.g.disable_autoformat then
		vim.notify("Autoformat disabled")
	else
		vim.notify("Autoformat enabled")
	end
end, { desc = "Toggle autoformat" })
