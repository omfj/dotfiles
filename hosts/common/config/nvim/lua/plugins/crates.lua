return {
	"saecki/crates.nvim",
	tag = "stable",
	event = "BufRead Cargo.toml",
	keys = {
		-- Add to toggle group
		{
			"<leader>tC",
			function()
				require("crates").toggle()
			end,
			desc = "Toggle Crate Info",
			mode = { "n", "v" },
		},
		-- Crate actions
		{
			"<leader>C",
			nil,
			desc = "Crate actions",
		},
		{
			"<leader>Ca",
			function()
				require("crates").show_popup()
			end,
			desc = "Show Crate Info",
			mode = { "n", "v" },
		},
		{
			"<leader>Cu",
			function()
				require("crates").update_crate()
			end,
			desc = "Update Crate",
			mode = { "n", "v" },
		},
		{
			"<leader>Cr",
			function()
				require("crates").reload()
			end,
			desc = "Reload Crate Info",
			mode = { "n", "v" },
		},
		{
			"<leader>Cf",
			function()
				require("crates").show_features_popup()
			end,
			desc = "Open Crate Features",
			mode = { "n", "v" },
		},
		{
			"<leader>Ch",
			function()
				require("crates").open_homepage()
			end,
			desc = "Open Crate Homepage",
		},
		{
			"<leader>Cd",
			function()
				require("crates").open_documentation()
			end,
			desc = "Open Crate Documentation",
		},
	},
	config = function()
		require("crates").setup({
			lsp = {
				enabled = true,
				actions = true,
				completion = true,
				hover = true,
			},
			completion = {
				crates = {
					enabled = true,
					max_results = 5,
					min_chars = 3,
				},
			},
		})
	end,
}
