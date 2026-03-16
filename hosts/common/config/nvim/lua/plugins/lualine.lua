return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				globalstatus = true,
			},
			sections = {
				lualine_b = {
					"branch",
					{
						"diff",
						source = function()
							local gs = vim.b.gitsigns_status_dict
							if not gs then
								return nil
							end
							return { added = gs.added, modified = gs.changed, removed = gs.removed }
						end,
					},
				},
				lualine_c = { "filename" },
				lualine_x = {
					{
						"diagnostics",
						sources = { "nvim_lsp" },
					},
					{
						function()
							if vim.g.copilot_suggestion_enabled == false then return "\u{f4b9}" end -- copilot disabled icon (nerd font)
							return "\u{f4b8}" -- copilot icon (nerd font)
						end,
					},
					{
						function()
							return vim.g.disable_autoformat and "fmt:off" or ""
						end,
					},
					"encoding",
					"fileformat",
					"filetype",
				},
				lualine_y = {
					"searchcount",
					{
						function()
							local reg = vim.fn.reg_recording()
							return reg ~= "" and ("recording @" .. reg) or ""
						end,
					},
					"progress",
				},
				lualine_z = { "location" },
			},
		})
	end,
}
