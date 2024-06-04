return {
	"folke/which-key.nvim",
	config = function()
		require("config.plugins.whichkey").setup()
	end,
	cmd = "WhichKey",
	event = "VeryLazy",
}
