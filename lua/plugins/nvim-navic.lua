return {
	"SmiteshP/nvim-navic",
	config = function()
		require("config.plugins.navic").setup()
	end,
	event = "User FileOpened",
}
