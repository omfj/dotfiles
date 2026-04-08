return {
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
		return vim.fs.root(fname, { "package.json", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json", ".eslintrc" })
	end,
}
