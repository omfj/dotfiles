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

-- stylua: ignore start
vim.keymap.set("n", "<leader>Du", function() vim.pack.update() end, { desc = "Update (preview)" })
vim.keymap.set("n", "<leader>DU", function() vim.pack.update(nil, { force = true }) end, { desc = "Update (apply all)" })
vim.keymap.set("n", "<leader>Ds", function() vim.pack.update(nil, { target = "lockfile", force = true }) end, { desc = "Sync to lockfile" })
-- stylua: ignore end
