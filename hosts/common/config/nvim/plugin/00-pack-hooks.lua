local kind_icons = { install = "󰏗", update = "󰚰", remove = "󰆴" }

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		local installed_or_updated = kind == "install" or kind == "update"

		if name == "mason.nvim" and installed_or_updated then
			vim.schedule(function()
				if not ev.data.active then
					vim.cmd.packadd("mason.nvim")
				end
				vim.cmd("MasonUpdate")
			end)
		elseif name == "nvim-treesitter" and kind == "update" then
			vim.schedule(function()
				if not ev.data.active then
					vim.cmd.packadd("nvim-treesitter")
				end
				vim.cmd("TSUpdate")
			end)
		elseif name == "blink.cmp" and installed_or_updated then
			vim.schedule(function()
				vim.cmd("BlinkBuild")
			end)
		end

		vim.notify(name, vim.log.levels.INFO, { title = (kind_icons[kind] or "󰏗") .. " " .. kind })
	end,
})
