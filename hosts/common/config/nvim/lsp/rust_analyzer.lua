return {
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
}
