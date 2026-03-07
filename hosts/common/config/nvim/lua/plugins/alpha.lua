return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	config = function()
		local startify = require("alpha.themes.startify")
		startify.file_icons.provider = "devicons"
		startify.file_icons.enabled = false
		require("alpha").setup(startify.config)
	end,
}
