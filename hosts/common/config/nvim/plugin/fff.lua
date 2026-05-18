vim.pack.add({ "https://github.com/dmtrKovalenko/fff.nvim" })

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "fff.nvim" and (kind == "install" or kind == "update") then
			if not ev.data.active then vim.cmd.packadd("fff.nvim") end
			require("fff.download").download_or_build_binary()
		end
	end,
})

vim.g.fff = {
	lazy_sync = true,
	layout = {
		height = 0.85,
		width = 0.85,
	},
	frecency = { enabled = true },
	history = { enabled = true },
}

-- stylua: ignore start

vim.keymap.set("n", "<leader><space>", function() require("fff").find_files() end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fc", function() require("fff").find_files_in_dir(vim.fn.stdpath("config")) end, { desc = "Find Config File" })
vim.keymap.set("n", "<leader>fF", function() require("fff").find_files_in_dir(vim.fn.getcwd()) end, { desc = "Find Files (cwd)" })
vim.keymap.set("n", "<leader>/", function() require("fff").live_grep() end, { desc = "Grep" })
vim.keymap.set("n", "<leader>sg", function() require("fff").live_grep() end, { desc = "Grep (root dir)" })
vim.keymap.set("n", "<leader>sG", function() require("fff").live_grep() end, { desc = "Grep (cwd)" })
vim.keymap.set("n", "<leader>sf", function() require("fff").live_grep() end, { desc = "Grep current folder" })
vim.keymap.set("n", "<leader>sw", function() require("fff").live_grep({ query = vim.fn.expand("<cword>") }) end, { desc = "Word (root dir)" })
vim.keymap.set("n", "<leader>sW", function() require("fff").live_grep({ query = vim.fn.expand("<cword>") }) end, { desc = "Word (cwd)" })
vim.keymap.set("v", "<leader>sw", function()
	local saved = vim.fn.getreg("v")
	vim.cmd('normal! "vy')
	local text = vim.fn.getreg("v")
	vim.fn.setreg("v", saved)
	require("fff").live_grep({ query = text })
end, { desc = "Selection (root dir)" })
vim.keymap.set("v", "<leader>sW", function()
	local saved = vim.fn.getreg("v")
	vim.cmd('normal! "vy')
	local text = vim.fn.getreg("v")
	vim.fn.setreg("v", saved)
	require("fff").live_grep({ query = text })
end, { desc = "Selection (cwd)" })

-- stylua: ignore end
