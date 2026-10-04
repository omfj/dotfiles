local rustup_ra = vim.fn.expand("~/.cargo/bin/rust-analyzer")

return {
	cmd = vim.fn.executable(rustup_ra) == 1 and { rustup_ra } or nil,
	settings = {
		["rust-analyzer"] = {
			cargo = { allFeatures = true },
			check = { command = "clippy" },
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
