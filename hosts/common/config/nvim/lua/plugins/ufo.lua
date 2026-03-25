return {
	{
		"kevinhwang91/nvim-ufo",
		dependencies = { "kevinhwang91/promise-async" },
		event = "BufReadPost",
		keys = {
			{
				"zR",
				function()
					require("ufo").openAllFolds()
				end,
				desc = "Open all folds",
			},
			{
				"zM",
				function()
					require("ufo").closeAllFolds()
				end,
				desc = "Close all folds",
			},
			{
				"zr",
				function()
					require("ufo").openFoldsExceptKinds()
				end,
				desc = "Open folds except kinds",
			},
			{
				"zm",
				function()
					require("ufo").closeFoldsWith()
				end,
				desc = "Close folds with",
			},
		{
			"K",
			function()
				-- Only peek fold if cursor is actually on a closed fold.
				-- This prevents ufo's global K from shadowing the buffer-local LSP hover.
				local foldclosed = vim.fn.foldclosed(vim.fn.line("."))
				if foldclosed ~= -1 then
					require("ufo").peekFoldedLinesUnderCursor()
				else
					vim.lsp.buf.hover()
				end
			end,
			desc = "Peek fold or hover",
		},
		},
		opts = {
			provider_selector = function()
				return { "treesitter", "indent" }
			end,
		},
	},
}
