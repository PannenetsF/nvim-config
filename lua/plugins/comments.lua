return {
	"numToStr/Comment.nvim",
	config = function()
		require("config.plugins.edition.comments").setup()
	end,
	keys = { { "gc", mode = { "n", "v" } }, { "gb", mode = { "n", "v" } } },
	event = "User FileOpened",
}
