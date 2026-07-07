vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.nvim" },
})

local MiniFiles = require("mini.files")

MiniFiles.setup({
	windows = {
		preview = true,
		width_focus = 30,
		width_preview = 40,
	},
})

-- Toggle at the current file (falls back to cwd for unnamed buffers)
vim.keymap.set("n", "<leader>e", function()
	if not MiniFiles.close() then
		local path = vim.api.nvim_buf_get_name(0)
		if path == "" or not vim.uv.fs_stat(path) then
			path = nil
		end
		MiniFiles.open(path)
	end
end, { desc = "Toggle explorer" })

-- Toggle at cwd (previous state, like oil's float)
vim.keymap.set("n", "<leader>fo", function()
	if not MiniFiles.close() then
		MiniFiles.open()
	end
end, { desc = "Open explorer (cwd)" })
