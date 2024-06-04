return {
	"SmiteshP/nvim-navic",
	config = function()
		require("config.plugins.edition.navic").setup()
	end,
	event = "User FileOpened",
}
