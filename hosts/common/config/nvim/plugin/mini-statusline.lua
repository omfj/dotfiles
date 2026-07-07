vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.nvim" },
})

local statusline = require("mini.statusline")

statusline.setup({
	content = {
		active = function()
			local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
			local git = statusline.section_git({ trunc_width = 40 })
			local diff = statusline.section_diff({ trunc_width = 75 })
			local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
			local filename = statusline.section_filename({ trunc_width = 140 })
			local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
			local location = statusline.section_location({ trunc_width = 75 })
			local search = statusline.section_searchcount({ trunc_width = 75 })

			local copilot = vim.g.copilot_suggestion_enabled == false and "\u{f4b9}" or "\u{f4b8}"
			local autoformat = vim.g.disable_autoformat and "fmt:off" or ""
			local reg = vim.fn.reg_recording()
			local recording = reg ~= "" and ("recording @" .. reg) or ""

			return statusline.combine_groups({
				{ hl = mode_hl, strings = { mode } },
				{ hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics } },
				"%<", -- truncate point
				{ hl = "MiniStatuslineFilename", strings = { filename } },
				"%=", -- end of left alignment
				{ hl = "MiniStatuslineDevinfo", strings = { copilot, autoformat } },
				{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
				{ hl = mode_hl, strings = { recording, search, location } },
			})
		end,
	},
})

vim.o.laststatus = 3
vim.o.showmode = false

-- The statusline only redraws on certain events, so force one for macros
vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
	command = "redrawstatus",
})
