-- Build hooks for plugins that require compilation steps.
-- Must be registered before any vim.pack.add() calls.
vim.api.nvim_create_autocmd("User", {
	pattern = "PackChanged",
	callback = function(ev)
		local name = ev.data.name
		local path = ev.data.path
		if name == "telescope-fzf-native.nvim" then
			vim.fn.system({ "make", "-C", path })
		elseif name == "LuaSnip" then
			vim.fn.system({ "make", "-C", path, "install_jsregexp" })
		elseif name == "mason.nvim" then
			vim.cmd("MasonUpdate")
		elseif name == "nvim-treesitter" then
			vim.schedule(function()
				vim.cmd("TSUpdate")
			end)
		end
	end,
})
