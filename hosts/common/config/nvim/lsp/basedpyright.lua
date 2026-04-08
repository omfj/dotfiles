return {
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
}
