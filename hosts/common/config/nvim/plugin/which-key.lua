vim.pack.add({
	{ src = "https://github.com/folke/which-key.nvim" },
})

local wk = require("which-key")
wk.setup({ plugins = { spelling = true } })
wk.add({
	{ "<leader>:", icon = "󰋚" },
	{ "<leader>/", icon = "󰍉" },
	{ "<leader>a", group = "Agents", icon = "󰚩" },
	{ "<leader>b", group = "Buffers" },
	{ "<leader>d", group = "Dependencies", icon = "󰏗" },
	{ "<leader>du", function() vim.pack.update() end, desc = "Update (preview)" },
	{ "<leader>dU", function() vim.pack.update(nil, { force = true }) end, desc = "Update (apply all)" },
	{ "<leader>ds", function() vim.pack.update(nil, { target = "lockfile", force = true }) end, desc = "Sync to lockfile" },
	{ "<leader>C", group = "Crate (Rust)", icon = "󰏗" },
	{ "<leader>c", group = "Code" },
	{ "<leader>f", group = "Files" },
	{ "<leader>g", group = "Git" },
	{ "<leader>h", group = "Git Hunks" },
	{ "<leader>m", group = "Mason", icon = "󱌣" },
	{ "<leader>q", group = "Sessions" },
	{ "<leader>s", group = "Search" },
	{ "<leader>t", group = "Toggle" },
	{ "<leader>u", group = "UI" },
	{ "<leader>w", group = "Windows" },
	{ "<leader>x", group = "Diagnostics" },
	{ "<leader><tab>", group = "Tabs" },
})
