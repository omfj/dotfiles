vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.nvim" },
})

local MiniFiles = require("mini.files")
local gitignore = require("util.mini_files_gitignore"):new()

MiniFiles.setup({
	windows = {
		preview = true,
		width_focus = 30,
		width_preview = 40,
	},
	content = {
		sort = function(fs_entries)
			return gitignore:sort_entries(fs_entries)
		end,
		highlight = function(fs_entry)
			local dir = vim.fs.dirname(fs_entry.path)
			if gitignore:is_ignored(dir, fs_entry.path) then
				return "Comment"
			end
			local status = gitignore:get_status(dir, fs_entry.path)
			if status == "new" then
				return "MiniFilesGitNew"
			elseif status == "modified" then
				return "MiniFilesGitModified"
			end
			return MiniFiles.default_highlight(fs_entry)
		end,
	},
})

vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesBufferCreate",
	callback = function(args)
		vim.keymap.set("n", ".", function()
			gitignore:toggle()
		end, { buffer = args.data.buf_id, desc = "Toggle gitignore dim" })
	end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		gitignore:cleanup()
	end,
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
