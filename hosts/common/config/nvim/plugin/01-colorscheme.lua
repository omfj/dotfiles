vim.pack.add({
	{ src = "https://github.com/wtfox/jellybeans.nvim" },
	{ src = "https://github.com/f-person/auto-dark-mode.nvim" },
})

require("jellybeans").setup({
	flat_ui = false, -- bordered pickers instead of the blocky flat style
	-- auto-detection only works with lazy.nvim, so enable every plugin group
	plugins = { all = true },
})

-- jellybeans does not set 'background' itself
local function apply_dark()
	vim.o.background = "dark"
	vim.cmd.colorscheme("jellybeans-muted")
end

local function apply_light()
	vim.o.background = "light"
	vim.cmd.colorscheme("jellybeans-light")
end

if vim.fn.has("mac") == 1 then
	local style = vim.system({ "defaults", "read", "-g", "AppleInterfaceStyle" }, { text = true }):wait().stdout
	local appearance = style == "Dark\n" and "dark" or "light"
	if appearance == "dark" then
		apply_dark()
	else
		apply_light()
	end
	require("auto-dark-mode.interval").current_appearance = appearance
end

require("auto-dark-mode").setup({
	update_interval = 1000,
	set_dark_mode = apply_dark,
	set_light_mode = apply_light,
})
